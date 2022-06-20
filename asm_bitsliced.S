.syntax unified

.arch armv6t2

.text /* Start of the program code section */

.globl   encryption

.p2align 2
.type   encryption ,%function

bitslicing:
/* input: r1-r4 128 bit
** r12: 0x80808080 at the beginning for x0 and shifting right every iteration
** r0: #0 at the beginning. used to iterate over how many bits to shift left #0-#7
*/
	and r7, r1, r12
	lsl r7, r7, r0	// now r7 has 0s between every 8th bit in bits 0-31
	mov r5, r7		// the output is accumulated in r5
	lsl r6, r7, #7
	add r5, r5, r6
	lsl r6, r7, #14
	add r5, r5, r6
	lsl r6, r7, #21
	add r5, r5, r6

	and r7, r2, r12
	lsl r7, r7, r0	// now r7 has every 8'th bit of bits 32-63
	lsr r6, r7, #4
	add r5, r5, r6
	lsl r6, r7, #3
	add r5, r5, r6
	lsl r6, r7, #10
	add r5, r5, r6
	lsl r6, r7, #17
	add r5, r5, r6

	and r5, r5, #0xff000000	// cleaning the misplaced bits
	and r7, r3, r12
	lsl r7, r7, r0	// now r7 has every 8'th bit of bits 64-95
	lsr r6, r7, #8
	add r5, r5, r6
	lsl r7, r7, #8
	lsr r7, r7, #8	// cleaning the bits we already moved to avoide overrun
	lsr r6, r7, #1
	add r5, r5, r6
	lsl r7, r7, #16
	lsr r7, r7, #16	// cleaning the bits we already moved to avoide overrun
	lsl r6, r7, #6
	add r5, r5, r6
	and r7, r7, #0x00000080	// cleaning the bits we already moved to avoide overrun
	lsl r6, r7, #13
	add r5, r5, r6

	and r7, r4, r12
	lsl r7, r7, r0
	lsr r6, r7, #12	// assuming r7 has every 8'th bit of bits 96-127
	add r5, r5, r6
	lsl r7, r7, #8
	lsr r7, r7, #8	// cleaning the bits we already moved to avoide overrun
	lsr r6, r7, #5
	add r5, r5, r6
	lsl r7, r7, #16
	lsr r7, r7, #16	// cleaning the bits we already moved to avoide overrun
	lsl r6, r7, #2
	add r5, r5, r6
	and r7, r7, #0x00000080	// cleaning the bits we already moved to avoide overrun
	lsl r6, r7, #9
	add r5, r5, r6
	lsr r5, r5, #16
	lsl r5, r5, #16	// cleaning the misplaced bits
	lsr r12, r12, 1	// for next iteration
	bx lr	// return to the caller

reversed_bitslice:
/* input in: r1:(s0|t60) r11: (s3|t67) r3:(s1|s2) r9:(s5|s4) r2: (s7|s6)
** R4-R7: 0x0 for accumulating 128 bits of output state
** R10: for gaping each of the 4 bits without overlapping the previous bits
*/ // s0:
	mov r4, #0
	mov r5, #0
	mov r6, #0
	mov r7, #0
	and r4, r1, #0xf0000000	// leaving only the 4 bits to go in one register
	lsr r8, r4, #7
	add r4, r4, r8			// r4 will hold bits 0-31
	lsr r8, r8, #7
	add r4, r4, r8
	lsr r8, r8, #7
	add r4, r4, r8
	and r4, r4, #0x80808080			// cleaning up unwanted bits
	and r5, r1, #0x0f000000	// r5 will hold bits 32-63
	lsl r5, r5, #4
	lsr r8, r5, #7
	add r5, r5, r8
	lsr r8, r8, #7
	add r5, r5, r8
	lsr r8, r8, #7
	add r5, r5, r8
	and r5, r5, #0x80808080
	and r6, r1, #0x00f00000	// r6 will hold bits 64-93
	lsl r6, r6, #8
	lsr r8, r6, #7
	add r6, r6, r8
	lsr r8, r8, #7
	add r6, r6, r8
	lsr r8, r8, #7
	add r6, r6, r8
	and r6, r6, #0x80808080
	and r7, r1, #0x000f0000	// r7 will hold bits 94-127
	lsl r7, r7, #12
	lsr r8, r7, #7
	add r7, r7, r8
	lsr r8, r8, #7
	add r7, r7, r8
	lsr r8, r8, #7
	add r7, r7, r8
	and r7, r7, #0x80808080
// s1:
	and r8, r3, #0xf0000000	// leaving only the 4 bits to go in one register
	lsr r10, r8, #1
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x40404040		// cleaning up unwanted bits
	add r4, r4, r10
	and r8, r3, #0x0f000000
	lsl r10, r8, #3
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x40404040
	add r5, r5, r10
	and r8, r3, #0x00f00000
	lsl r10, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x40404040
	add r6, r6, r10
	and r8, r3, #0x000f0000
	lsl r10, r8, #11
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x40404040
	add r7, r7, r10
//s2:
	and r8, r3, #0x0000f000
	lsl r10, r8, #14
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x20202020
	add r4, r4, r10
	and r8, r3, #0x00000f00
	lsl r10, r8, #18
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x20202020
	add r5, r5, r10
	and r8, r3, #0x000000f0
	lsl r10, r8, #22
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x20202020
	add r6, r6, r10
	and r8, r3, #0x0000000f
	lsl r10, r8, #26
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x20202020
	add r7, r7, r10
//s3:
	and r8, r11, #0xf0000000
	lsr r10, r8, #3
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x10101010
	add r4, r4, r10
	and r8, r11, #0x0f000000
	lsl r10, r8, #1
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x10101010
	add r5, r5, r10
	and r8, r11, #0x00f00000
	lsl r10, r8, #5
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x10101010
	add r6, r6, r10
	and r8, r11, #0x000f0000
	lsl r10, r8, #9
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x10101010
	add r7, r7, r10
