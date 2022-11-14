.syntax unified

.arch armv6t2

.text

.globl   fix_encrypt

.p2align 2
.type   fix_encrypt ,%function

fixslicing:
/* input: r0-r3 128 bit
** output: r8: (x0|x1) r9: (x2|x7) r10: (x3|x5) r11: (x4|x6)
*/
	and r4, r0, #0x80808080	// first bit of every byte
	and r5, r1, #0x80808080
	lsr r5, r5, #1
	add r4, r4, r5
	and r5, r2, #0x80808080
	lsr r5, r5, #2
	add r4, r4, r5
	and r5, r3, #0x80808080
	lsr r5, r5, #3
	add r4, r4, r5		// r4: (byte0|0000|byte1|0000|byte2|0000|byte3|0000)
	lsl r5, r4, #4
	add r4, r4, r5		// r4: (byte0|byte1|byte1|byte2|byte2|byte3|byte3|0000)
	lsl r5, r4, #12
	lsr r5, r5, #8
	mov r6, #0xff000000
	and r4, r4, r6
	add r4, r4, r5		// r4: (byte0|byte1|byte2|byte2|byte3|byte3|0000|0000)
	lsl r5, r4, #16
	lsr r5, r5, #12
	asr r7, r6, #4		// r7: fff00000
	and r4, r4, r7
	add r4, r4, r5		// r4: (byte0|byte1|byte2|byte3|byte3|0000|0000|0000)
	asr r12, r7, #4		// r12: ffff0000
	and r8, r4, r12		// r8: (x0|0)

	and r4, r0, #0x40404040	// second bit of every byte
	lsl r4, r4, #1
	and r5, r1, #0x40404040
	add r4, r4, r5
	and r5, r2, #0x40404040
	lsr r5, r5, #1
	add r4, r4, r5
	and r5, r3, #0x40404040
	lsr r5, r5, #2
	add r4, r4, r5
	lsl r5, r4, #4
	add r4, r4, r5
	lsl r5, r4, #12
	lsr r5, r5, #8
	and r4, r4, r6
	add r4, r4, r5
	lsl r5, r4, #16
	lsr r5, r5, #12
	and r4, r4, r7
	add r4, r4, r5
	lsr r4, r4, #16
	add r8, r8, r4		// r8: x0|x1

	and r4, r0, #0x20202020	// third bit of every byte
	lsl r4, r4, #2
	and r5, r1, #0x20202020
	lsl r5, r5, #1
	add r4, r4, r5
	and r5, r2, #0x20202020
	add r4, r4, r5
	and r5, r3, #0x20202020
	lsr r5, r5, #1
	add r4, r4, r5
	lsl r5, r4, #4
	add r4, r4, r5
	lsl r5, r4, #12
	lsr r5, r5, #8
	and r4, r4, r6
	add r4, r4, r5
	lsl r5, r4, #16
	lsr r5, r5, #12
	and r4, r4, r7
	add r4, r4, r5
	and r9, r4, r12		// r9: x2|0

	and r4, r0, #0x10101010	// fourth bit of every byte
	lsl r4, r4, #3
	and r5, r1, #0x10101010
	lsl r5, r5, #2
	add r4, r4, r5
	and r5, r2, #0x10101010
	lsl r5, r5, #1
	add r4, r4, r5
	and r5, r3, #0x10101010
	add r4, r4, r5
	lsl r5, r4, #4
	add r4, r4, r5
	lsl r5, r4, #12
	lsr r5, r5, #8
	and r4, r4, r6
	add r4, r4, r5
	lsl r5, r4, #16
	lsr r5, r5, #12
	and r4, r4, r7
	add r4, r4, r5
	and r10, r4, r12	// r10: x3|0

	and r4, r0, #0x08080808	// fifth bit of every byte
	lsl r4, r4, #4
	and r5, r1, #0x08080808
	lsl r5, r5, #3
	add r4, r4, r5
	and r5, r2, #0x08080808
	lsl r5, r5, #2
	add r4, r4, r5
	and r5, r3, #0x08080808
	lsl r5, r5, #1
	add r4, r4, r5
	lsl r5, r4, #4
	add r4, r4, r5
	lsl r5, r4, #12
	lsr r5, r5, #8
	and r4, r4, r6
	add r4, r4, r5
	lsl r5, r4, #16
	lsr r5, r5, #12
	and r4, r4, r7
	add r4, r4, r5
	and r11, r4, r12	// r11: x4|0

	and r4, r0, #0x04040404	// sixth bit of every byte
	lsl r4, r4, #5
	and r5, r1, #0x04040404
	lsl r5, r5, #4
	add r4, r4, r5
	and r5, r2, #0x04040404
	lsl r5, r5, #3
	add r4, r4, r5
	and r5, r3, #0x04040404
	lsl r5, r5, #2
	add r4, r4, r5
	lsl r5, r4, #4
	add r4, r4, r5
	lsl r5, r4, #12
	lsr r5, r5, #8
	and r4, r4, r6
	add r4, r4, r5
	lsl r5, r4, #16
	lsr r5, r5, #12
	and r4, r4, r7
	add r4, r4, r5
	lsr r4, r4, #16
	add r10, r10, r4	// r10: x3|x5

	and r4, r0, #0x02020202	// seventh bit of every byte
	lsl r4, r4, #6
	and r5, r1, #0x02020202
	lsl r5, r5, #5
	add r4, r4, r5
	and r5, r2, #0x02020202
	lsl r5, r5, #4
	add r4, r4, r5
	and r5, r3, #0x02020202
	lsl r5, r5, #3
	add r4, r4, r5
	lsl r5, r4, #4
	add r4, r4, r5
	lsl r5, r4, #12
	lsr r5, r5, #8
	and r4, r4, r6
	add r4, r4, r5
	lsl r5, r4, #16
	lsr r5, r5, #12
	and r4, r4, r7
	add r4, r4, r5
	lsr r4, r4, #16
	add r11, r11, r4	// r11: x4|x6

	and r4, r0, #0x01010101	// eighth bit of every byte
	lsl r4, r4, #7
	and r5, r1, #0x01010101
	lsl r5, r5, #6
	add r4, r4, r5
	and r5, r2, #0x01010101
	lsl r5, r5, #5
	add r4, r4, r5
	and r5, r3, #0x01010101
	lsl r5, r5, #4
	add r4, r4, r5
	lsl r5, r4, #4
	add r4, r4, r5
	lsl r5, r4, #12
	lsr r5, r5, #8
	and r4, r4, r6
	add r4, r4, r5
	lsl r5, r4, #16
	lsr r5, r5, #12
	and r4, r4, r7
	add r4, r4, r5
	lsr r4, r4, #16
	add r9, r9, r4		// r9: x2|x7

	bx lr


