.syntax unified
.thumb

.include "../F401RE.S"
.include "../macros.S"



.section .text

.global pwm_cycle
.thumb_func
pwm_cycle:
    push    {lr}

    mov     r3, r0
    ldr     r0, =pwm_resolution
    ldr     r2, [r0]
    ldr     r0, =pwm_state
    ldr     r1, [r0]
    add     r1, r1, 1
    cmp     r1, r2

    blt     _pwm_cycle_noreset
        eor     r1, r1, r1
    _pwm_cycle_noreset:
    
    str     r1, [r0] @ -> pwm_state
    mov     r2, r3

    cmp     r1, r2
    ldr     r0, =GPIOB
    ldr     r1, [r0]
    blt     _pwm_cycle_less
    @ greater or equal than threshold
        bic     r1, r1, 0b1 << 15
    b       _pwm_cycle_end
    _pwm_cycle_less:
    @ less than threshold
        orr     r1, r1, 0b1 << 15
    _pwm_cycle_end:
    
    str     r1, [r0, #IO_OUTPUT]

    pop     {pc}



.section .data

.global pwm_resolution
pwm_resolution:
    .word   15
    
.global pwm_state
pwm_state:
    .word   0