// s4:
	and r8, r9, #0x0000f000
	lsl r10, r8, #12
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x08080808
	add r4, r4, r10
	and r8, r9, #0x00000f00
	lsl r10, r8, #16
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x08080808
	add r5, r5, r10
	and r8, r9, #0x000000f0
	lsl r10, r8, #20
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x08080808
	add r6, r6, r10
	and r8, r9, #0x0000000f
	lsl r10, r8, #24
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x08080808
	add r7, r7, r10
// s5:
	and r8, r9, #0xf0000000
	lsr r10, r8, #5
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x04040404
	add r4, r4, r10
	and r8, r9, #0x0f000000
	lsr r10, r8, #1
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x04040404
	add r5, r5, r10
	and r8, r9, #0x00f00000
	lsl r10, r8, #3
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x04040404
	add r6, r6, r10
	and r8, r9, #0x000f0000
	lsl r10, r8, #7
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x04040404
	add r7, r7, r10
// s6:
	and r8, r2, #0x0000f000
	lsl r10, r8, #10
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x02020202
	add r4, r4, r10
	and r8, r2, #0x00000f00
	lsl r10, r8, #14
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x02020202
	add r5, r5, r10
	and r8, r2, #0x000000f0
	lsl r10, r8, #18
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x02020202
	add r6, r6, r10
	and r8, r2, #0x0000000f
	lsl r10, r8, #22
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x02020202
	add r7, r7, r10
// s7:
	and r8, r2, #0xf0000000
	lsr r10, r8, #7
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x01010101
	add r4, r4, r10
	and r8, r2, #0x0f000000
	lsr r10, r8, #3
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x01010101
	add r5, r5, r10
	and r8, r2, #0x00f00000
	lsl r10, r8, #1
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x01010101
	add r6, r6, r10
	and r8, r2, #0x000f0000
	lsl r10, r8, #5
	lsr r8, r10, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	lsr r8, r8, #7
	add r10, r10, r8
	and r10, r10, #0x01010101
	add r7, r7, r10

	bx lr				// return to caller

