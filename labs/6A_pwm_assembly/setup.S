.syntax unified
.thumb

.include "regmap.S"



.section .text
.align 2

.global setup_clock
.thumb_func  
setup_clock:
    push {r0, r1, r2, lr} 
    @ Enable HSE clock
    ldr     r0, =RCC_CTRL
    ldr     r1, [r0]
    orr     r1, r1, 0x1 << 16
    str     r1, [r0]

    @ Wait for oscillations to set up.
    setup_clock_hse_wait_loop:
        ldr     r1, [r0]
        tst     r1, 0b1 << 17

        beq setup_clock_hse_wait_loop

    @ Configure PLL prediv to 48 MHz
    ldr     r0, =RCC_PLLCFG
    ldr     r1, [r0]
    orr     r1, r1, 0b1 << 5
    bic     r1, r1, 0b1 << 4
    @ Select PREDIV as PLL input (4 MHz)
    orr     r1, r1, 0b1 << 22
    str     r1, [r0]

    @ Enable PLL
    ldr     r0, =RCC_CTRL
    ldr     r1, [r0]
    orr     r1, r1, 0b1 << 24
    str     r1, [r0]

    @ Wait for PLL to spin up
    setup_clock_pll_wait_loop:
        ldr     r1, [r0]
        tst     r1, 0b1 << 25

        beq setup_clock_pll_wait_loop
    
    @ Configure AHB frequency to 48 MHz
    ldr     r0, =RCC_CFG
    ldr     r1, [r0]
    orr     r1, r1, 0b0000 << 4
    @ set PLL as SYSCLK source
    orr     r1, r1, #0b10
    str     r1, [r0]
    @ Wait for changes to apply
    setup_clock_ahb_wait_loop:
        ldr     r1, [r0]
        and     r1, r1, #0b1100
        tst     r1, #0b1000
        beq     setup_clock_ahb_wait_loop

    @ set APB frequency to 48 MHz
    ldr     r1, [r0]
    orr     r1, r1, 0b000 << 10
    str     r1, [r0]

    pop     {r0, r1, r2, pc}



.global setup_timer
.thumb_func
setup_timer:
    push    {r0, r1, r2, lr} 

    ldr     r1, [sp, #16] @ load arg

    @ Set data values
    ldr     r0, =systick_counter_capacity
    str     r1, [r0]

    ldr     r0, =systick_counter
    mov     r1, #0
    str     r1, [r0]
    @ Set reload value to 1ms
    ldr     r0, =SYSTICK_CALIB
    ldr     r1, [r0]
    bic     r1, r1, 0b11 << 30 @ exclude SKEW and NOREF
    mov     r2, #10
    udiv    r1, r1, r2
    ldr     r0, =SYSTICK_RELV
    str     r1, [r0]
    @ Reset initial value
    ldr     r0, =SYSTICK_CURV
    mov     r1, #0
    str     r1, [r0]
    @ Set clock source
    ldr     r0, =SYSTICK_CTRL
    mov     r1, #0b11
    str     r1, [r0]
 
    pop     {r0, r1, r2, pc}



.section .data
.align 2

.global systick_counter_capacity
systick_counter_capacity:
    .word 0x00
    
.global systick_counter
systick_counter:
    .word 0x00