parallel_sbox:
/* input: r8-r11 bitsliced 128 bit
** r8: (x0|x1) r9: (x2|x7) r10: (x3|x5) r11: (x4|x6)
** output: r1, r2, r3, r9 bitsliced 128 bit
** r1:(s0|s3) r3:(s1|s2) r9:(s5|s4) r2: (s7|s6)
*/
	// first layer:
	lsl r0, r11, #16	// r0: x6|0
	eor r1, r8, r0		// r1: x6^x0 = y13|x1
	lsl r2, r10, #16	// r2: x5|0
	lsl r12, r8, #16	// r12: x1|0
	eor r4, r12, r9		// r4: x1^x2 = t0|x7
	lsl r9, r9, #16		// r9: x7|0
	eor r5, r9, r4		// r5: x7^t0 = y1|x7
	eor r0, r0, r5		// r0: y1^x6 = y5|x7
	eor r6, r8, r2		// r6: x0^x5 = y8|x1
	eor r3, r2, r10		// r3: x5^x3 = y14
	push {r3}		// storing y14
	eor r3, r3, r1		// r3: y13^y14 = y12
	push {r3}	// storing y12
	eor r3, r3, r11		// r3: y12^x4 = t1 | freeing r11
	eor r2, r2, r3		// r2: x5^t1 = y15
	eor r3, r3, r12		// r3: t1^x1 = y20 | freeing r12
	eor r12, r10, r8	// r12: x3^x0 = y9
	push {r12}	// storing y9
	eor r9, r12, r3		// r9: y9^y20 = y11 | last use in y9 & y20 for this layer
	eor r12, r4, r2		// r12: t0^y15 = y10
	eor r4, r4, r9		// r4: t0^y11 = y16
	push {r1, r4, r6, r12}	// storing top -> y13|y16|y8|y10
	push {r0, r5}	// storing top -> (y5|x7)|(y1|x7)
	push {r2}	// storing y15
	push {r9}	// storing y11
	eor r9, r8, r4		// r9: x0^y16 = y18
	eor r7, r6, r12		// r7: y8^y10 = y19
	push {r7, r9}	// storing top -> y19|y18
	and r7, r6, r12	// calculation for next layer: y8 & y10 = t15
	push {r7}	// storing top-> t15
	eor r7, r1, r4		// r7: y13^y16 = y21
	push {r7}	// storing y21
	eor r6, r6, r0		// r6: y5^y8 = y3
	eor r9, r5, r10		// r9: y1^x3 = y4
	eor r7, r5, r8		// r7: y1^x0 = y2
	push {r3, r7}	// storing top -> y20|y2
	push {r2, r6}	// storing top -> y15|y3
	lsl r2, r10, #16	// r2: x5|0
	eor r2, r2, r10		// r2: x5^x3 = y14
	eor r7, r2, r1		// r7: y13^y14 = y12
	eor r6, r7, r11		// r6: y12^x4 = t1
	eor r8, r8, r10		// r8: x3^x0 = y9
	lsl r10, r10, #16	// r10: x5|0
	eor r10, r10, r6	// r10: x5^t1 = y15
	eor r11, r8, r3		// r11: y9^y20 = y11
	eor r12, r12, r11	// r12: y10^y11 = y17
	lsl r6, r0, #16		// r6: x7|0
	eor r10, r10, r6	// r10: x7^y15 = y6
	eor r3, r6, r11		// r3: x7^y11 = y7
	/* second layer
	** current status:
	** r0: (y5|x7) r1: (y13) r2: (y14) r3: (y7) r4: (y16) r5: (y1|x7) r6: (x7)
	** r7: (y12) r8: (y9) r9: (y4) r10: (y6) r11: (y11) r12: (y17)
	** stack: top -> y15|y3|y20|y2|y21|t15|y19|y18|y11|y15|y5|y1|y13|y16|y8|y10|y9|y12|y14 -> bottom
	*/
	and r2, r2, r12		// r2: y14 & y17 = t13
	and r11, r11, r8	// r11: y11 & y9 = t12 (also freeing r8)
	eor r2, r2, r11		// r2: t13 ^ t12 = t14
	and r5, r5, r0		// r5: y1 & y5 = t8 (also freeing r0)
	and r4, r4, r1		// r4: y16 & y13 = t7 (also freeing r1)
	eor r5, r5, r4		// r5: t8 ^ t7 = t9
	eor r5, r5, r2		// r5: t9 ^ t14 = t19
	pop {r0, r1}	// r0: y15 | r1: y3
	and r0, r0, r7		// r0: y15 & y12 = t2 (also freeing r7)
	and r7, r1, r10		// r7: y3 & y6 = t3
	eor r7, r7, r0		// r7: t3 ^ t2 = t4
	eor r2, r2, r7		// r2: t14 ^ t4 = t17 (also freeing r7)
	pop {r7}	// r7: y20
	eor r2, r2, r7		// r2: t17 ^ y20 = t21 (also freeing r7)
	pop {r7}	// r7: y2
	and r8, r7, r3		// r8: y2 & y7 = t10
	eor r8, r8, r4		// r8: t10 ^ t7 = t11 (also freeing r4)
	pop {r4}	// r4: y21
	eor r5, r5, r4		// r5: t19 ^ y21 = t23 (also freeing r4)
	pop {r4}	// r4: t15
	eor r11, r11, r4	// r11: t12 ^ t15 = t16 (also freeing r4)
	eor r8, r8, r11		// r8: t11 ^ t16 = t20
	and r4, r6, r9		// r4: x7 & y4 = t5
	eor r0, r0, r4		// r0: t2 ^ t5 = t6 (also freeing r4)
	eor r0, r0, r11		// r0: t6 ^ t16 = t18 (also freeing r11)
	pop {r4}	// r4: y19
	eor r0, r0, r4		// r0: t18 ^ y19 = t22 (also freeing r4)
	pop {r4}	// r4: y18
	eor r8, r8, r4		// r8: t20 ^ y18 = t24 (also freeing r4)
	and r4, r2, r5		// r4: t21 & t23 = t26
	eor r2, r2, r0		// r2: t21 ^ t22 = t25
	eor r11, r8, r4		// r11: t24 ^ t26 = t27
	eor r4, r4, r0		// r4: t26 ^ t22 = t31
	/* current status:
	** r0: (t22) r1: (y3) r2: (t25) r3: (y7) r4: (t31) r5: (t23) r6: (x7)
	** r7: (y2) r8: (t24) r9: (y4) r10: (y6) r11: (t27) r12: (y17)
	** stack top -> y11|y15|y5|y1|y13|y16|y8|y10|y9|y12|y14 -> bottom
	*/
	push {r1}	// to calculate some temporary values
	eor r1, r5, r8		// r1: t23 ^ t24 = t30
	and r4, r4, r1		// r4: t30 & t31 = t32 (also freeing r1)
	eor r4, r4, r8		// r4: t32 ^ t24 = t33
	eor r5, r5, r4		// r5: t33 ^ t23 = t34
	eor r1, r4, r11		// r1: t33 ^ t27 = t35
	and r8, r8, r1		// r8: t35 & t24 = t36 (also freeing r1)
	pop {r1}
	eor r5, r5, r8		// r5: t36 ^ t34 = t37
	eor r8, r8, r11		// r8: t36 ^ t27 = t38
	and r11, r11, r2	// r11: t27 & t25 = t28
	eor r0, r0, r11		// r0: t28 ^ t22 = t29 (also freeing r11)
	and r8, r8, r0		// r8: t29 & t38 = t39
	eor r8, r8, r2		// r8: t39 ^ t25 = t40 (also freeing r2)
	eor r2, r4, r0		// r2: t33 ^ t29 = t42
	eor r11, r5, r4		// r11: t33 ^ t37 = t44
	lsr r2, r2, #16
	lsl r2, r2, #16		// r2: (t42|0)
	lsr r11, r11, #16	// r11: (0|t44)
	add r11, r11, r2	// r11: (t42|t44) (also freeing r2)
	eor r2, r0, r8		// r2: t29 ^ t40 = t43
	lsr r8, r8, #16
	lsl r8, r8, #16		// r8: (t40|0)
	lsr r0, r0, #16		// r0: (0|t29)
	add r0, r0, r8		// r0: (t40|t29) (also freeing r8)
	lsr r5, r5, #16
	lsl r5, r5, #16		// r5: (t37|0)
	lsr r2, r2, #16		// r2: (0|t43)
	add r5, r5, r2		// r5: (t37|t43) (also freeing r2)
	pop {r2, r8}	// r2: y11 | r8: y15
	lsr r2, r2, #16
	lsl r2, r2, #16		// r2: (y11|0)
	lsr r8, r8, #16		// r8: (0|y15)
	add r2, r2, r8		// r2: (y11|y15) (also freeing r8)
	and r2, r2, r11		// r2: t42&y11 | t44&y15 = (z6|z0)
	pop {r8}	// r8: y5
	lsr r8, r8, #16
	lsl r8, r8, #16		// r8: (y5|0)
	lsr r3, r3, #16		// r3: (0|y7)
	add r3, r3, r8		// r3: (y5|y7) (also freeing r8)
	and r3, r3, r0		// r3: t40&y5| t29&y7 = (z13|z5)
	pop {r8}	// r8: y1
	lsr r8, r8, #16
	lsl r8, r8, #16		// r8: (y1|0)
	lsr r7, r7, #16		// r7: (0|y2)
	add r7, r7, r8		// r7: (y1|y2) (also freeing r8)
	and r7, r7, r0		// r7: t40&y1 | t29&y2 = (z4|z14)
	pop {r8}	// r8: y13
	lsr r10, r10, #16
	lsl r10, r10, #16	// r10: (y6|0)
	lsr r8, r8, #16		// r8: (0|y13)
	add r10, r10, r8	// r10: (y6|y13) (also freeing r8)
	and r10, r10, r5	// r10: t37&y6 | t43&y13 = (z1|z12)
	pop {r8}	// r8: y16
	lsr r1, r1, #16
	lsl r1, r1, #16		// r1: (y3|0)
	lsr r8, r8, #16		// r8: (0|y16)
	add r1, r1, r8		// r1: (y3|y16) (also freeing r8)
	and r1, r1, r5		// r1: t37&y3 | t43&y16 = (z10|z3)
	eor r5, r5, r0		// r5: t37 ^ t40 = t41 (also freeing r0)
	eor r0, r5, r11		// r0: t41 ^ t42 = t45
	lsr r5, r5, #16
	lsl r5, r5, #16		// r5: (t41|0)
	lsr r4, r4, #16		// r4: (0|t33)
	add r4, r4, r5		// r4: (t41|t33) (also freeing r5)
	pop {r8}	// r8: y8
	lsr r8, r8, #16
	lsl r8, r8, #16		// r8: (y8|0)
	lsr r9, r9, #16		// r9: (0|y4)
	add r9, r9, r8		// r9: (y8|y4) (also freeing r8)
	and r9, r9, r4		// r9: t41&y8 | t33&y4 = (z17|z11)
	pop {r8}	// r8: y10
	lsr r8, r8, #16
	lsl r8, r8, #16		// r8: (y10|0)
	lsr r6, r6, #16		// r6: (0|x7)
	add r6, r6, r8		// r6: (y10|x7) (also freeing r8)
	and r6, r6, r4		// r6: t41&y10 | t33&x7 = (z8|z2) (also freeing r4)
	pop {r4, r8}	// r4: y9 | r8: y12
	lsr r4, r4, #16
	lsl r4, r4, #16		// r4: (y9|0)
	lsr r8, r8, #16		// r8: (0|y12)
	add r4, r4, r8		// r4: (y9|y12) (also freeing r8)
	and r4, r4, r11		// r4: t42&y9 | t44&y12 = (z15|z9) (also freeing r11)
	pop {r8}	// r8: y14
	and r8, r8, r0		// r8: t45 & y14 = z16
	and r12, r12, r0	// r12: t45 & y17 = z7 (also freeing r0)
	/* third and final layer! currrent status:
	** r0: free r1: (z10|z3) r2: (z6|z0) r3: (z13|z5) r4: (z15|z9) r5: free r6: (z8|z2)
	** r7: (z4|z14) r8: (z16) r9: (z17|z11) r10: (z1|z12) r11: free r12: (z7)
	*/
	eor r0, r4, r8		// r0: z15 ^ z16 = t46 (last use in z15)
	lsl r4, r4, #16		// r4: (z9|0)
	eor r8, r8, r9		// r8: z16 ^ z17 = t55 (last use in z17)
	lsl r9, r9, #16		// r9: (z11|0)
	eor r9, r9, r1		// r9: z11 ^ z10 = t47
	eor r4, r4, r1		// r4: z9 ^ z10 = t49 (last use in z10)
	lsl r1, r1, #16		// r1: (z3|0)
	eor r5, r2, r12		// r5: z6 ^ z7 = t54 (last use in z6)
	lsl r2, r2, #16		// r2: (z0|0)
	eor r5, r5, r1		// r5: t54 ^ z3 = t59
	eor r2, r2, r1		// r2: z0 ^ z3 = t53 (freeing r1)
	eor r1, r0, r7		// r1: t46 ^ z4 = t58
	eor r12, r12, r6	// r12: z7 ^ z8 = t52 (last use in z8)
	lsl r6, r6, #16		// r6: (z2|0)
	eor r12, r12, r1	// r12: t52 ^ t58 = t62
	eor r4, r4, r1		// r4: t49 ^ t58 = t63 (freeing r1)
	lsl r1, r3, #16		// r1: (z5|0)
	eor r3, r3, r1		// r3: z13 ^ z5 = t48
	eor r1, r1, r6		// r1: z5 ^ z2 = t51
	eor r11, r10, r4	// r11: z1 ^ t63 = t66 (last use in z1)
	lsl r10, r10, #16	// r10: (z12|0)
	eor r6, r6, r10		// r6: z2 ^ z12 = t50
	eor r10, r10, r3	// r10: z12 ^ t48 = t56
	eor r6, r6, r2		// r6: t50 ^ t53 = t57
	eor r0, r0, r6		// r0: t46 ^ t57 = t60
	eor r0, r0, r3		// r0: t60 ^ t48 = s7! (freeing r3)
	eor r10, r10, r12	// r10: t56 ^ t62 = s6!
	eor r2, r2, r11		// r2: t53 ^ t66 = s3
	eor r4, r4, r5		// r4: t63 ^ t59 = s0
	eor r5, r5, r7		// r5: t59 ^ z4 = t64 (last use in z4)
	lsl r7, r7, #16		// r7: (z14|0)
	eor r3, r5, r2		// r3: t64 ^ s3 = s1!
	eor r11, r11, r1	// r11: t66 ^ t51 = s4 (freeing r1)
	lsr r4, r4, #16
	lsl r4, r4, #16		// r4: (s0|0)
	lsr r2, r2, #16		// r2: (0|s3)
	add r1, r2, r4		// r1: (s0|s3) freeing r2 & r4
	lsr r0, r0, #16
	lsl r0, r0, #16		// r0: (s7!|0)
	lsr r10, r10, #16	// r10: (0|s6!)
	add r2, r0, r10		// r2: (s7!|s6!) freeing r0 & r10
	mvn r2, r2			// r2: (s7|s6)
	eor r7, r7, r6		// r7: z14 ^ t57 = t61 (freeing r6)
	eor r7, r7, r12		// r7: t61 ^ t62 = t65 (freeing r12)
	eor r9, r9, r7		// r9: t47 ^ t65 = s5
	eor r7, r7, r5		// r7: t65 ^ t64 = t67 (freeing r5)
	eor r7, r7, r8		// r7: t67 ^ t55 = s2! (freeing r8)
	mov r12, #0xffff
	lsl r12, r12, #16	// r12: (1|0)
	and r3, r3, r12		// r3: (s1!0)
	lsr r7, r7, #16		// r2: (0|s2!)
	add r3, r3, r7		// r3: (s1!|s2!)
	mvn r3, r3			// r3: (s1|s2)
	and r9, r9, r12		// r9: (s5|0)
	lsr r11, r11, #16	// r11: (0|s4)
	add r9, r9, r11		// r9: (s5|s4)
	// result is in: r1:(s0|s3) r3:(s1|s2) r9:(s5|s4) r2: (s7|s6)
	bx lr