bitsliced_sbox:
/* input: r8-r11 bitsliced 128 bit
** r8: (x0|x1) r9: (x2|x7) r10: (x3|x5) r11: (x4|x6)
** output: r1, r2, r3, r9, r11 bitsliced 128 bit
** r1:(s0|t60) r3:(s1|s2) r11:(s3|t67) r9:(s5|s4) r2: (s7|s6)
*/
//-------------------------------- s-box --------------------------------------

	// first layer:
	mov r12, 0x0000ffff	// r12: (0|1)
	and r6, r9, r12		// r6: (0|x7)
	and r5, r8, r12		// r5: (0|x1)
	lsl r12, r12, #16	// r12: (1|0)
	lsl r0, r11, #16	// r0: (x6|0)
	lsr r1, r9, #16		// r1: (0|x2)
	add r0, r0, r1		// r0: (x6|x2)
	eor r0, r0, r8		// r0: x0^x6|x1^x2 = (y13|t0)
	and r1, r8, r12		// r1: (x0|0)
	lsr r2, r10, #16	// r2: (0|x3)
	add r1, r1, r2		// r1: (x0|x3)
	eor r1, r1, r10		// r1: x0^x3|x3^x5 = (y9|y14)
	lsl r2, r1, #16		// r2: (y14|0)
	add r2, r2, r6		// r2: (y14|x7)
	eor r2, r2, r0		// r2: y13^y14|t0^x7 = (y12|y1) last use of y14
	eor r11, r11, r2	// r11: x4^y12|x6^y1 = (t1|y5) last use of y12, x4, x6
	lsr r3, r11, #16	// r3: (0|t1)
	lsl r4, r10, #16	// r4: (x5|0)
	add r3, r3, r4		// r3: (x5|t1)
	lsl r4, r3, #16		// r4: (t1|0)
	add r4, r4, r5		// r4: (t1|x1)
	eor r3, r3, r4		// r3: x5^t1|t1^x1 = (y15|y20) last use of x1, t1
	lsl r4, r0, #16		// r4: (t0|0)
	lsr r5, r1, #16		// r5: (0|y9)
	add r4, r4, r5		// r4: (t0|y9)
	eor r4, r4, r3		// r4: t0^y15|y9^y20 = (y10|y11) last use of y20
	lsr r8, r8, #16		// r8: (0|x0)
	lsl r5, r2, #16		// r5: (y1|0)
	add r5, r5, r8		// r5: (y1|x0)
	eor r10, r10, r5	// r10: x3^y1|x5^x0 = (y4|y8) last use of x3|x5
	lsl r7, r10, #16	// r7: (y8|0)
	add r7, r7, r6		// r7: (y8|x7)
	eor r7, r7, r4		// r7: y8^y10|x7^y11 = (y19|y7) last use of y8
	lsl r9, r0, #16		// r9: (t0|0)
	lsr r9, r9, #16		// r9: (0|t0)
	lsl r5, r4, #16		// r5: (y11|0)
	add r5, r5, r9		// r5: (y11|t0)
	eor r5, r4, r5		// r5: y11^y10|t0^y11 = (y17|y16) last use of y10, y11, t0
	lsl r9, r8, #16		// r9: (x0|0)
	add r9, r9, r6		// r9: (x0|x7)
	lsl r6, r5, #16		// r6: (y16|0)
	add r8, r6, r8		// r8: (y16|x0)
	and r6, r0, r12		// r6: (y13|0)
	lsr r12, r8, #16	// r12: (0|y16)
	add r6, r6, r12		// r6: (y13|y16)
	eor r8, r8, r6		// r8: y16^y13|x0^y16 = (y21|y18)
	lsl r6, r2, #16		// r6: (y1|0)
	lsr r12, r3, #16	// r12: (0|y15)
	add r6, r6, r12		// r6: (y1|y15)
	eor r6, r9, r6		// r6: y1^x0|y15^x7 = (y2|y6)
	lsl r9, r9, #16		// r9: (x7|0)
	eor r12, r10, r11	// r12: t1^y4|y5^y8 = (??|y3)
	/*
	 second layer- current status:
	 r0: (y13|t0) r1: (y9|y14) r2: (y12|y1) r3: (y15|y20)
	 r4: (y10|y11) r5: (y17|y16) r6: (y2|y6) r7: (y19|y7)
	 r8: (y21|y18) r9: (x7|0) r10: (y4|y8) r11: (t1|y5) r12 :(??|y3)
	 useless in next layer: x0,x1,...,x6,t0,t1
	*/
	push {r7}
		lsr r0, r0, #16		// r0: (0|y13)
		lsl r7, r1, #16		// r7: (y14|0)
		add r0, r0, r7		// r0: (y14|y13)
		lsl r11, r11, #16	// r11: (y5|0)
		lsr r7, r3, #16		// r7: (0|y15)
		add r11, r11, r7	// r11: (y5|y15)
	pop {r7}
	ror r2, r2, #16		// r2: (y1|y12)
	push {r0, r2, r5, r11}	// storing (y5|y15)(y17|y16)(y1|y12)(y14|y13)
	and r0, r0, r5		// r0: y17&y14|y16&y13 = (t13|t7)
	and r2, r2, r11		// r2: y5&y1|y15&y12 = (t8|t2)
	lsr r5, r1, #16		// r5: (0|y9)
	lsl r11, r6, #16	// r11: (y6|0)
	add r5, r5, r11		// r5: (y6|y9)
	ror r5, r5, #16		// r5: (y9|y6)
	lsl r12, r12, #16	// r12: (y3|0)
	lsr r12, r12, #16	// r12: (0|y3)
	lsl r11, r4, #16	// r11: (y11|0)
	add r12, r12, r11	// r12: (y11|y3)
	push {r5, r12}		// storing (y11|y3)(y9|y6)
	and r5, r5, r12		// r5: y11&y9|y3&y6 = (t12|t3)
	mov r1, #0x0000ffff	// r1: (0|1)
	lsl r12, r2, #16	// r12: (t2|0)
	and r11, r0, r1		// r11: (0|t7)
	add r12, r12, r11	// r12: (t2|t7)
	lsr r2, r2, #16		// r2: (0|t8)
	lsl r11, r5, #16	// r11: (t3|0)
	add r2, r2, r11		// r2: (t3|t8)
	eor r2, r2, r12		// r2: t2^t3|t7^t8 = (t4|t9)
	eor r0, r0, r5		// r0: t12^t13|t3^t7 = (t14|??)
	lsr r11, r0, #16	// r11: (0|t14)
	lsl r0, r11, #16	// r0: (t14|0)
	add r0, r0, r11		// r0: (t14|t14)
	eor r0, r0, r2		// r0: t14^t4|t14^t9 = (t17|t19)
	lsl r3, r3, #16		// r3: (y20|0)
	lsr r2, r8, #16		// r2: (0|y21)
	add r3, r3, r2		// r3: (y20|y21)
	eor r0, r0, r3		// r0: y20^t17|y21^t19 = (t21|t23)
	// registers free so far: r1, r2, r3, r11
	lsr r4, r4, #16		// r4: (0|y10)
	lsl r3, r0, #16		// r3: (t23|0)
	add r4, r4, r3		// r4: (t23|y10)
	lsr r3, r0, #16		// r3: (0|t21)
	lsl r3, r3, #16		// r3: (t21|0)
	and r2, r10, r1		// r2: (0|y8)
	add r3, r3, r2		// r3: (t21|y8)
	and r11, r4, r3		// r11: t21&t23|y8&y10 = (t26|t15)
	lsr r5, r5, #16		// r5: (0|t12)
	eor r5, r5, r11		// r5: 0^t26|t12^t15 = (t26|t16)
	and r2, r7, r1		// r2: (0|y7)
	add r9, r9, r2		// r9: (x7|y7)
	lsr r10, r10, #16	// r10: (0|y4)
	lsl r10, r10, #16	// r10: (y4|0)
	lsr r6, r6, #16		// r6: (0|y2)
	add r6, r6, r10		// r6: (y4|y2)
	and r2, r6, r9		// r2: y4&x7|y2&y7 = (t5|t10)
	eor r2, r2, r12		// r2: t2^t5|t7^t10 = (t6|t11)
	lsl r12, r1, #16	// r12: (1|0)
	lsl r10, r5, #16	// r10: (t16|0)
	lsr r5, r10, #16 	// r5: (0|t16)
	add r5, r5, r10		// r5: (t16|t16)
	eor r5, r5, r2		// r5: t16^t6|t16^t11 = (t18|t20)
	and r7, r7, r12		// r7: (y19|0)
	and r8, r8, r1		// r8: (0|y18)
	add r7, r7, r8		// r7: (y19|y18)
	eor r7, r7, r5		// r7: y19^t18|y18^t20 = (t22|t24)
	eor r8, r7, r0		// r8: t21^t22|t23^t24 = (t25|t30)
	lsr r11, r11, #16	// r11: (0|t26)
	lsl r5, r11, #16	// r5: (t26|0)
	add r5, r5, r11		// r5: (t26|t26)
	eor r5, r5, r7		// r5: t22^t26|t24^t26 = (t31|t27)
	ror r5, r5, #16		// r5: (t27|t31)
	and r2, r5, r8		// r2: t27&t25|t31&t30 = (t28|t32)
	eor r2, r2, r7		// r2: t22^t28|t24^t32 = (t29|t33)
	ror r2, r2, #16		// r2: (t33|t29)
	and r6, r6, r2		// r6: t33&y4|t29&y2 = (z11|z14)
	and r9, r9, r2		// r9: t33&x7|t29&y7 = (z2|z5)
	lsr r5, r5, #16		// r5: (0|t27)
	lsl r0, r0, #16		// r0: (t23|0)
	lsr r11, r2, #16	// r11: (0|t33)
	add r0, r0, r11		// r0: (t23|t33)
	lsl r11, r11, #16	// r11: (t33|0)
	add r5, r5, r11		// r5: (t33|t27)
	eor r0, r0, r5		// r0: t23^t33|t33^t27 = (t34|t35)
	and r7, r7, r0		// r7: t22&t34|t24&t35 = (??|t36)
	lsl r7, r7, #16		// r7: (t36|0)
	lsr r10, r7, #16	// r10: (0|t36)
	add r7, r7, r10		// r7: (t36|t36)
	lsr r0, r0, #16		// r0: (0|t34)
	lsl r5, r5, #16		// r5: (t27|0)
	add r0, r0, r5		// r0: (t27|t34)
	eor r0, r0, r7		// r0: t27^t36|t34^t36 = (t38|t37)
	lsl r2, r2, #16		// r2: (t29|0)
	and r7, r2, r0		// r7: t29&t38|0&t37 = (t39|0)
	and r0, r0, r1		// r0: (0|t37)
	add r7, r0, r7		// r7: (t39|t37)
	ror r7, r7, #16		// r7: (t37|t39)
	lsr r8, r8, #16		// r8: (0|t25)
	add r8, r8, r11		// r8: (t33|t25)
	eor r7, r7, r8		// r7: t37^t33|t39^t25 = (t44|t40)
	add r5, r2, r0		// r5: (t29|t37)
	and r2, r7, r1		// r2: (0|t40)
	add r11, r11, r2	// r11: (t33|t40)
	eor r11, r11, r5	// r11: t29^t33|t37^t40 = (t42|t41)
	lsl r8, r11, #16	// r8: (t41|0)
	and r11, r11, r12	// r11: (t42|0)
	add r0, r0, r11		// r0: (t42|t37)
	lsr r5, r5, #16		// r5: (0|t29)
	add r5, r5, r11		// r5: (t42|t29)
	add r2, r2, r8		// r2: (t41|t40)
	eor r2, r2, r5		// r2: t41^t42|t40^t29 = (t45|t43)
	lsr r11, r8, #16	// r11: (0|t41)
	add r8, r8, r11		// r8: (t41|t41)
	lsl r4, r4, #16		// r4: (y10|0)
	and r3, r3, r1		// r3: (0|y8)
	add r3, r3, r4		// r3: (y10|y8)
	and r3, r3, r8		// r3: y10&t41|y8&t41 = (z8|z17)
	pop {r1, r4, r5, r8, r10, r11}
	// r1: (y9|y6) r4: (y11|y3) r5: (y14|y13) r8: (y1|y12) r10: (y17|y16) r11: (y5|y15)
	and r1, r1, r0		// r1: y9&t42|y6&t37 = (z15|z1)
	and r4, r4, r0		// r4: y11&t42|y3&t37 = (z6|z10)
	ror r7, r7, #16		// r7: (t40|t44)
	and r8, r8, r7		// r8: y1&t40|y12&t44 = (z4|z9)
	and r11, r11, r7	// r11: y5&t40|y15&t44 = (z13|z0)
	and r5, r5, r2		// r5: y14&t45|y13&t43 = (z16|z12)
	and r10, r10, r2	// r10: y17&t45|y16&t43 = (z7|z3)
	/*
	third and final layer! current status:
	r0: available r1: (z15|z1) r2: available r3: (z8|z17) r4: (z6|z10)
	r5: (z16|z12) r6: (z11|z14) r7: available r8: (z4|z9) r9: (z2|z5)
	r10: (z7|z3) r11: (z13|z0) r12: (1|0) and stack empty
	*/
