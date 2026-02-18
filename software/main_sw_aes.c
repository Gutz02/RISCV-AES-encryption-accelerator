#include <stdint.h>
#include <stdio.h>

void print_u32_as_hex_bytes(uint32_t val) {
    printf("0x%02X \n", val & 0xFF);
    printf("0x%02X \n", (val >> 8)& 0xFF);
    printf("0x%02X \n", (val >> 16) & 0xFF);
    printf("0x%02X \n", (val >> 24)& 0xFF);
}


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

static inline void transpose4x32_le(const uint32_t in[4], uint32_t       out[4])
{
    for(int row = 0; row < 4; row++){
        uint32_t w = 0;
        // build out[row] by grabbing byte ’row’ from each in[col]
        for(int col = 0; col < 4; col++){
            uint32_t b = (in[col] >> (8 * row)) & 0xFF;
            w |= b << (8 * col);
        }
        out[row] = w;
    }
}

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

static inline uint32_t soft_aes32esi(uint32_t rs1, uint32_t rs2, uint8_t bs) {
    uint32_t shift = bs * 8;
    uint32_t x    = (rs2 >> shift) & 0xFF;
    uint32_t y    = sbox[x];
    return rs1 ^ (y << shift);
}

static inline uint8_t xtime(uint8_t x) {
    return (uint8_t)((x << 1) ^ ((x & 0x80) ? 0x1B : 0x00));
}

// GF(2^8) multiply of x * y
uint8_t gf_mult(uint8_t a, uint8_t b) {
    uint8_t p = 0;
    for (int i = 0; i < 8; i++) {
        if (b & 1) p ^= a;
        uint8_t hi_bit = a & 0x80;
        a <<= 1;
        if (hi_bit) a ^= 0x1b; // Reduce modulo 0x11b
        b >>= 1;
    }
    return p;
}
// 32-bit rotate-left
static inline uint32_t rotl32(uint32_t v, unsigned n) {
    return (v << n) | (v >> (32 - n));
}

/// software AES32ESMI: SubBytes + MixColumns + XOR one byte‐lane
static inline uint32_t soft_aes32esmi(uint32_t rs1, uint32_t rs2, uint8_t  bs){
    uint32_t shift = (uint32_t)bs * 8;
    // printf("0x%08x 0x%02x", rs2, (rs2 >> shift) & 0xFF);
    uint8_t  sub   = sbox[(rs2 >> shift) & 0xFF];
    // MixColumns on that single byte:

    uint32_t mixed = 0;

    if (bs == 0) {
        mixed = gf_mult(0x03,sub) << 24 | sub << 16 | sub << 8 | gf_mult(0x02,sub); 
    } else if (bs == 1) {
        mixed = sub << 24 | sub << 16 | gf_mult(0x02,sub) << 8 | gf_mult(0x03,sub); 
    } else if (bs == 2) {
        mixed = sub << 24 | gf_mult(0x02,sub) << 16 | gf_mult(0x03,sub) << 8 | sub; 
    } else {
        mixed = gf_mult(0x02,sub) << 24 | gf_mult(0x03,sub) << 16 | sub << 8 | sub; 
    }

    return mixed^rs1;
}

void expand_key_hweq(const uint8_t key[16], uint32_t round_keys[44]) {
    // load the original 16-byte key as four 32-bit little-endian words
    for(int i = 0; i < 4; i++) {
        round_keys[i] = load32_le(key + 4*i);
    }

    // now do rounds 1..10
    for(int i = 1; i < 12; i++) {
        int base = i << 2;

        uint32_t prev4 = round_keys[base - 1];
        uint32_t tr = (prev4 >>  8) | (prev4 << 24);   
        uint32_t t  = round_keys[base - 4] ^ (uint32_t)rcon[i - 1];
        t = soft_aes32esi(t, tr, 0);
        t = soft_aes32esi(t, tr, 1);
        t = soft_aes32esi(t, tr, 2);
        t = soft_aes32esi(t, tr, 3);

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
        // print_u32_as_hex_bytes(plaintext[i]);
    }

    // Middle Operations # 2-10
    for (int round = 1; round < 10; round++) {
        uint32_t *RK = round_hweq_keys + (round << 2);

        RK[0] = soft_aes32esmi(RK[0],state[0],0);
        RK[0] = soft_aes32esmi(RK[0],state[1],1);
        RK[0] = soft_aes32esmi(RK[0],state[2],2);
        RK[0] = soft_aes32esmi(RK[0],state[3],3);

        RK[1] = soft_aes32esmi(RK[1],state[1],0);
        RK[1] = soft_aes32esmi(RK[1],state[2],1);
        RK[1] = soft_aes32esmi(RK[1],state[3],2);
        RK[1] = soft_aes32esmi(RK[1],state[0],3);

        RK[2] = soft_aes32esmi(RK[2],state[2],0);
        RK[2] = soft_aes32esmi(RK[2],state[3],1);
        RK[2] = soft_aes32esmi(RK[2],state[0],2);
        RK[2] = soft_aes32esmi(RK[2],state[1],3);

        RK[3] = soft_aes32esmi(RK[3],state[3],0);
        RK[3] = soft_aes32esmi(RK[3],state[0],1);
        RK[3] = soft_aes32esmi(RK[3],state[1],2);
        RK[3] = soft_aes32esmi(RK[3],state[2],3);

        // printf("\n");
        // write back the 4 words of the new state column
        state[0] = RK[0];
        state[1] = RK[1];
        state[2] = RK[2];
        state[3] = RK[3];
    }

    // Final Round
    uint32_t *RK = &round_hweq_keys[40];
    RK[0] = soft_aes32esi(RK[0],state[0],0);
    RK[0] = soft_aes32esi(RK[0],state[1],1);
    RK[0] = soft_aes32esi(RK[0],state[2],2);
    RK[0] = soft_aes32esi(RK[0],state[3],3);

    RK[1] = soft_aes32esi(RK[1],state[1],0);
    RK[1] = soft_aes32esi(RK[1],state[2],1);
    RK[1] = soft_aes32esi(RK[1],state[3],2);
    RK[1] = soft_aes32esi(RK[1],state[0],3);

    RK[2] = soft_aes32esi(RK[2],state[2],0);
    RK[2] = soft_aes32esi(RK[2],state[3],1);
    RK[2] = soft_aes32esi(RK[2],state[0],2);
    RK[2] = soft_aes32esi(RK[2],state[1],3);

    RK[3] = soft_aes32esi(RK[3],state[3],0);
    RK[3] = soft_aes32esi(RK[3],state[0],1);
    RK[3] = soft_aes32esi(RK[3],state[1],2);
    RK[3] = soft_aes32esi(RK[3],state[2],3);

    state[0] = RK[0];
    state[1] = RK[1];
    state[2] = RK[2];
    state[3] = RK[3];
}

int main() {

    int32_t state[4] = {0xd510776c, 0xa8c81b9f, 0x5be8f84c, 0x4575d725};
    uint32_t roundkey = 0x17fefaa0;
    uint32_t inter_values[4];
    uint32_t expected_output[4] = {0xe7aeaa00, 0x4801efea, 0xd32c5971,0x0f9e371f};

    uintptr_t addr;
    uint32_t value;

    #pragma unroll 4
    for (int i = 0; i < 4 ; i++){
        roundkey = soft_aes32esmi(roundkey,state[i],i);
    }
    return roundkey;
}