greedy_sbox:
/* input: r8-r11 bitsliced 128 bit
** r8: (x0|x1) r9: (x2|x7) r10: (x3|x5) r11: (x4|x6)
** output: r1, r2, r3, r9 bitsliced 128 bit
** r1:(s0|s3) r3:(s1|s2) r9:(s5|s4) r2: (s7|s6)
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
	and r1, r1, r12		// r1: (s0|0)
	lsr r11, r11, #16	// r11: (0|s3)
	add r1, r1, r11		// r1: (s0|s3)
/*
 result is in: r1:(s0|s3) r3:(s1|s2) r9:(s5|s4) r2: (s7|s6)
*/
	bx lr

mix_columns_0:
/* input:
** r1:(s0|s3) r2:(s7|s6) r3:(s1|s2) r9:(s5|s4) r12:(1|0)
** output:
** r0:(s0|s3) r1:(s1|s2) r2:(s5|s4) r3:(s7|s6)
*/
	and r6, r1, #0xf000f000	// s0|s3 masking for 16 left rotation by 4
	and r7, r1, #0x0fff0fff	// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r0, r6, r7			// r0: s0|s3 b1b2b3b0
	and r6, r0, #0x88888888	// s0|s3 masking for 4 bit right rotation by 3
	and r7, r0, #0x77777777	// complement masking
	lsr r6, r6, #3
	lsl r7, r7, #1
	add r0, r6, r7			// r0: s0|s3 b1b2b3b0 after shift rows (SR)
	eor r8, r1, r0			// r8: s0|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r6, r8, #0xff00ff00	// s0|s3 masking for 16 bit right rotation by 8
	and r7, r8, #0x00ff00ff	// complement masking
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r4, r6, r7			// r4: s0|s3 b2^b3 b3^b0 b0^b1 b1^b2
	and r6, r4, #0xcccccccc	// s0|s3 masking for 4 bit right rotation by 2
	and r7, r4, #0x33333333	// complement masking
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r4, r6, r7			// r4: s0|s3 b2^b3 b3^b0 b0^b1 b1^b2 after SR
	eor r0, r0, r4			// r0: s0|s3 1*next-byte+1*next-next-byte+1*next-next-next-byte
	lsr r10, r8, #16		// r10: 0|s0^s0>>12 after SR
	eor r0, r0, r10			// because we need to add the irreducible poly to s3
	and r6, r3, #0xf000f000	// s1|s2 masking for 16 left rotation by 4
	and r7, r3, #0x0fff0fff	// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r1, r6, r7			// r1: s1|s2 b1b2b3b0
	and r6, r1, #0x88888888	// s1|s2 masking for 4 bit right rotation by 3
	and r7, r1, #0x77777777	// complement masking
	lsr r6, r6, #3
	lsl r7, r7, #1
	add r1, r6, r7			// r1: s1|s2 b1b2b3b0 after SR
	eor r4, r3, r1			// r4: s1|s2 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	mov r11, #0xffff
	and r8, r8, r11			// r8: 0|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r5, r4, #16			// r5: s2|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r8, r8, r5			// r8: s2|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r1, r1, r8			// r1: s1|s2 2*curr-byte+3*next-byte
	and r6, r4, #0xff00ff00
	and r7, r4, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r8, r6, r7			// r8: s1|s2 b2^b3 b3^b0 b0^b1 b1^b2
	and r6, r8, #0xcccccccc
	and r7, r8, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r8, r6, r7			// r8: s1|s2 b2^b3 b3^b0 b0^b1 b1^b2 after SR
	eor r1, r1, r8			// r1: s1|s2  2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	and r6, r2, #0xf000f000
	and r7, r2, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r3, r6, r7			// r3: s7|s6 b1b2b3b0
	and r6, r3, #0x88888888
	and r7, r3, #0x77777777
	lsr r6, r6, #3
	lsl r7, r7, #1
	add r3, r6, r7			// r3: s7|s6 b1b2b3b0 after SR
	eor r8, r3, r2			// r8: s7|s6 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r6, r9, #0xf000f000	// s5|s4 masking for 16 left rotation by 4
	and r7, r9, #0x0fff0fff	// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r2, r6, r7			// r2: s5|s4 b1b2b3b0
	and r6, r2, #0x88888888	// s5|s4 masking for 4 bit right rotation by 3
	and r7, r2, #0x77777777	// complement masking
	lsr r6, r6, #3
	lsl r7, r7, #1
	add r2, r6, r7			// r2: s5|s4 b1b2b3b0 after SR
	eor r9, r2, r9			// r9: s5|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r4, r4, r12			// r4: s1|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r5, r9, r11			// r5: 0|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r4, r4, r5			// r4: s1|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r0, r0, r4			// r0: s0|s3 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	and r6, r9, #0xff00ff00
	and r7, r9, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r4, r6, r7			// r4: s5|s4 b2^b3 b3^b0 b0^b1 b1^b2
	and r6, r4, #0xcccccccc
	and r7, r4, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r4, r6, r7			// r4: s5|s4 b2^b3 b3^b0 b0^b1 b1^b2 after SR
	eor r2, r2, r4			// r2: s5|s4 1*next-byte+1*n-n-b+1*n-n-n-b
	eor r2, r2, r10			// r2: s5|s4 s4 with the added irreducible poly
	lsr r9, r9, #16			// r9: 0|s5 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r4, r8, #16			// r4: s6|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r9, r9, r4			// r9: s6|s5 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r2, r2, r9			// r2: s5|s4 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	eor r3, r3, r10			// r3: s7|s6 s6 xored with the irreducible poly
	and r6, r8, #0xff00ff00
	and r7, r8, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r5, r6, r7			// r5: s7|s6 b2^b3 b3^b0 b0^b1 b1^b2
	and r6, r5, #0xcccccccc
	and r7, r5, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r5, r6, r7			// r5: s7|s6 b2^b3 b3^b0 b0^b1 b1^b2 after SR
	eor r3, r3, r5			// r3: s7|s6 1*next-byte+1*n-n-b+1*n-n-n-b
	lsr r8, r8, #16			// r8: 0|s7 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r10, r10, #16		// r10: s0|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r8, r8, r10			// r8: s0|s7 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r3, r3, r8			// r3: s7|s6 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b

	b key_expansion