//bottom layer:
	lsr r0, r1, #16		// r0: (0|z15)
	and r2, r4, r12		// r2: (z6|0)
	add r0, r0, r2		// r0: (z6|z15)
	lsr r2, r5, #16		// r2: (0|z16)
	and r7, r10, r12	// r7: (z7|0)
	add r2, r2, r7		// r2: (z7|z16)
	eor r0, r0, r2		// r0: z6^z7|z15^z16 = (t54|t46) last use in z6 & z15
	lsl r10, r10, #16	// r10: (z3|0)
	lsr r7, r8, #16		// r7: (0|z4)
	add r7, r7, r10		// r7: (z3|z4)
	eor r10, r7, r0		// r10: t54^z3|t46^z4 = (t59|t58) last use in t54
	eor r3, r3, r2		// r3: z7^z8|z16^z17 = (t52|t55) last use in z7, z8, z16, z17
	lsl r8, r8, #16		// r8: (z9|0)
	lsl r5, r5, #16
	lsr r5, r5, #16		// r5: (0|z12)
	add r8, r8, r5		// r8: (z9|z12) now r5 is free
	lsl r5, r11, #16	// r5: (z0|0)
	lsr r2, r10, #16	// r2: (0|t59)
	add r2, r2, r5		// r2: (z0|t59)
	eor r7, r7, r2		// r7: z3^z0|z4^t59 = (t53|t64) last use in z0, z3, z4
	lsl r4, r4, #16		// r4: (z10|0)
	lsr r5, r9, #16		// r5: (0|z2)
	add r4, r4, r5		// r4: (z10|z2)
	mov r2, #0x0000ffff	// r2: (0|1)
	and r9, r9, r2		// r9: (0|z5)
	and r5, r6, r12		// r5: (z11|0)
	add r9, r9, r5		// r9: (z11|z5)
	eor r5, r8, r4		// r5: z9^z10|z12^z2 = (t49|t50) last use in z9
	eor r4, r4, r9		// r4: z10^z11|z2^z5 = (t47|t51) last use in z11
	lsl r1, r1, #16		// r1: (z1|0)
	and r6, r6, r2		// r6: (0|z14)
	add r6, r6, r1		// r6: (z1|z14) freeing r1
	and r1, r10, r12	// r1: (t59|0)
	and r0, r0, r2		// r0: (0|t46)
	add r1, r1, r0		// r1: (t59|t46) freeing r0
	lsl r10, r10, #16	// r10: (t58|0)
	lsr r0, r7, #16		// r0: (0|t53)
	add r0, r0, r10		// r0: (t58|t53)
	eor r5, r5, r0		// r5: t49^t58|t50^t53 = (t63|t57)
	eor r1, r1, r5		// r1: t59^t63|t46^t57 = (s0|t60)
	eor r5, r5, r6		// r5: z1^t63|z14^t57 = (t66|t61)
	and r11, r11, r12	// r11: (z13|0)
	lsr r0, r0, #16		// r0: (0|t58)
	add r0, r0, r11		// r0: (z13|t58) freeing r11
	lsr r11, r3, #16	// r11: (0|t52)
	lsl r9, r9, #16		// r9: (z5|0)
	add r9, r9, r11		// r9: (z5|t52)
	eor r0, r0, r9		// r0: z13^z5|t58^t52 = (t48|t62) last use in t52, z13, t58
	and r9, r5, r2		// r9: (0|t61)
	lsl r8, r8, #16		// r8: (z12|0)
	add r8, r8, r9		// r8: (z12|t61)
	eor r8, r8, r0		// r8: z12^t48|t61^t62 = (t56|t65) last use in t61
	lsl r9, r8, #16		// r9: (t65|0)
	lsr r5, r5, #16		// r5: (0|t66)
	add r5, r5, r9		// r5: (t65|t66)
	eor r9, r4, r5		// r9: t47^t65|t51^t66 = (s5|s4)
	ror r5, r5, #16		// r5: (t66|t65)
	eor r11, r5, r7		// r11: t53^t66|t64^t65 = (s3|t67) last use in t53, t65, t66
	and r3, r3, r2		// r3: (0|t55)
	lsl r7, r7, #16		// r7: (t64|0)
	add r3, r3, r7		// r3: (t64|t55)
	eor r3, r3, r11		// r3: t64^s3|t55^t67 = (s1!|s2!)
	lsr r8, r8, #16		// r8: (0|t56)
	lsl r5, r1, #16		// r5: (t60|0)
	add r8, r8, r5		// r8: (t60|t56)
	eor r2, r0, r8		// r2: t48^t60|t62^t56 = (s7!|s6!)
	mvn r3, r3			// r3: (s1|s2)
	mvn r2, r2			// r2: (s7|s6)
