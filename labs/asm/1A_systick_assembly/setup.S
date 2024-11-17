.syntax unified
.thumb

.include "../F401RE.S"
.include "../macros.S"



.section .text

.global setup_gpio
.thumb_func
setup_gpio:
    push    {lr} 

    @ Enable GPIOA and GPIOC
    ONES    RCC_AHB1ENA, 0b00101, 0
    @ Configure A5 as output
    SETBG   GPIOA, IO_MODE, 0b01, 2, (5*2)
    @ C13 is already configured as output

    pop     {pc}



.global setup_clock
.thumb_func
setup_clock:
    push {lr} 

    @ Enable HSE clock
    ONES     RCC_CTRL, 0b1, 16

    @ Wait for oscillations to set up.
    ldr     r0, =RCC_CTRL
    setup_clock_hse_wait_loop:
        ldr     r1, [r0]
        tst     r1, 0b1 << 17

        beq setup_clock_hse_wait_loop

    @ Configure PLL prediv to 48 MHz
    @ bytes should not be reset
    SETB    RCC_PLLCFG, 0b100000, 6, 0 @ PLLM = 32
    
    ldr     r0, =RCC_PLLCFG
    ldr     r1, [r0]
    ldr     r2, =((1 << 10 - 1) << 6)
    bic     r1, r1, r2
    ldr     r2, =(256 << 6)
    orr     r1, r1, r2
    str     r1, [r0]
    @ Select HSE as PLL input (8 MHz)
    ONES    RCC_PLLCFG, 0b1, 22
    @ Enable PLL
    ONES    RCC_CTRL, 0b1, 24

    @ Wait for PLL to spin up
    ldr     r0, =RCC_CTRL   
    setup_clock_pll_wait_loop:
        ldr     r1, [r0]
        tst     r1, 0b1 << 25

        beq setup_clock_pll_wait_loop

    @ Configure AHB frequency to 48 MHz
    SETB    RCC_CFG, 0b0000, 4, 4 
    @ set PLL as SYSCLK source
    SETB    RCC_CFG, 0b10, 2, 0

    @ Wait for changes to apply
    ldr     r0, =RCC_CFG
    setup_clock_ahb_wait_loop:
        ldr     r1, [r0]
        and     r1, r1, 0b11 << 2
        tst     r1, 0b10 << 2
        beq     setup_clock_ahb_wait_loop

    @ set APB frequency to 48 MHz
    SETB    RCC_CFG, 0b000, 3, 10

    pop     {pc}



.global setup_timer
.thumb_func
setup_timer:
    push    {lr} 
    @ Set data values
    ldr     r1, =systick_counter_capacity
    str     r0, [r1]

    @ 4 MHz -> 1ms
    ldr     r0, =SYSTICK_RELV
    ldr     r1, =4000
    str     r1, [r0]

    @ Reset initial value
    SETC    SYSTICK_CURV, 0
    @ Set clock source
    SETB    SYSTICK_CTRL, 0b11, 2, 0

    pop     {pc}



.section .data

.global systick_counter_capacity
systick_counter_capacity:
    .word 0x00
    
.global systick_counter
systick_counter:
    .word 0x00