mix_columns_1:
/* input:
** r1:(s0|s3) r2:(s7|s6) r3:(s1|s2) r9:(s5|s4) r12:(1|0)
** output:
** r0:(s0|s3) r1:(s1|s2) r2:(s5|s4) r3:(s7|s6)
*/
	and r6, r1, #0xf000f000	// masking for 16 left rotation by 4
	and r7, r1, #0x0fff0fff	// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r0, r6, r7			// r0: s0|s3 b1b2b3b0
	and r6, r0, #0xcccccccc	// masking for 4 bit right rotation by 2
	and r7, r0, #0x33333333	// complement masking
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r0, r6, r7			// r0: s0|s3 b1b2b3b0 after shift rows (SR)
	eor r8, r1, r0			// r8: s0|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r6, r8, #0xff00ff00	// masking for 16 bit right rotation by 8
	and r7, r8, #0x00ff00ff	// complement masking
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r4, r6, r7			// r4: s0|s3 b2^b3 b3^b0 b0^b1 b1^b2
	eor r0, r0, r4			// r0: s0|s3 1*next-byte+1*next-next-byte+1*next-next-next-byte
	lsr r10, r8, #16		// r10: 0|s0^s0>>12 after SR
	eor r0, r0, r10			// because we need to add the irreducible poly to s3
	and r6, r3, #0xf000f000
	and r7, r3, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r1, r6, r7			// r1: s1|s2 b1b2b3b0
	and r6, r1, #0xcccccccc
	and r7, r1, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r1, r6, r7			// r1: s1|s2 b1b2b3b0 after SR
	eor r4, r3, r1			// r4: s1|s2 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	mov r11, #0xffff
	and r8, r8, r11			// r8: 0|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r5, r4, #16			// r5: s2|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r8, r8, r5			// r8: s2|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r1, r1, r8			// r1: s1|s2 2*curr-byte+3*next-byte
	and r6, r4, #0xff00ff00
	and r7, r4, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r8, r6, r7			// r8: s1|s2 b2^b3 b3^b0 b0^b1 b1^b2
	eor r1, r1, r8			// r1: s1|s2  2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	and r6, r2, #0xf000f000
	and r7, r2, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r3, r6, r7			// r3: s7|s6 b1b2b3b0
	and r6, r3, #0xcccccccc
	and r7, r3, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r3, r6, r7			// r3: s7|s6 b1b2b3b0 after SR
	eor r8, r3, r2			// r8: s7|s6 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r6, r9, #0xf000f000
	and r7, r9, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r2, r6, r7			// r2: s5|s4 b1b2b3b0
	and r6, r2, #0xcccccccc
	and r7, r2, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r2, r6, r7			// r2: s5|s4 b1b2b3b0 after SR
	eor r9, r2, r9			// r9: s5|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r4, r4, r12			// r4: s1|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r5, r9, r11			// r5: 0|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r4, r4, r5			// r4: s1|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r0, r0, r4			// r0: s0|s3 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	and r6, r9, #0xff00ff00
	and r7, r9, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r4, r6, r7			// r4: s5|s4 b2^b3 b3^b0 b0^b1 b1^b2
	eor r2, r2, r4			// r2: s5|s4 1*next-byte+1*n-n-b+1*n-n-n-b
	eor r2, r2, r10			// r2: s5|s4 s4 with the added irreducible poly
	lsr r9, r9, #16			// r9: 0|s5 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r4, r8, #16			// r4: s6|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r9, r9, r4			// r9: s6|s5 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r2, r2, r9			// r2: s5|s4 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	eor r3, r3, r10			// r3: s7|s6 s6 xored with the irreducible poly
	and r6, r8, #0xff00ff00
	and r7, r8, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r5, r6, r7			// r5: s7|s6 b2^b3 b3^b0 b0^b1 b1^b2
	eor r3, r3, r5			// r3: s7|s6 1*next-byte+1*n-n-b+1*n-n-n-b
	lsr r8, r8, #16			// r8: 0|s7 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r10, r10, #16		// r10: s0|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r8, r8, r10			// r8: s0|s7 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r3, r3, r8			// r3: s7|s6 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b

	b key_expansion

mix_columns_2:
/* input:
** r1:(s0|s3) r2:(s7|s6) r3:(s1|s2) r9:(s5|s4) r12:(1|0)
** output:
** r0:(s0|s3) r1:(s1|s2) r2:(s5|s4) r3:(s7|s6)
*/
	and r6, r1, #0xf000f000	// masking for 16 left rotation by 4
	and r7, r1, #0x0fff0fff	// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r0, r6, r7			// r0: s0|s3 b1b2b3b0
	and r6, r0, #0xeeeeeeee	// masking for 4 bit right rotation by 1
	and r7, r0, #0x11111111	// complement masking
	lsr r6, r6, #1
	lsl r7, r7, #3
	add r0, r6, r7			// r0: s0|s3 b1b2b3b0 after shift rows (SR)
	eor r8, r1, r0			// r8: s0|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r6, r8, #0xff00ff00	// masking for 16 bit right rotation by 8
	and r7, r8, #0x00ff00ff	// complement masking
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r4, r6, r7			// r4: s0|s3 b2^b3 b3^b0 b0^b1 b1^b2
	and r6, r4, #0xcccccccc
	and r7, r4, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r4, r6, r7
	eor r0, r0, r4			// r0: s0|s3 1*next-byte+1*next-next-byte+1*next-next-next-byte
	lsr r10, r8, #16		// r10: 0|s0^s0>>12 after SR
	eor r0, r0, r10			// because we need to add the irreducible poly to s3
	and r6, r3, #0xf000f000
	and r7, r3, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r1, r6, r7			// r1: s1|s2 b1b2b3b0
	and r6, r1, #0xeeeeeeee
	and r7, r1, #0x11111111
	lsr r6, r6, #1
	lsl r7, r7, #3
	add r1, r6, r7			// r1: s1|s2 b1b2b3b0 after SR
	eor r4, r3, r1			// r4: s1|s2 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	mov r11, #0xffff
	and r8, r8, r11			// r8: 0|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r5, r4, #16			// r5: s2|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r8, r8, r5			// r8: s2|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r1, r1, r8			// r1: s1|s2 2*curr-byte+3*next-byte
	and r6, r4, #0xff00ff00
	and r7, r4, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r8, r6, r7			// r8: s1|s2 b2^b3 b3^b0 b0^b1 b1^b2
	and r6, r8, #0xcccccccc
	and r7, r8, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r8, r6, r7
	eor r1, r1, r8			// r1: s1|s2  2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	and r6, r2, #0xf000f000
	and r7, r2, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r3, r6, r7			// r3: s7|s6 b1b2b3b0
	and r6, r3, #0xeeeeeeee
	and r7, r3, #0x11111111
	lsr r6, r6, #1
	lsl r7, r7, #3
	add r3, r6, r7			// r3: s7|s6 b1b2b3b0 after SR
	eor r8, r3, r2			// r8: s7|s6 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r6, r9, #0xf000f000
	and r7, r9, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r2, r6, r7			// r2: s5|s4 b1b2b3b0
	and r6, r2, #0xeeeeeeee
	and r7, r2, #0x11111111
	lsr r6, r6, #1
	lsl r7, r7, #3
	add r2, r6, r7			// r2: s5|s4 b1b2b3b0 after SR
	eor r9, r2, r9			// r9: s5|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r4, r4, r12			// r4: s1|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r5, r9, r11			// r5: 0|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r4, r4, r5			// r4: s1|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r0, r0, r4			// r0: s0|s3 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	and r6, r9, #0xff00ff00
	and r7, r9, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r4, r6, r7			// r4: s5|s4 b2^b3 b3^b0 b0^b1 b1^b2
	and r6, r4, #0xcccccccc
	and r7, r4, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r4, r6, r7
	eor r2, r2, r4			// r2: s5|s4 1*next-byte+1*n-n-b+1*n-n-n-b
	eor r2, r2, r10			// r2: s5|s4 s4 with the added irreducible poly
	lsr r9, r9, #16			// r9: 0|s5 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r4, r8, #16			// r4: s6|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r9, r9, r4			// r9: s6|s5 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r2, r2, r9			// r2: s5|s4 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	eor r3, r3, r10			// r3: s7|s6 s6 xored with the irreducible poly
	and r6, r8, #0xff00ff00
	and r7, r8, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r5, r6, r7			// r5: s7|s6 b2^b3 b3^b0 b0^b1 b1^b2
	and r6, r5, #0xcccccccc
	and r7, r5, #0x33333333
	lsr r6, r6, #2
	lsl r7, r7, #2
	add r5, r6, r7
	eor r3, r3, r5			// r3: s7|s6 1*next-byte+1*n-n-b+1*n-n-n-b
	lsr r8, r8, #16			// r8: 0|s7 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r10, r10, #16		// r10: s0|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r8, r8, r10			// r8: s0|s7 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r3, r3, r8			// r3: s7|s6 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b

	b key_expansion

