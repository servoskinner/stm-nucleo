.syntax unified
.thumb

.include "regmap.S"



.section .text
.align 4

.global adc_handler
.thumb_func
adc_handler:   @ displays a character on 7-segment display
    push    {r0, r1, r2, lr}

        ldr     r0, =ADC_DR
        ldrb    r1, [r0]
        ldr     r0, =adc_value
        strb    r1, [r0]

        mov     r2, #16
        udiv    r1, r1, r2

        push    {r1}
        bl      dispchar
        add     sp, sp, #4

    pop     {r0, r1, r2, pc}



.section .data
.align 4

.global adc_value
adc_value:
    .byte 0x00