/*
 result is in: r1:(s0|t60) r3:(s1|s2) r11:(s3|t67) r9:(s5|s4) r2: (s7|s6)
*/
	bx lr

mix_col:
/*
* intput: r11, output: r4
* state[0] = 2 * state[0] + state[3] + state[2] + 3 * state[1]
* state[1] = 2 * state[1] + state[0] + state[3] + 3 * state[2]
* state[2] = 2 * state[2] + state[1] + state[0] + 3 * state[3]
* state[3] = 2 * state[3] + state[2] + state[1] + 3 * state[0]
* multiplication by 3 is done by multiplication by 2 then xor
*/
	ror r3, r11, #24		// r3: state[i+1]|state[i+2]|state[i+3]|state[i]
	eor r3, r3, r11			// r3: state[i]^state[i+1]|state[i+1]^state[i+2]|state[i+2]^state[i+3]|state[i+3]^state[i]
	and r2, r3, #0xff000000	// r2: state[i]^state[i+1]
	and r1, r3, #0x0000ff00	// r1: state[i+2]^state[i+3]
	lsl r1, r1, #16
	eor r0, r2, r1			// r0: state[i]^state[i+1]^state[i+2]^state[i+3]
	lsr r1, r0, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1			// r0: state[i]^state[i+1]^state[i+2]^state[i+3]|...|state[i]^state[i+1]^state[i+2]^state[i+3]
	push {lr}
	bl galois_mul2_mix_col	// r2: 2*(state[i]^state[i+1])|2*(state[i+1]^state[i+2])|2*(state[i+2]^state[i+3])|2*(state[i]^state[i+3])
	eor r4, r11, r2
	eor r4, r4, r0

	pop {lr}
	bx lr

mix_columns:
/* intput: r8-r11, output: r4-r7
** multiplication by 3 is done by multiplication by 2 then xor
*/	// mix first column:
	ror r3, r8, #24			// r3: state[1]|state[2]|state[3]|state[0]
	eor r3, r3, r8			// r3: state[0]^state[1]|state[1]^state[2]|state[2]^state[3]|state[3]^state[0]
	and r2, r3, #0xff000000	// r2: state[0]^state[1]
	and r1, r3, #0x0000ff00	// r1: state[2]^state[3]
	lsl r1, r1, #16
	eor r0, r2, r1			// r0: state[0]^state[1]^state[2]^state[3]
	lsr r1, r0, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1			// r0: state[0]^state[1]^state[2]^state[3]|...|state[0]^state[1]^state[2]^state[3]
	push {lr}
	bl galois_mul2_mix_col	// r2: 2*(state[0]^state[1])|2*(state[1]^state[2])|2*(state[2]^state[3])|2*(state[0]^state[3])
	eor r4, r8, r2
	eor r4, r4, r0
	//mix second column:
	ror r3, r9, #24			// r3: state[5]|state[6]|state[7]|state[4]
	eor r3, r3, r9			// r3: state[4]^state[5]|state[5]^state[6]|state[6]^state[7]|state[7]^state[4]
	and r2, r3, #0xff000000	// r2: state[4]^state[5]
	and r1, r3, #0x0000ff00	// r1: state[6]^state[7]
	lsl r1, r1, #16
	eor r0, r2, r1			// r0: state[4]^state[5]^state[6]^state[7]
	lsr r1, r0, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1			// r0: state[4]^state[5]^state[6]^state[7]|...|state[4]^state[5]^state[6]^state[7]]
	bl galois_mul2_mix_col	// r2: 2*(state[4]^state[5])|2*(state[5]^state[6])|2*(state[6]^state[7])|2*(state[4]^state[7])
	eor r5, r9, r2
	eor r5, r5, r0
	// mix third column:
	ror r3, r10, #24		// r3: state[9]|state[10]|state[11]|state[8]
	eor r3, r3, r10			// r3: state[8]^state[9]|state[9]^state[10]|state[10]^state[11]|state[11]^state[8]
	and r2, r3, #0xff000000	// r2: state[8]^state[9]
	and r1, r3, #0x0000ff00	// r1: state[10]^state[11]
	lsl r1, r1, #16
	eor r0, r2, r1			// r0: state[8]^state[9]^state[10]^state[11]
	lsr r1, r0, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1			// r0: state[8]^state[9]^state[10]^state[11]|...|state[8]^state[9]^state[10]^state[11]
	bl galois_mul2_mix_col	// r2: 2*(state[8]^state[9])|2*(state[9]^state[10])|2*(state[10]^state[11])|2*(state[11]^state[8])
	eor r6, r10, r2
	eor r6, r6, r0
	// mix fourth column:
	ror r3, r11, #24		// r3: state[13]|state[14]|state[15]|state[12]
	eor r3, r3, r11			// r3: state[12]^state[13]|state[13]^state[14]|state[14]^state[15]|state[15]^state[12]
	and r2, r3, #0xff000000	// r2: state[12]^state[13]
	and r1, r3, #0x0000ff00	// r1: state[14]^state[15]
	lsl r1, r1, #16
	eor r0, r2, r1			// r0: state[12]^state[13]^state[14]^state[15]
	lsr r1, r0, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1
	lsr r1, r1, #8
	add r0, r0, r1			// r0: state[12]^state[13]^state[14]^state[15]|...|state[12]^state[13]^state[14]^state[15]
	bl galois_mul2_mix_col	// r2: 2*(state[12]^state[13])|2*(state[13]^state[14])|2*(state[14]^state[15])|2*(state[15]^state[12])
	eor r7, r11, r2
	eor r7, r7, r0

	pop {lr}
	bx lr