mix_columns_3:
/* input:
** r1:(s0|s3) r2:(s7|s6) r3:(s1|s2) r9:(s5|s4) r12:(1|0)
** output:
** r0:(s0|s3) r1:(s1|s2) r2:(s5|s4) r3:(s7|s6)
*/
	and r6, r1, #0xf000f000	// masking for 16 left rotation by 4
	and r7, r1, #0x0fff0fff	// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r0, r6, r7			// r0: s0|s3 b1b2b3b0
	eor r8, r1, r0			// r8: s0|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r6, r8, #0xff00ff00	// masking for 16 bit right rotation by 8
	and r7, r8, #0x00ff00ff	// complement masking
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r4, r6, r7			// r4: s0|s3 b2^b3 b3^b0 b0^b1 b1^b2
	eor r0, r0, r4			// r0: s0|s3 1*next-byte+1*next-next-byte+1*next-next-next-byte
	lsr r10, r8, #16		// r10: 0|s0^s0>>12
	eor r0, r0, r10			// because we need to add the irreducible poly to s3
	and r6, r3, #0xf000f000
	and r7, r3, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r1, r6, r7			// r1: s1|s2 b1b2b3b0
	eor r4, r3, r1			// r4: s1|s2 b0^b1 b1^b2 b2^b3 b3^b0
	mov r11, #0xffff
	and r8, r8, r11			// r8: 0|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r5, r4, #16			// r5: s2|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r8, r8, r5			// r8: s2|s3 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r1, r1, r8			// r1: s1|s2 2*curr-byte+3*next-byte
	and r6, r4, #0xff00ff00
	and r7, r4, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r8, r6, r7			// r8: s1|s2 b2^b3 b3^b0 b0^b1 b1^b2
	eor r1, r1, r8			// r1: s1|s2  2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	and r6, r2, #0xf000f000
	and r7, r2, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r3, r6, r7			// r3: s7|s6 b1b2b3b0
	eor r8, r3, r2			// r8: s7|s6 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r6, r9, #0xf000f000
	and r7, r9, #0x0fff0fff
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r2, r6, r7			// r2: s5|s4 b1b2b3b0
	eor r9, r2, r9			// r9: s5|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r4, r4, r12			// r4: s1|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	and r5, r9, r11			// r5: 0|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r4, r4, r5			// r4: s1|s4 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r0, r0, r4			// r0: s0|s3 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	and r6, r9, #0xff00ff00
	and r7, r9, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r4, r6, r7			// r4: s5|s4 b2^b3 b3^b0 b0^b1 b1^b2
	eor r2, r2, r4			// r2: s5|s4 1*next-byte+1*n-n-b+1*n-n-n-b
	eor r2, r2, r10			// r2: s5|s4 s4 with the added irreducible poly
	lsr r9, r9, #16			// r9: 0|s5 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r4, r8, #16			// r4: s6|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r9, r9, r4			// r9: s6|s5 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r2, r2, r9			// r2: s5|s4 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b
	eor r3, r3, r10			// r3: s7|s6 s6 xored with the irreducible poly
	and r6, r8, #0xff00ff00
	and r7, r8, #0x00ff00ff
	lsr r6, r6, #8
	lsl r7, r7, #8
	add r5, r6, r7			// r5: s7|s6 b2^b3 b3^b0 b0^b1 b1^b2
	eor r3, r3, r5			// r3: s7|s6 1*next-byte+1*n-n-b+1*n-n-n-b
	lsr r8, r8, #16			// r8: 0|s7 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	lsl r10, r10, #16		// r10: s0|0 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	add r8, r8, r10			// r8: s0|s7 b0^b1 b1^b2 b2^b3 b3^b0 after SR
	eor r3, r3, r8			// r3: s7|s6 2*curr-byte+3*next-byte+1*n-n-b+1*n-n-n-b

	b key_expansion

rol_col:
// input and output: r8: (x0|x1) r9: (x2|x7) r10: (x3|x5) r11: (x4|x6)
	mov r12, #0x0111
	movt r12, #0x0111
	and r6, r8, #0x10001000	// masking for 16 bit right rotation by 12
	and r7, r8, r12			// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r8, r6, r7			// rotating only the last column left by one byte

	and r6, r9, #0x10001000	// masking for 16 bit right rotation by 12
	and r7, r9, r12			// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r9, r6, r7			// rotating only the last column left by one byte

	and r6, r10, #0x10001000	// masking for 16 bit right rotation by 12
	and r7, r10, r12			// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r10, r6, r7			// rotating only the last column left by one byte

	and r6, r11, #0x10001000	// masking for 16 bit right rotation by 12
	and r7, r11, r12			// complement masking
	lsr r6, r6, #12
	lsl r7, r7, #4
	add r11, r6, r7			// rotating only the last column left by one byte

	bx lr

shift_key_0:
/* input and output: r0-r3
*/
	and r5, r0, #0x0e000e00	// masking for shifting the second row
	and r6, r0, #0x01000100	// complement masking
	lsr r5, r5, #1
	lsl r6, r6, #3
	add r7, r5, r6
	and r5, r0, #0x00c000c0	//masking for shifting the third row
	and r6, r0, #0x00300030	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r4, r5, r6
	and r5, r0, #0x00080008	// masking for shifting the fourth row
	and r6, r0, #0x00070007	// complement masking
	lsr r5, r5, #3
	lsl r6, r6, #1
	add r5, r5, r6
	and r0, r0, #0xf000f000	// leaving the first row as it is
	add r0, r0, r5
	add r0, r0, r7
	add r0, r0, r4

	and r5, r1, #0x0e000e00	// masking for shifting the second row
	and r6, r1, #0x01000100	// complement masking
	lsr r5, r5, #1
	lsl r6, r6, #3
	add r7, r5, r6
	and r5, r1, #0x00c000c0	//masking for shifting the third row
	and r6, r1, #0x00300030	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r4, r5, r6
	and r5, r1, #0x00080008	// masking for shifting the fourth row
	and r6, r1, #0x00070007	// complement masking
	lsr r5, r5, #3
	lsl r6, r6, #1
	add r5, r5, r6
	and r1, r1, #0xf000f000	// leaving the first row as it is
	add r1, r1, r5
	add r1, r1, r7
	add r1, r1, r4

	and r5, r2, #0x0e000e00	// masking for shifting the second row
	and r6, r2, #0x01000100	// complement masking
	lsr r5, r5, #1
	lsl r6, r6, #3
	add r7, r5, r6
	and r5, r2, #0x00c000c0	//masking for shifting the third row
	and r6, r2, #0x00300030	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r4, r5, r6
	and r5, r2, #0x00080008	// masking for shifting the fourth row
	and r6, r2, #0x00070007	// complement masking
	lsr r5, r5, #3
	lsl r6, r6, #1
	add r5, r5, r6
	and r2, r2, #0xf000f000	// leaving the first row as it is
	add r2, r2, r5
	add r2, r2, r7
	add r2, r2, r4

	and r5, r3, #0x0e000e00	// masking for shifting the second row
	and r6, r3, #0x01000100	// complement masking
	lsr r5, r5, #1
	lsl r6, r6, #3
	add r7, r5, r6
	and r5, r3, #0x00c000c0	//masking for shifting the third row
	and r6, r3, #0x00300030	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r4, r5, r6
	and r5, r3, #0x00080008	// masking for shifting the fourth row
	and r6, r3, #0x00070007	// complement masking
	lsr r5, r5, #3
	lsl r6, r6, #1
	add r5, r5, r6
	and r3, r3, #0xf000f000	// leaving the first row as it is
	add r3, r3, r5
	add r3, r3, r7
	add r3, r3, r4

	b new_state

