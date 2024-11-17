	.cpu arm7tdmi
	.arch armv4t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"blinkled.c"
	.text
	.global	peepee
	.data
	.align	2
	.type	peepee, %object
	.size	peepee, 4
peepee:
	.word	256
	.global	pooopoo
	.align	2
	.type	pooopoo, %object
	.size	pooopoo, 4
pooopoo:
	.word	16
	.text
	.align	2
	.global	board_clocking_init
	.syntax unified
	.arm
	.type	board_clocking_init, %function
board_clocking_init:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .L5
	ldr	r3, [r3]
	ldr	r2, .L5
	orr	r3, r3, #65536
	str	r3, [r2]
	nop
.L2:
	ldr	r3, .L5
	ldr	r3, [r3]
	and	r3, r3, #131072
	cmp	r3, #131072
	bne	.L2
	ldr	r3, .L5+4
	ldr	r3, [r3]
	ldr	r2, .L5+4
	orr	r3, r3, #32
	str	r3, [r2]
	ldr	r3, .L5+4
	ldr	r3, [r3]
	ldr	r2, .L5+4
	bic	r3, r3, #16
	str	r3, [r2]
	ldr	r3, .L5+4
	ldr	r3, [r3]
	ldr	r2, .L5+4
	orr	r3, r3, #4194304
	str	r3, [r2]
	ldr	r3, .L5
	ldr	r3, [r3]
	ldr	r2, .L5
	orr	r3, r3, #16777216
	str	r3, [r2]
	nop
.L3:
	ldr	r3, .L5
	ldr	r3, [r3]
	and	r3, r3, #33554432
	cmp	r3, #33554432
	bne	.L3
	ldr	r3, .L5+8
	ldr	r2, .L5+8
	ldr	r3, [r3]
	str	r3, [r2]
	ldr	r3, .L5+8
	ldr	r3, [r3]
	ldr	r2, .L5+8
	orr	r3, r3, #2
	str	r3, [r2]
	nop
.L4:
	ldr	r3, .L5+8
	ldr	r3, [r3]
	and	r3, r3, #12
	cmp	r3, #8
	bne	.L4
	ldr	r3, .L5+8
	ldr	r2, .L5+8
	ldr	r3, [r3]
	str	r3, [r2]
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L6:
	.align	2
.L5:
	.word	1073887232
	.word	1073887236
	.word	1073887240
	.size	board_clocking_init, .-board_clocking_init
	.align	2
	.global	board_gpio_init
	.syntax unified
	.arm
	.type	board_gpio_init, %function
board_gpio_init:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .L8
	ldr	r3, [r3]
	ldr	r2, .L8
	orr	r3, r3, #1
	str	r3, [r2]
	ldr	r3, .L8
	ldr	r3, [r3]
	ldr	r2, .L8
	orr	r3, r3, #4
	str	r3, [r2]
	ldr	r3, .L8+4
	ldr	r3, [r3]
	ldr	r2, .L8+4
	orr	r3, r3, #1024
	str	r3, [r2]
	ldr	r3, .L8+8
	ldr	r2, .L8+8
	ldr	r3, [r3]
	str	r3, [r2]
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L9:
	.align	2
.L8:
	.word	1073887280
	.word	1073872896
	.word	1073874944
	.size	board_gpio_init, .-board_gpio_init
	.align	2
	.global	delay
	.syntax unified
	.arm
	.type	delay, %function
delay:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	str	r0, [fp, #-16]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L11
.L12:
	.syntax divided
@ 54 "blinkled.c" 1
	nop
@ 0 "" 2
	.arm
	.syntax unified
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L11:
	ldr	r2, [fp, #-16]
	mov	r3, r2
	lsl	r3, r3, #4
	sub	r3, r3, r2
	lsl	r3, r3, #7
	mov	r2, r3
	ldr	r3, [fp, #-8]
	cmp	r3, r2
	bcc	.L12
	nop
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	delay, .-delay
	.global	__aeabi_i2f
	.align	2
	.global	frog
	.syntax unified
	.arm
	.type	frog, %function
frog:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	str	r0, [fp, #-8]
	ldr	r0, [fp, #-8]
	bl	__aeabi_i2f
	mov	r3, r0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, lr}
	bx	lr
	.size	frog, .-frog
	.align	2
	.global	main
	.syntax unified
	.arm
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	bl	board_clocking_init
	bl	board_gpio_init
	mov	r3, #0
	strb	r3, [fp, #-5]
	mov	r3, #0
	strb	r3, [fp, #-6]
.L20:
	ldr	r3, .L21
	ldr	r3, [r3]
	and	r3, r3, #8192
	cmp	r3, #0
	movne	r3, #1
	moveq	r3, #0
	strb	r3, [fp, #-7]
	ldrb	r3, [fp, #-7]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L16
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	cmp	r3, #5
	bne	.L17
	mov	r3, #1
	strb	r3, [fp, #-6]
	mov	r3, #0
	strb	r3, [fp, #-5]
	b	.L18
.L17:
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	add	r3, r3, #1
	strb	r3, [fp, #-5]
	b	.L18
.L16:
	ldrb	r3, [fp, #-6]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L19
	ldr	r3, .L21+4
	ldr	r3, [r3]
	ldr	r2, .L21+4
	eor	r3, r3, #32
	str	r3, [r2]
.L19:
	mov	r3, #0
	strb	r3, [fp, #-5]
	mov	r3, #0
	strb	r3, [fp, #-6]
.L18:
	mov	r0, #5
	bl	delay
	b	.L20
.L22:
	.align	2
.L21:
	.word	1073874960
	.word	1073872916
	.size	main, .-main
	.ident	"GCC: (GNU Arm Embedded Toolchain 10.3-2021.10) 10.3.1 20210824 (release)"