galois_mul2_mix_col:
/*
* input: r3, output: r2 which is r3 multiplied by 2 in the galois field 2^8 (each byte)
*/
	and r2, r3, #0xff000000
	asr r12, r2, #7	// if the msb is 1 then 8 leftmost bits will be 1's
	// if the msb was 1 we need to reduce the product with the irreducible polynomial:
	// x^8 + x^4 + x^3 + x + 1 by replacing x^8 with x^4 + x^3 + x + 1 = 0x1b
	and r12, r12, #0x1b000000
	lsl r2, r2, #1	// multiply by 2 (losing the msb)
	eor r2, r2, r12	// product will be at the leftmost bits

	and r1, r3, #0x00ff0000
	lsl r1, r1, #8
	asr r12, r1, #7
	and r12, r12, #0x1b000000
	lsl r1, r1, #1
	eor r1, r1, r12
	lsr r1, r1, #8
	add r2, r2, r1

	and r1, r3, #0x0000ff00
	lsl r1, r1, #16
	asr r12, r1, #7
	and r12, r12, #0x1b000000
	lsl r1, r1, #1
	eor r1, r1, r12
	lsr r1, r1, #16
	add r2, r2, r1

	and r1, r3, #0x000000ff
	lsl r1, r1, #24
	asr r12, r1, #7
	and r12, r12, #0x1b000000
	lsl r1, r1, #1
	eor r1, r1, r12
	lsr r1, r1, #24
	add r2, r2, r1

	bx lr

galois_mul2:
/*
* input: r2 (leftmost), output: r2 multiplied by 2 in the galois field 2^8 (leftmost)
*/
	asr r12, r2, #7	// if the msb is 1 then 8 leftmost bits will be 1's
	// if the msb was 1 we need to reduce the product with the irreducible polynomial:
	// x^8 + x^4 + x^3 + x + 1 by replacing x^8 with x^4 + x^3 + x + 1 = 0x1b
	and r12, r12, #0x1b000000
	lsl r2, r2, #1	// multiply by 2 (losing the msb)
	eor r2, r2, r12	// product will be at the leftmost bits

	bx lr

encryption: /* address of the function */
	.fnstart
/* state:
   ** 77da 06d7 0a2d dc66 3d13 9c07 bf21 82c1
   ** 9689 8260 e02c a561 d19c 91e2 5eff 2327
   ** 46fb 4e78 a583 e1aa c1a0 1713 a64d a99f
   ** 5e2e fd05 ca57 59b5 1387 a779 8621 5c69
   ** f8ca 3263 73d6 6746 2629 63e3 da02 c0ad
   ** 92df 0798 bad4 12ec d202 eac3 1043 84d5
   ** c94e 6ef9 fd03 4602 9427 ed69 01fd 74d0
   ** b241 d4f9 c519 4d3a 5f76 2cc7 7225 f3f3
   ** 1605 2e3d b02f 0a76 c721 eedd e34f b39b
   ** 6614 5b60 3bb1 9de0 af23 ee56 f04a 3e72
   */

 /* key:
 ** b1f0 1aa3 b4c3 9dab f376 1bc4 f504 efa4
 ** 3e0b 668f 2d00 09bb f1ff b3e7 3fd9 2be2
 ** b625 af9d a725 291f a4eb 6ba9 c5e0 d182
 ** a08f 2241 c3db 3b5e 4f2f c92a 5c7d 6a7c
 ** 9d3e 11cf 2e00 fb5f 1299 1449 2ce9 0daa
 ** f551 13b2 fd91 0025 1759 8995 4531 1759
 ** 7c93 7a3b 929a bd17 3ecd 9f21 63f1 418a
 ** 3c86 5b30 afcb a5ba 5122 9204 e09f 2bd1
 ** 1859 2d8d 5735 b83c ae2c 33e6 fdf8 8d15
 ** e7a9 c54c c3da 1fa4 9c1e 0cf0 493d 1d63
 */

	mov r2, #0x5b60	// initial state
	movt r2, #0x6614
	mov r3, #0x9de0
	movt r3, #0x3bb1
	mov r4, #0xee56
	movt r4, #0xaf23
	mov r5, #0x3e72
	movt r5, #0xf04a
	// now r2-r5 contains entire 128 bit of state
	mov r6, #0xc54c	// initial key
	movt r6, #0xe7a9
	mov r7, #0x1fa4
	movt r7, #0xc3da
	mov r8, #0x0cf0
	movt r8, #0x9c1e
	mov r9, #0x1d63
	movt r9, #0x493d