shift_key_1:
/* input and output: r0-r3
*/
	and r5, r0, #0x0c000c00	// masking for shifting the second row
	and r6, r0, #0x03000300	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r7, r5, r6
	and r4, r0, #0x00f000f0	// leaving the third row as it is
	and r5, r0, #0x000c000c	// masking for shifting the fourth row
	and r6, r0, #0x00030003	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r5, r5, r6
	and r0, r0, #0xf000f000	// leaving the first row as it is
	add r0, r0, r5
	add r0, r0, r7
	add r0, r0, r4

	and r5, r1, #0x0c000c00	// masking for shifting the second row
	and r6, r1, #0x03000300	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r7, r5, r6
	and r4, r1, #0x00f000f0	// leaving the third row as it is
	and r5, r1, #0x000c000c	// masking for shifting the fourth row
	and r6, r1, #0x00030003	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r5, r5, r6
	and r1, r1, #0xf000f000	// leaving the first row as it is
	add r1, r1, r5
	add r1, r1, r7
	add r1, r1, r4

	and r5, r2, #0x0c000c00	// masking for shifting the second row
	and r6, r2, #0x03000300	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r7, r5, r6
	and r4, r2, #0x00f000f0	// leaving the third row as it is
	and r5, r2, #0x000c000c	// masking for shifting the fourth row
	and r6, r2, #0x00030003	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r5, r5, r6
	and r2, r2, #0xf000f000	// leaving the first row as it is
	add r2, r2, r5
	add r2, r2, r7
	add r2, r2, r4

	and r5, r3, #0x0c000c00	// masking for shifting the second row
	and r6, r3, #0x03000300	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r7, r5, r6
	and r4, r3, #0x00f000f0	// leaving the third row as it is
	and r5, r3, #0x000c000c	// masking for shifting the fourth row
	and r6, r3, #0x00030003	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r5, r5, r6
	and r3, r3, #0xf000f000	// leaving the first row as it is
	add r3, r3, r5
	add r3, r3, r7
	add r3, r3, r4

	b new_state

shift_key_2:
/* input and output: r0-r3
*/
	and r5, r0, #0x08000800	// masking for shifting the second row
	and r6, r0, #0x07000700	// complement masking
	lsr r5, r5, #3
	lsl r6, r6, #1
	add r7, r5, r6
	and r5, r0, #0x00c000c0	//masking for shifting the third row
	and r6, r0, #0x00300030	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r4, r5, r6
	and r5, r0, #0x000e000e	// masking for shifting the fourth row
	and r6, r0, #0x00010001	// complement masking
	lsr r5, r5, #1
	lsl r6, r6, #3
	add r5, r5, r6
	and r0, r0, #0xf000f000	// leaving the first row as it is
	add r0, r0, r5
	add r0, r0, r7
	add r0, r0, r4

	and r5, r1, #0x08000800	// masking for shifting the second row
	and r6, r1, #0x07000700	// complement masking
	lsr r5, r5, #3
	lsl r6, r6, #1
	add r7, r5, r6
	and r5, r1, #0x00c000c0	//masking for shifting the third row
	and r6, r1, #0x00300030	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r4, r5, r6
	and r5, r1, #0x000e000e	// masking for shifting the fourth row
	and r6, r1, #0x00010001	// complement masking
	lsr r5, r5, #1
	lsl r6, r6, #3
	add r5, r5, r6
	and r1, r1, #0xf000f000	// leaving the first row as it is
	add r1, r1, r5
	add r1, r1, r7
	add r1, r1, r4

	and r5, r2, #0x08000800	// masking for shifting the second row
	and r6, r2, #0x07000700	// complement masking
	lsr r5, r5, #3
	lsl r6, r6, #1
	add r7, r5, r6
	and r5, r2, #0x00c000c0	//masking for shifting the third row
	and r6, r2, #0x00300030	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r4, r5, r6
	and r5, r2, #0x000e000e	// masking for shifting the fourth row
	and r6, r2, #0x00010001	// complement masking
	lsr r5, r5, #1
	lsl r6, r6, #3
	add r5, r5, r6
	and r2, r2, #0xf000f000	// leaving the first row as it is
	add r2, r2, r5
	add r2, r2, r7
	add r2, r2, r4

	and r5, r3, #0x08000800	// masking for shifting the second row
	and r6, r3, #0x07000700	// complement masking
	lsr r5, r5, #3
	lsl r6, r6, #1
	add r7, r5, r6
	and r5, r3, #0x00c000c0	//masking for shifting the third row
	and r6, r3, #0x00300030	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r4, r5, r6
	and r5, r3, #0x000e000e	// masking for shifting the fourth row
	and r6, r3, #0x00010001	// complement masking
	lsr r5, r5, #1
	lsl r6, r6, #3
	add r5, r5, r6
	and r3, r3, #0xf000f000	// leaving the first row as it is
	add r3, r3, r5
	add r3, r3, r7
	add r3, r3, r4

	b new_state

fix_encrypt:
.fnstart
/* #1 STATE: 0x77da 06d7 0a2d dc66 3d13 9c07 bf21 82c1 KEY: 0xb1f0 1aa3 b4c3 9dab f376 1bc4 f504 efa4
** #2 STATE: 0x9689 8260 e02c a561 d19c 91e2 5eff 2327 KEY: 0x3e0b 668f 2d00 09bb f1ff b3e7 3fd9 2be2
** #3 STATE: 0x46fb 4e78 a583 e1aa c1a0 1713 a64d a99f KEY: 0xb625 af9d a725 291f a4eb 6ba9 c5e0 d182
** #4 STATE: 0x5e2e fd05 ca57 59b5 1387 a779 8621 5c69 KEY: 0xa08f 2241 c3db 3b5e 4f2f c92a 5c7d 6a7c
** #5 STATE: 0xf8ca 3263 73d6 6746 2629 63e3 da02 c0ad KEY: 0x9d3e 11cf 2e00 fb5f 1299 1449 2ce9 0daa
** #6 STATE: 0x92df 0798 bad4 12ec d202 eac3 1043 84d5 KEY: 0xf551 13b2 fd91 0025 1759 8995 4531 1759
** #7 STATE: 0xc94e 6ef9 fd03 4602 9427 ed69 01fd 74d0 KEY: 0x7c93 7a3b 929a bd17 3ecd 9f21 63f1 418a
** #8 STATE: 0xb241 d4f9 c519 4d3a 5f76 2cc7 7225 f3f3 KEY: 0x3c86 5b30 afcb a5ba 5122 9204 e09f 2bd1
** #9 STATE: 0x1605 2e3d b02f 0a76 c721 eedd e34f b39b KEY: 0x1859 2d8d 5735 b83c ae2c 33e6 fdf8 8d15
** #a STATE: 0x6614 5b60 3bb1 9de0 af23 ee56 f04a 3e72 KEY: 0xe7a9 c54c c3da 1fa4 9c1e 0cf0 493d 1d63
*/
	// initial message:
	mov r0, #0x5b60		// 2nd byte
	movt r0, #0x6614	// 1st byte
	mov r1, #0x9de0		// 4th byte
	movt r1, #0x3bb1	// 3rd byte
	mov r2, #0xee56		// 6th byte
	movt r2, #0xaf23	// 5th byte
	mov r3, #0x3e72		// 8th byte
	movt r3, #0xf04a	// 7th byte
	// initial key:
	mov r4, #0xc54c		// 2nd byte
	movt r4, #0xe7a9	// 1st byte
	mov r5, #0x1fa4		// 4th byte
	movt r5, #0xc3da	// 3rd byte
	mov r6, #0x0cf0		// 6th byte
	movt r6, #0x9c1e	// 5th byte
	mov r7, #0x1d63		// 8th byte
	movt r7, #0x493d	// 7th byte
	// initial state:
	eor r0, r0, r4
	eor r1, r1, r5
	eor r2, r2, r6
	eor r3, r3, r7

	push {lr}	// to return back to c-code

	push {r0, r1, r2, r3}	// storing initial state
	mov r0, r4				// moving key to fixslicing's input registers
	mov r1, r5
	mov r2, r6
	mov r3, r7

	bl fixslicing	// fixslicing key bits. input r0-r3 output r8-r11
	// r8: (x0|x1) r9: (x2|x7) r10: (x3|x5) r11: (x4|x6)
	pop {r0, r1, r2, r3}	// initial state
	mov r5, #0x01			// initial round-constant value- 0x01 in a fixsliced manner
	push {r5}				// storing fixsliced round-constant
	push {r8, r9, r10, r11}	// storing fixsliced key
	mov r5, #10				// aes round counter
	push {r5}				// storing counter

	bl fixslicing	// fixslicing state bits

	loop:	// registers r8-r11 holding state
