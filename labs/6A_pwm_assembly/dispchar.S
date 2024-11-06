.syntax unified
.thumb

.include "regmap.S"



.section .text
.align 2

.global dispchar
.thumb_func
dispchar:   @ displays a character on 7-segment display

    push    {r0, r1, r2, lr}

    @ r0 = r0 % 16
    ldr     r0, [sp, #16]
    mov     r2, #0x10
    udiv    r1, r0, r2
    mul     r1, r1, r2
    sub     r0, r0, r1
    
    ldr     r1, =_dispchar_table
    ldrb    r1, [r1, r0]

    ldr     r0, =GPIOB
    ldr     r2, [r0, #IO_OUTPUT]
    bic     r2, r2, 0b11111111
    orr     r2, r2, r1
    str     r2, [r0, #IO_OUTPUT]

    pop     {r0, r1, r2, pc}

    _dispchar_table:
        .byte   0b00111111 @ 0
        .byte   0b00000110 @ 1
        .byte   0b01011011 @ 2
        .byte   0b01001111 @ 3
        .byte   0b01100110 @ 4
        .byte   0b01101101 @ 5
        .byte   0b01111101 @ 6
        .byte   0b00000111 @ 7
        .byte   0b01111111 @ 8
        .byte   0b01101111 @ 9
        .byte   0b01110111 @ A
        .byte   0b01111100 @ B
        .byte   0b00111001 @ C
        .byte   0b01011110 @ D
        .byte   0b01111001 @ E
        .byte   0b01110001 @ F