/*	mov r2, #0x00002233	// initial state
	movt r2, #0x0011
	mov r3, #0x00006677
	movt r3, #0x4455
	mov r4, #0x0000aabb
	movt r4, #0x8899
	mov r5, #0x0000eeff
	movt r5, #0xccdd
	// now r2-r5 contains entire 128 bit of state
	mov r6, #0x00000203	// initial key
	movt r6, #0x0001
	mov r7, #0x00000607
	movt r7, #0x0405
	mov r8, #0x00000a0b
	movt r8, #0x0809
	mov r9, #0x00000e0f
	movt r9, #0x0c0d
*/
	// now r6-r9 contains entire 128 bit key
	eor r1, r2, r6
	eor r2, r3, r7
	eor r3, r4, r8
	eor r4, r5, r9
	// now r1-r4 contains state xored with key

	mov r12, #0x01000000		// first round-constant
	mov r5, #10					// to count rounds
	push {r6, r7, r8, r9}
	push {r5, r9, r12}
	// storing bottom--> all 4 key columns|round-constant|key-column#4|round-counter -->top
	.fnend /* End of the program */

aes_encrypt:
/* input: r1-r4: state xored with key
** output: r1-r4 encrypted message
*/
	//------------------------- bitslicing -------------------------------

	mov r12, #0x80808080	/* getting x0, x8,..., x120 */
	//and r5, r1, r12	/* every 8'th bit of bits 0-31 */
	mov r0, #0	// an iterator for x0-x7
	bl bitslicing
	mov r8, r5	/* now r8 contains (x0,x8,...,x120|00...0) */

	add r0, r0, #1	/* to get x1, x9,..., x121 */
	bl bitslicing
	lsr r5, r5, #16
	add r8, r8, r5	/* now r8 contains- (x0,x8,...,x120|x1,x9,...,x121) */

	add r0, r0, #1	/* to get x2, x10,..., x122 */
	bl bitslicing
	mov r9, r5		/* now r9 contains (x2,x10,...,x122|00..0) */

	add r0, r0, #1	/* to get x3, x11,..., x123 */
	bl bitslicing
	mov r10, r5		/* now r10 contains (x3,x11,...,x123|00...0) */

	add r0, r0, #1	/* to get x4, x12,..., x124 */
	bl bitslicing
	mov r11, r5		/* now r11 contains (x4,x12,...,x124|00...0) */

	add r0, r0, #1		/* to get x5, x13,..., x125 */
	bl bitslicing
	lsr r5, r5, #16
	add r10, r10, r5	/* now r10 contains (x3,x11,...,x123|x5,x13,...,x125) */

	add r0, r0, #1	/* to get x6, x14,..., x126 */
	bl bitslicing
	lsr r5, r5, #16
	add r11, r11, r5	/* now r11 contains (x4,x12,...,x124|x6,x14,...,x126) */

	add r0, r0, #1	/* to get x7,x15,...,x127 */
	bl bitslicing
	lsr r5, r5, #16
	add r9, r9, r5	/* now r9 contains (x2,x10,...,x122|x7,x15,...,x127) */

	// -------------------------- S-Box --------------------------------------------------
	bl bitsliced_sbox
	// -------------------------- reversed bitslice --------------------------------------
	bl reversed_bitslice
	// now r4-r7 hold s0-s127 :)

	// ---------------- shift rows --------------------

	and r8, r4, #0xff000000	// r8: state[0]
	and r9, r5, #0xff000000	// r9: state[4]
	and r10, r6, #0xff000000// r10: state[8]
	and r11, r7, #0xff000000// r11: state[12]
	and r0, r4, #0x00ff0000	// r0: state[1]
	add r11, r11, r0		// r11: state[12]|state[1]
	and r0, r5, #0x00ff0000	// r0: state[5]
	add r8, r8, r0			// r8: state[0]|state[5]
	and r0, r6, #0x00ff0000	// r0: state[9]
	add r9, r9, r0			// r9: state[4]|state[9]
	and r0, r7, #0x00ff0000	// r0: state[13]
	add r10, r10, r0		// r10: state[8]|state[13]
	and r0, r4, #0x0000ff00	// r0: state[2]
	add r10, r10, r0		// r10: state[8]|state[13]|state[2]
	and r0, r5, #0x0000ff00	// r0: state[6]
	add r11, r11, r0		// r11: state[12]|state[1]|state[6]
	and r0, r6, #0x0000ff00	// r0: state[10]
	add r8, r8, r0			// r8: state[0]|state[5]|state[10]
	and r0, r7, #0x0000ff00	// r0: state[14]
	add r9, r9, r0			// r9: state[4]|state[9]|state[14]
	and r0, r4, #0x000000ff	// r0: state[3]
	add r9, r9, r0			// r9: state[4]|state[9]|state[14]|state[3]
	and r0, r5, #0x000000ff	// r0: state[7]
	add r10, r10, r0		// r10: state[8]|state[13]|state[2]|state[7]
	and r0, r6, #0x000000ff	// r0: state[11]
	add r11, r11, r0		// r11: state[12]|state[1]|state[6]|state[11]
	and r0, r7, #0x000000ff	// r0: state[15]
	add r8, r8, r0			// r8: state[0]|state[5]|state[10]|state[15]
// now r8-r11 hold the state bits after shift rows

// ---------------- mix columns ---------------------

	pop {r5}	// round-counter
	sub r5, r5, #1	// subtract and store
	push {r5}
	// if round counter reaches 0 it means we did 9 rounds
	// and it is the last round so no need to do mix columns:
	cbz r5, key_expansion
/*
	bl mix_col
	mov r7, r4	// move output of the rightmost (fourth) column
	mov r11, r10	// move next column to the left (third) as input
	bl mix_col
	mov r6, r4	// move output to the third column
	mov r11, r9	// move second column as input
	bl mix_col
	mov r5, r4	// move output to the second column
	mov r11, r8	// move first column as input
	bl mix_col	// output on the first column
*/
	bl mix_columns
	// new columns are in r4-r7

key_expansion:
// --------------- key expansion ------------------------

	pop {r0}	// round counter
	cbnz r0, did_mix_columns
	// if it is the last round move the result regs from shift rows into result regs from mix columns
	mov r4, r8
	mov r5, r9
	mov r6, r10
	mov r7, r11
