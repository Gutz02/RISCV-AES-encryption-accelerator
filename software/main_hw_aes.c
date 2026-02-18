#include <stdint.h>
#include <string.h>
// #define AES_BASE       ((volatile uint32_t*) 0x70000000)
// #define AES_OUTPUT     ((volatile uint32_t*) 0x70000004)

#define AES32ESMI(key, value, bs) \
    __asm__ volatile ( \
      "aes32esmi %0, %0, %1, %2\n" \
      : "+r"(key)              \
      : "r"(value),            \
        "I"(bs)                \
    ); 

#define AES32ESI(key, value, bs) \
    __asm__ volatile ( \
      "aes32esi %0, %0, %1, %2\n" \
      : "+r"(key)              \
      : "r"(value),            \
        "I"(bs)                \
    ); 

// S-box for SubBytes (precomputed substitution table)
static const uint8_t sbox[256] = {
    0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
    0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
    0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
    0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
    0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
    0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
    0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
    0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
    0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
    0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
    0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
    0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
    0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
    0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
    0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
    0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
};

// Round constants for key expansion
static const uint8_t rcon[10] = {
    0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36
};

static inline uint32_t load32_le(const uint8_t *k) {
    return  (uint32_t)k[0]        // k[0] → bits 7:0
          | (uint32_t)k[1] <<  8  // k[1] → bits 15:8
          | (uint32_t)k[2] << 16  // k[2] → bits 23:16
          | (uint32_t)k[3] << 24; // k[3] → bits 31:24
}

void merge_plaintext_into_state(const uint8_t in[16],
                                uint32_t    out[4])
{
    for(int i = 0; i < 4; i++) {
        out[i] = load32_le(in + 4*i);
    }
}

void expand_key_hweq(const uint8_t key[16], uint32_t round_keys[44]) {
    // load the original 16-byte key as four 32-bit little-endian words
    for(int i = 0; i < 4; i++) {
        round_keys[i] = load32_le(key + 4*i);
    }

    for(int i = 1; i < 11; i++) {
        int base = i << 2;

        uint32_t prev4 = round_keys[base - 1];
        uint32_t tr = (prev4 >>  8) | (prev4 << 24);   
        uint32_t t  = round_keys[base - 4] ^ (uint32_t)rcon[i - 1];
        AES32ESI(t, tr, 0);
        AES32ESI(t, tr, 1);
        AES32ESI(t, tr, 2);
        AES32ESI(t, tr, 3);

        // store W[i*4 + 0]
        round_keys[base + 0] = t;
        round_keys[base + 1] = round_keys[base + 0] ^ round_keys[base - 3];
        round_keys[base + 2] = round_keys[base + 1] ^ round_keys[base - 2];
        round_keys[base + 3] = round_keys[base + 2] ^ round_keys[base - 1];
    }
    
}

void aes128_ecb_encrypt(uint32_t *state, size_t len, uint8_t *key) {
    if (len % 16 != 0) {
        return;
    }

    uint32_t round_hweq_keys[44];
    expand_key_hweq(key, round_hweq_keys);
    // Inital addroundkey # 1

    for(int i = 0; i < 4 ; i+=1 ){
        state[i] ^= round_hweq_keys[i];
    }

    // Middle Operations # 2-10
    for (int round = 1; round < 10; round++) {
        uint32_t *RK = round_hweq_keys + (round << 2);

        #pragma clang loop unroll(full)
        for(int i = 0; i < 4; i++){
            AES32ESMI(RK[0],state[i],i);
            AES32ESMI(RK[1],state[(1+i) & 0x3],i);
            AES32ESMI(RK[2],state[(2+i) & 0x3],i);
            AES32ESMI(RK[3],state[(3+i) & 0x3],i);
        }
        // printf("\n");
        // write back the 4 words of the new state column
        state[0] = RK[0];
        state[1] = RK[1];
        state[2] = RK[2];
        state[3] = RK[3];
    }

    // Final Round
    uint32_t *RK = &round_hweq_keys[40];

    #pragma clang loop unroll(full)
    for(int i = 0; i < 4; i++){
        AES32ESI(RK[0],state[i],i);
        AES32ESI(RK[1],state[(1+i) & 0x3],i);
        AES32ESI(RK[2],state[(2+i) & 0x3],i);
        AES32ESI(RK[3],state[(3+i) & 0x3],i);
    }
    state[0] = RK[0];
    state[1] = RK[1];
    state[2] = RK[2];
    state[3] = RK[3];
}

void write_to_address(uintptr_t addr, uint32_t value) {
    *(volatile uint32_t *)addr = value;
}

void write_v_to_address(uintptr_t addr, uint32_t vector[4]) {
	for(int i = 0; i < 4; i++) {
        write_to_address(addr + i*0x4, vector[i]);
    }
}

int main()
{

    uint8_t plaintext[16] = {
        'H','e','l','l','o',',',' ','W',
        'o','r','l','d','!','0','0','0'
    };
    uint32_t state[4];
    merge_plaintext_into_state(plaintext, state);

    // Key: "cese4040password" (16 bytes)
    uint8_t key[16] = {
        'c', 'e', 's', 'e', '4', '0', '4', '0', 'p', 'a', 's', 's', 'w', 'o', 'r', 'd'
    }; 
    uint32_t expected_output[4] = {0xFBA50914, 0x714BF41F, 0x2E25AABE,0xAAF9080F};
    size_t len = 16; 
    uintptr_t addr;
    uint32_t value;

    aes128_ecb_encrypt(state, len, key);

    addr = 0x0100000 + 0x2000 + 0x30;
    write_v_to_address(addr, expected_output);
    
    addr = 0x0100000 + 0x2000 + 0x40;
    write_v_to_address(addr, state);

    // Check if calculated and expected match:
    addr = 0x0100000 + 0x2000 + 0x04;  // Some memory-mapped register or memory location
    value = 0xCAFEBABE; //Assume arrays match initially
    for (int i = 0; i < 4; i++) {
        write_to_address(addr, state[i]);
        if (state[i] != expected_output[i]) {
            value = 0xBAAAAAAB; // Set to false value if there's a mismatch
            break;
        }
    }

    write_to_address(0x42002040,state[0]);
    write_to_address(0x42002044,state[1]);
    write_to_address(0x42002048,state[2]);
    write_to_address(0x4200204C,state[3]);

    write_to_address(addr, value);

    addr = 0x0100000 + 0x2000; // SRAM base address is 0x0100000.
    value = 0xDEADBEEF;
    write_to_address(addr, value);

    return 0;

}