// --------- S-BOX --------------------------------
		bl parallel_sbox	// substituting state
// --------- MIX COLUMNS --------------------------
/* sbox output:
** r1:(s0|s3) r2:(s7|s6) r3:(s1|s2) r9:(s5|s4) r12:(1|0)
** mix columns output:
** r0:(s0|s3) r1:(s1|s2) r2:(s5|s4) r3:(s7|s6)
*/
		pop {r5}	// counter
		sub r5, r5, #1
		push {r5}
		cbz r5, no_mix_columns	// if it is the last round then no need for mix columns
		cmp r5, #8
		beq mix_columns_1
		cmp r5, #4
		beq mix_columns_1
		cmp r5, #7
		beq mix_columns_2
		cmp r5, #3
		beq mix_columns_2
		cmp r5, #6
		beq mix_columns_3
		cmp r5, #2
		beq mix_columns_3
		b mix_columns_0		// at any other case

		no_mix_columns:
		mov r0, r1
		mov r1, r3
		mov r3, r2
		mov r2, r9
		// after mix columns state is in r0-r3
// ------------------- KEY EXPANSION --------------------------------
		key_expansion:
		mov r11, #0xffff	// re-aranging the state bits
		and r10, r0, r12		// r10: (s0|0)
		lsr r8, r1, #16			// r8: (0|s1)
		lsl r4, r0, #16			// r4: (s3|0)
		add r0, r10, r8			// r0: (s0|s1)
		lsl r1, r1, #16			// r1: (s2|0)
		lsr r10, r3, #16		// r10: (0|s7)
		add r1, r1, r10			// r1: (s2|s7)
		lsr r10, r2, #16		// r10: (0|s5)
		lsl r8, r2, #16			// r8: (s4|0)
		and r9, r3, r11			// r9: (0|s6)
		add r3, r8, r9			// r3: (s4|s6)
		add r2, r4, r10			// r2: (s3|s5)
		// r0: (s0|s1) r1: (s2|s7) r2: (s3|s5) r3: (s4|s6)
		pop {r5}				// counter
		pop {r8, r9, r10, r11}	// fixsliced previous key
		pop {r4}				// round constant
		push {r5}
		push {r0, r1, r2, r3}
		push {r8, r9, r10, r11}
		push {r4}
		// stack bottom -> counter | state | key | round-constant -> stack top
		bl rol_col			// rotating only the last column of the key one byte to the left
		bl parallel_sbox	// subtituting the entire key though we only need the last column
		// sbox output: r1:(s0|s3) r3:(s1|s2) r9:(s5|s4) r2: (s7|s6)
		pop {r4}		// round constant r4: (x0|x1|x2|x3|x4|x5|x6|x7)
		// previous key- r4: (x0|x1) r5: (x2|x7) r6: (x3|x5) r7: (x4|x6)
		and r1, r1, #0x11111111	// leaving only the bits of the last column
		and r2, r2, #0x11111111
		and r3, r3, #0x11111111
		and r9, r9, #0x11111111
		mov r11, #0xffff	// re-aranging the last column's bits
		and r10, r1, r12		// r10: (s0|0)
		lsr r8, r3, #16			// r8: (0|s1)
		add r0, r10, r8			// r0: (s0|s1)
		lsl r8, r1, #16			// r8: (s3|0)
		lsl r1, r3, #16			// r1: (s2|0)
		lsr r10, r9, #16		// r10: (0|s5)
		lsl r3, r9, #16			// r3: (s4|0)
		and r9, r2, r11			// r9: (0|s6)
		add r3, r3, r9			// r3: (s4|s6)
		lsr r9, r2, #16			// r9: (0|s7)
		add r1, r1, r9			// r1: (s2|s7)
		add r2, r8, r10			// r2: (s3|s5)
		// xoring the sboxed column with the round constant:
		and r5, r4, #0x10000000	// round constant's x0
		and r6, r4, #0x01000000	// round constant's x1
		lsr r6, r6, #12
		add r5, r5, r6			// r5: x0|x1
		eor r0, r0, r5			// r0: s0|s1 new column
		and r5, r4, #0x1		// round constant's x7
		lsl r5, r5, #12
		and r6, r4, #0x100000	// round constant's x2
		lsl r6, r6, #8
		add r5, r5, r6			// r5: x2|x7
		eor r1, r1, r5			// r1: s2|s7 new column
		and r5, r4, #0x00010000	// round constant's x3
		lsl r5, r5, #12
		and r6, r4, #0x00000100	// round constant's x5
		lsl r6, r6, #4
		add r5, r5, r6			// r5: x3|x5
		eor r2, r2, r5			// r2: s3|s5 new column
		and r5, r4, #0x1000		// round constant's x4
		lsl r5, r5, #16
		and r6, r4, #0x0010		// round constant's x6
		lsl r6, r6, #8
		add r5, r5, r6			// r5: x4|x6
		eor r3, r3, r5			// r3: s4|s6 new column
		// next round constant calculation:
		and r5, r4, #0x10000000	// r5: x0
		lsl r4, r4, #4			// multiplication by 2
		lsr r5, r5, #12			// to xor x0 with x3
		eor r4, r4, r5
		lsr r5, r5, #4			// to xor x0 with x4
		eor r4, r4, r5
		lsr r5, r5, #8			// to xor x0 with x6
		eor r4, r4, r5
		lsr r5, r5, #4			// to xor x0 with x7
		eor r4, r4, r5

		pop {r5, r6, r7, r8}	// previous key
		lsl r0, r0, #3			// to xor the first key column with the last result column
		lsl r1, r1, #3
		lsl r2, r2, #3
		lsl r3, r3, #3
		eor r0, r0, r5			// xoring the first key column
		eor r1, r1, r6
		eor r2, r2, r7
		eor r3, r3, r8			// now r0-r3 has the new first column and the rest of the previous columns
		and r5, r0, #0x88888888	// to xor the last rsult column with the next column
		and r6, r1, #0x88888888
		and r7, r2, #0x88888888
		and r8, r3, #0x88888888
		lsr r5, r5, #1
		lsr r6, r6, #1
		lsr r7, r7, #1
		lsr r8, r8, #1
		eor r0, r0, r5			// xoring the second column
		eor r1, r1, r6
		eor r2, r2, r7
		eor r3, r3, r8
		and r5, r0, #0x44444444	// to xor the last rsult column with the next column
		and r6, r1, #0x44444444
		and r7, r2, #0x44444444
		and r8, r3, #0x44444444
		lsr r5, r5, #1
		lsr r6, r6, #1
		lsr r7, r7, #1
		lsr r8, r8, #1
		eor r0, r0, r5			// xoring the third column
		eor r1, r1, r6
		eor r2, r2, r7
		eor r3, r3, r8
		and r5, r0, #0x22222222	// to xor the last rsult column with the next column
		and r6, r1, #0x22222222
		and r7, r2, #0x22222222
		and r8, r3, #0x22222222
		lsr r5, r5, #1
		lsr r6, r6, #1
		lsr r7, r7, #1
		lsr r8, r8, #1
		eor r0, r0, r5			// xoring the fourth column
		eor r1, r1, r6
		eor r2, r2, r7
		eor r3, r3, r8
		// now r0-r3 hold the new key
		// we only need to place the bits at the right places cause of the omittion of the shift rows:
		pop {r8, r9, r10, r11}	// state
		pop {r5}				// counter

		push {r4}
		push {r0, r1, r2, r3}
		push {r5}
		// stack bottom -> round constant | key | counter -> stack top
		cbnz r5, shifting_key
		b shift_key_1

		shifting_key:
		cmp r5, #6
		beq new_state
		cmp r5, #2
		beq new_state
		cmp r5, #8
		beq shift_key_1
		cmp r5, #4
		beq shift_key_1
		cmp r5, #7
		beq shift_key_2
		cmp r5, #3
		beq shift_key_2
		b shift_key_0		// at any other case

		// calculating new state for the next round:
		new_state:
		eor r8, r8, r0
		eor r9, r9, r1
		eor r10, r10, r2
		eor r11, r11, r3
		pop {r5}				// counter
		cbz r5, end		// if the counter reaches zero then it is the last round
		push {r5}
		b loop

end:
/* input: r8-r11 fixsliced state
** r8: (x0|x1) r9: (x2|x7) r10: (x3|x5) r11: (x4|x6)
** this code will unpack the fixsliced state bits into traditional order and the output will be the final encrypted message
** the unpacking considers the 2 shift rows operations that were omitted
*/
	pop {r2, r3, r4, r5, r6}	// discarding the unused stack
	// doing 2 shift rows operations:
	and r5, r8, #0x0c0c0c0c	// masking to shift the second and fourth rows
	and r6, r8, #0x03030303	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r5, r5, r6
	and r8, r8, #0xf0f0f0f0	// leaving the rest of the rows as they are
	add r8, r8, r5			// r8: (x0|x1) after 2 shift rows

	and r5, r9, #0x0c0c0c0c	// masking to shift the second and fourth rows
	and r6, r9, #0x03030303	// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r5, r5, r6
	and r9, r9, #0xf0f0f0f0	// leaving the rest of the rows as they are
	add r9, r9, r5			// r8: (x2|x7) after 2 shift rows

	and r5, r10, #0x0c0c0c0c// masking to shift the second and fourth rows
	and r6, r10, #0x03030303// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r5, r5, r6
	and r10, r10, #0xf0f0f0f0// leaving the rest of the rows as they are
	add r10, r10, r5		// r10: (x3|x5) after 2 shift rows

	and r5, r11, #0x0c0c0c0c// masking to shift the second and fourth rows
	and r6, r11, #0x03030303// complement masking
	lsr r5, r5, #2
	lsl r6, r6, #2
	add r5, r5, r6
	and r11, r11, #0xf0f0f0f0// leaving the rest of the rows as they are
	add r11, r11, r5		// r11: (x4|x6) after 2 shift rows