did_mix_columns:
	pop {r3}		// getting the previous round key's #4th column into r3
	push {r0, r4, r5, r6, r7}	// storing state bits on bottom and round counter on top
	ror r3, r3, #24			// moving the first byte to be the last byte
	// bitslicing 32 bit of r3 and then s-box
	// creating the sbox input- r8: (x0|x1) r9: (x2|x7) r10: (x3|x5) r11: (x4|x6)
	and r8, r3, #0x80808080	// bitslicing x0
	lsl r1, r8, #7
	add r8, r8, r1
	lsl r1, r1, #7
	add r8, r8, r1
	lsl r1, r1, #7
	add r8, r8, r1
	and r8, r8, #0xf0000000		// r8: (x0|0)
	and r11, r3, #0x40404040	// bitslicing x1
	lsl r11, r11, #1
	lsl r1, r11, #7
	add r11, r11, r1
	lsl r1, r1, #7
	add r11, r11, r1
	lsl r1, r1, #7
	add r11, r11, r1
	and r11, r11, #0xf0000000
	lsr r11, r11, #16
	add r8, r8, r11				// r8: (x0|x1)
	and r9, r3, #0x20202020		// bitslicing x2
	lsl r9, r9, #2
	lsl r1, r9, #7
	add r9, r9, r1
	lsl r1, r1, #7
	add r9, r9, r1
	lsl r1, r1, #7
	add r9, r9, r1
	and r9, r9, #0xf0000000		// r9: (x2|0)
	and r11, r3, #0x01010101	// bitslicing x7
	lsl r11, r11, #7
	lsl r1, r11, #7
	add r11, r11, r1
	lsl r1, r1, #7
	add r11, r11, r1
	lsl r1, r1, #7
	add r11, r11, r1
	and r11, r11, #0xf0000000
	lsr r11, r11, #16
	add r9, r9, r11				// r9: (x2|x7)
	and r10, r3, #0x10101010	// bitslicing x3
	lsl r10, r10, #3
	lsl r1, r10, #7
	add r10, r10, r1
	lsl r1, r1, #7
	add r10, r10, r1
	lsl r1, r1, #7
	add r10, r10, r1
	and r10, r10, #0xf0000000	// r10: (x3|0)
	and r11, r3, #0x04040404	// bitslicing x5
	lsl r11, r11, #5
	lsl r1, r11, #7
	add r11, r11, r1
	lsl r1, r1, #7
	add r11, r11, r1
	lsl r1, r1, #7
	add r11, r11, r1
	and r11, r11, #0xf0000000
	lsr r11, r11, #16
	add r10, r10, r11			// r10: (x3|x5)
	and r11, r3, #0x08080808	// bitslicing x4
	lsl r11, r11, #4
	lsl r1, r11, #7
	add r11, r11, r1
	lsl r1, r1, #7
	add r11, r11, r1
	lsl r1, r1, #7
	add r11, r11, r1
	and r11, #0xf0000000		// r11: (x4|0)
	and r4, r3, #0x02020202		// bitslicing x6
	lsl r4, r4, #6
	lsl r1, r4, #7
	add r4, r4, r1
	lsl r1, r1, #7
	add r4, r4, r1
	lsl r1, r1, #7
	add r4, r4, r1
	and r4, r4, #0xf0000000
	lsr r4, r4, #16
	add r11, r11, r4			// r11: (x4|x6)

	bl bitsliced_sbox
	// result is in: r1:(s0|t60) r3:(s1|s2) r11:(s3|t67) r9:(s5|s4) r2: (s7|s6)

	// reverse bitslice into r4:
	and r4, r1, #0xf0000000	// r4: s0
	lsr r0, r4, #7
	add r4, r4, r0
	lsr r0, r0, #7
	add r4, r4, r0
	lsr r0, r0, #7
	add r4, r4, r0
	and r4, r4, #0x80808080
	and r1, r3, #0xf0000000	// r1: s1
	lsr r0, r1, #1
	lsr r1, r0, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	and r0, r0, #0x40404040
	add r4, r4, r0			// r4: s0,s1
	and r1, r3, #0x0000f000	// r1: s2
	lsl r0, r1, #14
	lsr r1, r0, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	and r0, r0, #0x20202020
	add r4, r4, r0			// r4: s0,s1,s2
	and r1, r11, #0xf0000000// r1: s3
	lsr r0, r1, #3
	lsr r1, r0, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	and r0, r0, #0x10101010
	add r4, r4, r0			// r4: s0,s1,s2,s3
	and r1, r9, #0x0000f000	// r1: s4
	lsl r0, r1, #12
	lsr r1, r0, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	and r0, r0, #0x08080808
	add r4, r4, r0			// r4: s0,s1,s2,s3,s4
	and r1, r9, #0xf0000000	// r1: s5
	lsr r0, r1, #5
	lsr r1, r0, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	and r0, r0, #0x04040404
	add r4, r4, r0			// r4: s0,s1,s2,s3,s4,s5
	and r1, r2, #0x0000f000	// r1: s6
	lsl r0, r1, #10
	lsr r1, r0, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	and r0, r0, #0x02020202
	add r4, r4, r0			// r4: s0,s1,s2,s3,s4,s5,s6
	and r1, r2, #0xf0000000	// r1: s7
	lsr r0, r1, #7
	lsr r1, r0, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	lsr r1, r1, #7
	add r0, r0, r1
	and r0, r0, #0x01010101
	add r4, r4, r0			// r4: s0,s1,s2,s3,s4,s5,s6,s7

	pop {r0, r6, r7, r8, r9}
	pop {r2}
	// r0: round counter r6-r9: state r2: round constant
	pop {r1, r3, r5, r10}	// previous round key
	eor r4, r4, r2			// xoring with the round-constant from the previous round
	eor r1, r1, r4			// xoring each column of the key with the previous result
	eor r3, r3, r1
	eor r5, r5, r3
	eor r10, r10, r5

	cbz r0, output			// if last round-> no need to waste cycles on these commands:
	bl galois_mul2			// r2: 2* round constant
	push {r1, r3, r5, r10}	// all 4 key columns
	push {r2}				// next round-constant
	push {r0, r10}			// 4'th key column|round counter
output:
	// xor key with state:
	eor r1, r1, r6
	eor r2, r3, r7
	eor r3, r5, r8
	eor r4, r10, r9

	cbz r0, end	// if round counter is 0-> meaning last round-> no need to loop
	b aes_encrypt
	// else -> it is the last round and result in r1-r4

end: bx lr



