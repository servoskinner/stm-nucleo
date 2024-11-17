.syntax unified
.thumb

.include "../F401RE.S"
.include "../macros.S"



.section .text
.align 4

.global adc_handler
.thumb_func
adc_handler:   @ Handles ADC conversion result
    push    {lr}

    ldr     r0, =ADC_DR
    ldrb    r1, [r0]
    ldr     r0, =adc_value
    strb    r1, [r0]

    mov     r2, #16
    udiv    r1, r1, r2

    mov     r0, r1
    bl      dispchar

    pop     {pc}



.section .data

.global adc_value
adc_value:
    .byte 0x00