// The unpacking:
	mov r12, #0
	movt r12, #0xf000
	and r4, r8, r12			// s0 s32 s64 s96
	and r5, r8, #0x0f000000	// s72 s104 s8 s40
	lsr r5, r5, #4			// to bit 8
	add r4, r4, r5
	and r5, r8, #0x00f00000	// s16 s48 s80 s112
	lsr r5, r5, #8			// to bit 16
	add r4, r4, r5
	and r5, r8, #0x000f0000	// s88 s120 s24 s56
	lsr r5, r5, #12			// to bit 24
	add r0, r4, r5			// r0: 0xf0f0f0f0
	lsl r1, r0, #1			// moving to other columns
	lsl r2, r0, #2
	lsl r3, r0, #3
	and r0, r0, #0x80808080	// cleaning unwanted bits
	and r1, r1, #0x80808080
	and r2, r2, #0x80808080
	and r3, r3, #0x80808080

	lsl r8, r8, #16			// r8: (x1|0)
	and r4, r8, r12			// s1 s33 s65 s97
	and r5, r8, #0x0f000000	// s73 s105 s9 s41
	lsr r5, r5, #4			// to bit 8
	add r4, r4, r5
	and r5, r8, #0x00f00000	// s17 s49 s81 s113
	lsr r5, r5, #8			// to bit 16
	add r4, r4, r5
	and r5, r8, #0x000f0000	// s89 s121 s25 s57
	lsr r5, r5, #12			// to bit 24
	add r5, r4, r5			// r5: 0xf0f0f0f0
	lsr r4, r5, #1			// moving to other columns
	lsl r6, r4, #2
	lsl r7, r4, #3
	and r4, r4, #0x40404040	// cleaning unwanted bits
	and r5, r5, #0x40404040
	and r6, r6, #0x40404040
	and r7, r7, #0x40404040
	add r0, r0, r4			// 0xc0c0c0c0:
	add r1, r1, r5
	add r2, r2, r6
	add r3, r3, r7

	and r4, r9, r12			// s2 s34 s66 s98
	and r5, r9, #0x0f000000	// s74 s106 s10 s42
	lsr r5, r5, #4			// to bit 8
	add r4, r4, r5
	and r5, r9, #0x00f00000	// s18 s50 s82 s114
	lsr r5, r5, #8			// to bit 16
	add r4, r4, r5
	and r5, r9, #0x000f0000	// s90 s122 s26 s58
	lsr r5, r5, #12			// to bit 24
	add r6, r4, r5			// r6: 0xf0f0f0f0
	lsr r4, r6, #2
	lsl r5, r4, #1			// moving to other columns
	lsl r7, r4, #3
	and r4, r4, #0x20202020	// cleaning unwanted bits
	and r5, r5, #0x20202020
	and r6, r6, #0x20202020
	and r7, r7, #0x20202020
	add r0, r0, r4			// 0xe0e0e0e0:
	add r1, r1, r5
	add r2, r2, r6
	add r3, r3, r7

	and r4, r10, r12		// s3 s35 s67 s99
	and r5, r10, #0x0f000000// s75 s107 s11 s43
	lsr r5, r5, #4			// to bit 8
	add r4, r4, r5
	and r5, r10, #0x00f00000// s19 s51 s83 s115
	lsr r5, r5, #8			// to bit 16
	add r4, r4, r5
	and r5, r10, #0x000f0000// s91 s123 s27 s59
	lsr r5, r5, #12			// to bit 24
	add r7, r4, r5			// r7: 0xf0f0f0f0
	lsr r4, r7, #3
	lsl r5, r4, #1			// moving to other columns
	lsl r6, r4, #2
	and r4, r4, #0x10101010	// cleaning unwanted bits
	and r5, r5, #0x10101010
	and r6, r6, #0x10101010
	and r7, r7, #0x10101010
	add r0, r0, r4			// 0xf0f0f0f0:
	add r1, r1, r5
	add r2, r2, r6
	add r3, r3, r7

	and r4, r11, r12		// s4 s36 s68 s100
	and r5, r11, #0x0f000000// s76 s108 s12 s44
	lsr r5, r5, #4			// to bit 8
	add r4, r4, r5
	and r5, r11, #0x00f00000// s20 s52 s84 s116
	lsr r5, r5, #8			// to bit 16
	add r4, r4, r5
	and r5, r11, #0x000f0000// s92 s124 s28 s60
	lsr r5, r5, #12			// to bit 24
	add r4, r4, r5			// r4: 0xf0f0f0f0
	lsr r4, r4, #4			// r4: 0x0f0f0f0f
	lsl r5, r4, #1			// moving to other columns
	lsl r6, r4, #2
	lsl r7, r4, #3
	and r4, r4, #0x08080808	// cleaning unwanted bits
	and r5, r5, #0x08080808
	and r6, r6, #0x08080808
	and r7, r7, #0x08080808
	add r0, r0, r4			// 0xf8f8f8f8:
	add r1, r1, r5
	add r2, r2, r6
	add r3, r3, r7

	lsl r10, r10, #16		// r10: (x5|0)
	and r4, r10, r12		// s5 s37 s69 s101
	and r5, r10, #0x0f000000// s77 s109 s13 s45
	lsr r5, r5, #4			// to bit 8
	add r4, r4, r5
	and r5, r10, #0x00f00000// s21 s53 s85 s117
	lsr r5, r5, #8			// to bit 16
	add r4, r4, r5
	and r5, r10, #0x000f0000// s93 s125 s29 s61
	lsr r5, r5, #12			// to bit 24
	add r4, r4, r5			// r4: 0xf0f0f0f0
	lsr r7, r4, #2			// moving to other columns
	lsr r6, r4, #3
	lsr r5, r4, #4
	lsr r4, r4, #5			// r4: 0x07878787
	and r4, r4, #0x04040404	// cleaning unwanted bits
	and r5, r5, #0x04040404
	and r6, r6, #0x04040404
	and r7, r7, #0x04040404
	add r0, r0, r4			// 0xfcfcfcfc:
	add r1, r1, r5
	add r2, r2, r6
	add r3, r3, r7

	lsl r11, r11, #16		// r11: (x6|0)
	and r4, r11, r12		// s6 s38 s70 s102
	and r5, r11, #0x0f000000// s78 s110 s14 s46
	lsr r5, r5, #4			// to bit 8
	add r4, r4, r5
	and r5, r11, #0x00f00000// s22 s54 s86 s118
	lsr r5, r5, #8			// to bit 16
	add r4, r4, r5
	and r5, r11, #0x000f0000// s94 s126 s30 s62
	lsr r5, r5, #12			// to bit 24
	add r4, r4, r5			// r4: 0xf0f0f0f0
	lsr r7, r4, #3			// moving to other columns
	lsr r6, r4, #4
	lsr r5, r4, #5
	lsr r4, r4, #6			// r4: 0x03c3c3c3
	and r4, r4, #0x02020202	// cleaning unwanted bits
	and r5, r5, #0x02020202
	and r6, r6, #0x02020202
	and r7, r7, #0x02020202
	add r0, r0, r4			// 0xfefefefe:
	add r1, r1, r5
	add r2, r2, r6
	add r3, r3, r7

	lsl r9, r9, #16			// r9: (x7|0)
	and r4, r9, r12			// s7 s39 s71 s103
	and r5, r9, #0x0f000000	// s79 s111 s15 s47
	lsr r5, r5, #4			// to bit 8
	add r4, r4, r5
	and r5, r9, #0x00f00000	// s23 s55 s87 s119
	lsr r5, r5, #8			// to bit 16
	add r4, r4, r5
	and r5, r9, #0x000f0000	// s95 s127 s31 s63
	lsr r5, r5, #12			// to bit 24
	add r4, r4, r5			// r4: 0xf0f0f0f0
	lsr r7, r4, #4			// moving to other columns
	lsr r6, r4, #5
	lsr r5, r4, #6
	lsr r4, r4, #7			// r4: 0x01e1e1e1
	and r4, r4, #0x01010101	// cleaning unwanted bits
	and r5, r5, #0x01010101
	and r6, r6, #0x01010101
	and r7, r7, #0x01010101
	add r0, r0, r4			// 0xffffffff:
	add r1, r1, r5
	add r2, r2, r6
	add r3, r3, r7

pop {lr}
bx lr
.fnend
