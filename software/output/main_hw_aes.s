	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0_zcf1p0_zkne1p0"
	.file	"main_hw_aes.c"
	.option	push
	.option	arch, +a, +c, +d, +f, +m, +zaamo, +zalrsc, +zca, +zcd, +zcf, +zicsr, +zifencei, +zkne, +zmmul
	.text
	.globl	merge_plaintext_into_state      # -- Begin function merge_plaintext_into_state
	.p2align	1
	.type	merge_plaintext_into_state,@function
merge_plaintext_into_state:             # @merge_plaintext_into_state
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	sw	s1, 4(sp)                       # 4-byte Folded Spill
	mv	s0, a1
	mv	s1, a0
	call	load32_le
	sw	a0, 0(s0)
	addi	a0, s1, 4
	call	load32_le
	sw	a0, 4(s0)
	addi	a0, s1, 8
	call	load32_le
	sw	a0, 8(s0)
	addi	a0, s1, 12
	call	load32_le
	sw	a0, 12(s0)
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	lw	s1, 4(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	merge_plaintext_into_state, .Lfunc_end0-merge_plaintext_into_state
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +a, +c, +d, +f, +m, +zaamo, +zalrsc, +zca, +zcd, +zcf, +zicsr, +zifencei, +zkne, +zmmul
	.p2align	1                               # -- Begin function load32_le
	.type	load32_le,@function
load32_le:                              # @load32_le
# %bb.0:
	lbu	a1, 1(a0)
	lbu	a2, 0(a0)
	lbu	a3, 2(a0)
	lbu	a0, 3(a0)
	slli	a1, a1, 8
	or	a1, a1, a2
	slli	a3, a3, 16
	slli	a0, a0, 24
	or	a0, a0, a3
	or	a0, a0, a1
	ret
.Lfunc_end1:
	.size	load32_le, .Lfunc_end1-load32_le
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +a, +c, +d, +f, +m, +zaamo, +zalrsc, +zca, +zcd, +zcf, +zicsr, +zifencei, +zkne, +zmmul
	.globl	expand_key_hweq                 # -- Begin function expand_key_hweq
	.p2align	1
	.type	expand_key_hweq,@function
expand_key_hweq:                        # @expand_key_hweq
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	sw	s1, 4(sp)                       # 4-byte Folded Spill
	mv	s0, a1
	mv	s1, a0
	call	load32_le
	sw	a0, 0(s0)
	addi	a0, s1, 4
	call	load32_le
	sw	a0, 4(s0)
	addi	a0, s1, 8
	call	load32_le
	sw	a0, 8(s0)
	addi	a0, s1, 12
	call	load32_le
	sw	a0, 12(s0)
	addi	s0, s0, 16
	lui	a0, %hi(rcon)
	addi	a0, a0, %lo(rcon)
	li	a1, 10
	beqz	a1, .LBB2_2
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	lw	a2, -4(s0)
	lw	a3, -16(s0)
	lbu	a4, 0(a0)
	addi	a1, a1, -1
	srli	a5, a2, 8
	slli	a2, a2, 24
	xor	a3, a3, a4
	or	a2, a2, a5
	#APP
	aes32esi	a3, a3, a2, 0

	#NO_APP
	#APP
	aes32esi	a3, a3, a2, 1

	#NO_APP
	#APP
	aes32esi	a3, a3, a2, 2

	#NO_APP
	#APP
	aes32esi	a3, a3, a2, 3

	#NO_APP
	lw	a2, -12(s0)
	lw	a4, -8(s0)
	lw	a5, -4(s0)
	addi	a0, a0, 1
	xor	a2, a2, a3
	xor	a4, a4, a2
	xor	a5, a5, a4
	sw	a3, 0(s0)
	sw	a2, 4(s0)
	sw	a4, 8(s0)
	sw	a5, 12(s0)
	addi	s0, s0, 16
	bnez	a1, .LBB2_1
.LBB2_2:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	lw	s1, 4(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end2:
	.size	expand_key_hweq, .Lfunc_end2-expand_key_hweq
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +a, +c, +d, +f, +m, +zaamo, +zalrsc, +zca, +zcd, +zcf, +zicsr, +zifencei, +zkne, +zmmul
	.globl	aes128_ecb_encrypt              # -- Begin function aes128_ecb_encrypt
	.p2align	1
	.type	aes128_ecb_encrypt,@function
aes128_ecb_encrypt:                     # @aes128_ecb_encrypt
# %bb.0:
	andi	a1, a1, 15
	beqz	a1, .LBB3_2
# %bb.1:
	ret
.LBB3_2:
	addi	sp, sp, -192
	sw	ra, 188(sp)                     # 4-byte Folded Spill
	sw	s0, 184(sp)                     # 4-byte Folded Spill
	mv	s0, a0
	addi	a1, sp, 8
	mv	a0, a2
	call	expand_key_hweq
	lw	a6, 8(sp)
	lw	a7, 12(sp)
	lw	a2, 16(sp)
	lw	a3, 20(sp)
	lw	a4, 0(s0)
	lw	a5, 4(s0)
	lw	a0, 8(s0)
	lw	a1, 12(s0)
	xor	a4, a4, a6
	xor	a5, a5, a7
	xor	a2, a2, a0
	xor	a1, a1, a3
	li	a0, 9
	sw	a4, 0(s0)
	sw	a5, 4(s0)
	sw	a2, 8(s0)
	sw	a1, 12(s0)
	addi	a1, sp, 24
	beqz	a0, .LBB3_4
.LBB3_3:                                # =>This Inner Loop Header: Depth=1
	lw	a2, 0(a1)
	lw	a3, 0(s0)
	#APP
	aes32esmi	a2, a2, a3, 0

	#NO_APP
	lw	a3, 4(a1)
	lw	a4, 4(s0)
	sw	a2, 0(a1)
	#APP
	aes32esmi	a3, a3, a4, 0

	#NO_APP
	lw	a2, 8(a1)
	lw	a4, 8(s0)
	sw	a3, 4(a1)
	#APP
	aes32esmi	a2, a2, a4, 0

	#NO_APP
	lw	a3, 12(a1)
	lw	a4, 12(s0)
	sw	a2, 8(a1)
	#APP
	aes32esmi	a3, a3, a4, 0

	#NO_APP
	lw	a2, 0(a1)
	lw	a4, 4(s0)
	sw	a3, 12(a1)
	#APP
	aes32esmi	a2, a2, a4, 1

	#NO_APP
	lw	a3, 4(a1)
	lw	a4, 8(s0)
	sw	a2, 0(a1)
	#APP
	aes32esmi	a3, a3, a4, 1

	#NO_APP
	lw	a2, 8(a1)
	lw	a4, 12(s0)
	sw	a3, 4(a1)
	#APP
	aes32esmi	a2, a2, a4, 1

	#NO_APP
	lw	a3, 12(a1)
	lw	a4, 0(s0)
	sw	a2, 8(a1)
	#APP
	aes32esmi	a3, a3, a4, 1

	#NO_APP
	lw	a2, 0(a1)
	lw	a4, 8(s0)
	sw	a3, 12(a1)
	#APP
	aes32esmi	a2, a2, a4, 2

	#NO_APP
	lw	a3, 4(a1)
	lw	a4, 12(s0)
	sw	a2, 0(a1)
	#APP
	aes32esmi	a3, a3, a4, 2

	#NO_APP
	lw	a2, 8(a1)
	lw	a4, 0(s0)
	sw	a3, 4(a1)
	#APP
	aes32esmi	a2, a2, a4, 2

	#NO_APP
	lw	a3, 12(a1)
	lw	a4, 4(s0)
	sw	a2, 8(a1)
	#APP
	aes32esmi	a3, a3, a4, 2

	#NO_APP
	lw	a2, 0(a1)
	lw	a4, 12(s0)
	sw	a3, 12(a1)
	#APP
	aes32esmi	a2, a2, a4, 3

	#NO_APP
	lw	a3, 4(a1)
	lw	a4, 0(s0)
	sw	a2, 0(a1)
	#APP
	aes32esmi	a3, a3, a4, 3

	#NO_APP
	lw	a2, 8(a1)
	lw	a4, 4(s0)
	sw	a3, 4(a1)
	#APP
	aes32esmi	a2, a2, a4, 3

	#NO_APP
	lw	a3, 12(a1)
	lw	a4, 8(s0)
	addi	a0, a0, -1
	sw	a2, 8(a1)
	#APP
	aes32esmi	a3, a3, a4, 3

	#NO_APP
	lw	a2, 0(a1)
	lw	a4, 4(a1)
	lw	a5, 8(a1)
	sw	a3, 12(a1)
	sw	a2, 0(s0)
	sw	a4, 4(s0)
	sw	a5, 8(s0)
	sw	a3, 12(s0)
	addi	a1, a1, 16
	bnez	a0, .LBB3_3
.LBB3_4:
	lw	a0, 168(sp)
	lw	a1, 0(s0)
	#APP
	aes32esi	a0, a0, a1, 0

	#NO_APP
	lw	a1, 172(sp)
	lw	a2, 4(s0)
	sw	a0, 168(sp)
	#APP
	aes32esi	a1, a1, a2, 0

	#NO_APP
	lw	a0, 176(sp)
	lw	a2, 8(s0)
	sw	a1, 172(sp)
	#APP
	aes32esi	a0, a0, a2, 0

	#NO_APP
	lw	a1, 180(sp)
	lw	a2, 12(s0)
	sw	a0, 176(sp)
	#APP
	aes32esi	a1, a1, a2, 0

	#NO_APP
	lw	a0, 168(sp)
	lw	a2, 4(s0)
	sw	a1, 180(sp)
	#APP
	aes32esi	a0, a0, a2, 1

	#NO_APP
	lw	a1, 172(sp)
	lw	a2, 8(s0)
	sw	a0, 168(sp)
	#APP
	aes32esi	a1, a1, a2, 1

	#NO_APP
	lw	a0, 176(sp)
	lw	a2, 12(s0)
	sw	a1, 172(sp)
	#APP
	aes32esi	a0, a0, a2, 1

	#NO_APP
	lw	a1, 180(sp)
	lw	a2, 0(s0)
	sw	a0, 176(sp)
	#APP
	aes32esi	a1, a1, a2, 1

	#NO_APP
	lw	a0, 168(sp)
	lw	a2, 8(s0)
	sw	a1, 180(sp)
	#APP
	aes32esi	a0, a0, a2, 2

	#NO_APP
	lw	a1, 172(sp)
	lw	a2, 12(s0)
	sw	a0, 168(sp)
	#APP
	aes32esi	a1, a1, a2, 2

	#NO_APP
	lw	a0, 176(sp)
	lw	a2, 0(s0)
	sw	a1, 172(sp)
	#APP
	aes32esi	a0, a0, a2, 2

	#NO_APP
	lw	a1, 180(sp)
	lw	a2, 4(s0)
	sw	a0, 176(sp)
	#APP
	aes32esi	a1, a1, a2, 2

	#NO_APP
	lw	a0, 168(sp)
	lw	a2, 12(s0)
	sw	a1, 180(sp)
	#APP
	aes32esi	a0, a0, a2, 3

	#NO_APP
	lw	a1, 172(sp)
	lw	a2, 0(s0)
	sw	a0, 168(sp)
	#APP
	aes32esi	a1, a1, a2, 3

	#NO_APP
	lw	a0, 176(sp)
	lw	a2, 4(s0)
	sw	a1, 172(sp)
	#APP
	aes32esi	a0, a0, a2, 3

	#NO_APP
	lw	a1, 180(sp)
	lw	a2, 8(s0)
	sw	a0, 176(sp)
	#APP
	aes32esi	a1, a1, a2, 3

	#NO_APP
	lw	a0, 168(sp)
	lw	a2, 172(sp)
	lw	a3, 176(sp)
	sw	a0, 0(s0)
	sw	a2, 4(s0)
	sw	a3, 8(s0)
	sw	a1, 12(s0)
	lw	ra, 188(sp)                     # 4-byte Folded Reload
	lw	s0, 184(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 192
	ret
.Lfunc_end3:
	.size	aes128_ecb_encrypt, .Lfunc_end3-aes128_ecb_encrypt
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +a, +c, +d, +f, +m, +zaamo, +zalrsc, +zca, +zcd, +zcf, +zicsr, +zifencei, +zkne, +zmmul
	.globl	write_to_address                # -- Begin function write_to_address
	.p2align	1
	.type	write_to_address,@function
write_to_address:                       # @write_to_address
# %bb.0:
	sw	a1, 0(a0)
	ret
.Lfunc_end4:
	.size	write_to_address, .Lfunc_end4-write_to_address
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +a, +c, +d, +f, +m, +zaamo, +zalrsc, +zca, +zcd, +zcf, +zicsr, +zifencei, +zkne, +zmmul
	.globl	write_v_to_address              # -- Begin function write_v_to_address
	.p2align	1
	.type	write_v_to_address,@function
write_v_to_address:                     # @write_v_to_address
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	sw	s1, 4(sp)                       # 4-byte Folded Spill
	mv	s0, a1
	lw	a1, 0(a1)
	mv	s1, a0
	call	write_to_address
	lw	a1, 4(s0)
	addi	a0, s1, 4
	call	write_to_address
	lw	a1, 8(s0)
	addi	a0, s1, 8
	call	write_to_address
	lw	a1, 12(s0)
	addi	a0, s1, 12
	call	write_to_address
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	lw	s1, 4(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end5:
	.size	write_v_to_address, .Lfunc_end5-write_v_to_address
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +a, +c, +d, +f, +m, +zaamo, +zalrsc, +zca, +zcd, +zcf, +zicsr, +zifencei, +zkne, +zmmul
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -96
	sw	ra, 92(sp)                      # 4-byte Folded Spill
	sw	s0, 88(sp)                      # 4-byte Folded Spill
	sw	s1, 84(sp)                      # 4-byte Folded Spill
	sw	s2, 80(sp)                      # 4-byte Folded Spill
	sw	s3, 76(sp)                      # 4-byte Folded Spill
	lui	a0, 197379
	lui	a1, 411335
	lui	a2, 356867
	lui	a3, 444102
	addi	a0, a0, 33
	addi	a1, a1, 623
	addi	a2, a2, -913
	addi	a3, a3, 1352
	sw	a3, 60(sp)
	sw	a2, 64(sp)
	sw	a1, 68(sp)
	sw	a0, 72(sp)
	addi	a0, sp, 60
	addi	a1, sp, 44
	call	merge_plaintext_into_state
	lui	a0, 411431
	lui	a1, 472886
	lui	a2, 197443
	lui	a3, 415542
	lui	a4, 700305
	lui	a5, 189019
	lui	s1, 464063
	addi	a0, a0, -137
	addi	a1, a1, 368
	addi	a2, a2, 52
	addi	a3, a3, 1379
	sw	a3, 28(sp)
	sw	a2, 32(sp)
	sw	a1, 36(sp)
	sw	a0, 40(sp)
	lui	a0, 1030737
	addi	a1, a4, -2033
	addi	a2, a5, -1346
	addi	a3, s1, 1055
	addi	a0, a0, -1772
	sw	a0, 12(sp)
	sw	a3, 16(sp)
	sw	a2, 20(sp)
	sw	a1, 24(sp)
	addi	a0, sp, 44
	li	a1, 16
	addi	a2, sp, 28
	call	aes128_ecb_encrypt
	lui	s0, 258
	addi	a0, s0, 48
	addi	a1, sp, 12
	call	write_v_to_address
	addi	a0, s0, 64
	addi	a1, sp, 44
	call	write_v_to_address
	lw	a1, 44(sp)
	addi	s0, s0, 4
	mv	a0, s0
	call	write_to_address
	lw	a0, 44(sp)
	lw	a1, 12(sp)
	lui	a2, 764587
	addi	s3, a2, -1365
	bne	a0, a1, .LBB6_5
# %bb.1:
	lw	a1, 48(sp)
	mv	a0, s0
	call	write_to_address
	lw	a0, 48(sp)
	lw	a1, 16(sp)
	bne	a0, a1, .LBB6_5
# %bb.2:
	lw	a1, 52(sp)
	lui	s2, 258
	addi	s2, s2, 4
	mv	a0, s2
	call	write_to_address
	lw	a0, 52(sp)
	lw	a1, 20(sp)
	lui	a2, 764587
	addi	s3, a2, -1365
	bne	a0, a1, .LBB6_5
# %bb.3:
	lw	a1, 56(sp)
	mv	a0, s2
	call	write_to_address
	lw	a0, 56(sp)
	lw	a1, 24(sp)
	bne	a0, a1, .LBB6_5
# %bb.4:
	lui	a0, 831468
	addi	s3, a0, -1346
.LBB6_5:
	lw	a1, 44(sp)
	lui	s1, 270338
	addi	a0, s1, 64
	call	write_to_address
	lw	a1, 48(sp)
	addi	a0, s1, 68
	call	write_to_address
	lw	a1, 52(sp)
	addi	a0, s1, 72
	call	write_to_address
	lw	a1, 56(sp)
	addi	a0, s1, 76
	call	write_to_address
	mv	a0, s0
	mv	a1, s3
	call	write_to_address
	lui	a0, 912092
	addi	a1, a0, -273
	lui	a0, 258
	call	write_to_address
	li	a0, 0
	lw	ra, 92(sp)                      # 4-byte Folded Reload
	lw	s0, 88(sp)                      # 4-byte Folded Reload
	lw	s1, 84(sp)                      # 4-byte Folded Reload
	lw	s2, 80(sp)                      # 4-byte Folded Reload
	lw	s3, 76(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 96
	ret
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
                                        # -- End function
	.option	pop
	.type	rcon,@object                    # @rcon
	.section	.rodata,"a",@progbits
rcon:
	.ascii	"\001\002\004\b\020 @\200\0336"
	.size	rcon, 10

	.type	.L__const.main.plaintext,@object # @__const.main.plaintext
	.section	.rodata.cst16,"aM",@progbits,16
.L__const.main.plaintext:
	.ascii	"Hello, World!000"
	.size	.L__const.main.plaintext, 16

	.type	.L__const.main.key,@object      # @__const.main.key
.L__const.main.key:
	.ascii	"cese4040password"
	.size	.L__const.main.key, 16

	.type	.L__const.main.expected_output,@object # @__const.main.expected_output
	.p2align	2, 0x0
.L__const.main.expected_output:
	.word	4221896980                      # 0xfba50914
	.word	1900803103                      # 0x714bf41f
	.word	774220478                       # 0x2e25aabe
	.word	2868447247                      # 0xaaf9080f
	.size	.L__const.main.expected_output, 16

	.ident	"clang version 21.0.0git (https://github.com/llvm/llvm-project.git f351172d4a840dfbf533319b62925747a10b762f)"
	.section	".note.GNU-stack","",@progbits
