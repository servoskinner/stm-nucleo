.syntax unified
.thumb

.include "../F401RE.S"
.include "../macros.S"



.section .text
.align 4

.global setup_gpio
.thumb_func
setup_gpio:
    push    {lr} 

    @ activate clock 
    ONES    RCC_AHB1ENA, 0b00110, 0
    @ Configure B0-B8 as output 
    ldr     r0, =GPIOB
    ldr     r1, [r0, #IO_MODE]
    mov     r2, #0b11
    mov     r3, #0b01

    _setup_gpio_loop1:
        cmp     r2, 0b11 << (8*2)
        beq _setup_gpio_loop1_end

        bic     r1, r1, r2
        orr     r1, r1, r3
        lsl     r2, r2, #2
        lsl     r3, r3, #2
        b   _setup_gpio_loop1

    _setup_gpio_loop1_end:
    str     r1, [r0, #IO_MODE]

    @ Configure C13 as input
    SETBG   GPIOC, IO_MODE, 0b00, 2, 13*2
    @ ldr     r0, =GPIOC
    @ ldr     r1, [r0, #IO_MODE]
    @ bic     r1, r1, 0b11 << (13*2)
    @ str     r1, [r0, #IO_MODE]

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
    SETB    RCC_PLLCFG, 0b10, 2, 4
    @ Select PREDIV as PLL input (4 MHz)
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
    ldr     r0, =systick_counter_capacity
    str     r0, [r0]
    SETC    systick_counter, 0

    @ Set reload value to 10ms
    ldr     r0, =SYSTICK_CALIB
    ldr     r1, [r0]
    bic     r1, r1, 0b1 << 31
    ldr     r0, =SYSTICK_RELV
    str     r1, [r0]

    @ Reset initial value
    SETC    SYSTICK_CURV, 0
    @ Set clock source
    SETB    SYSTICK_CTRL, 0b11, 2, 0

    pop     {pc}



.section .data
.align 4

.global systick_counter_capacity
systick_counter_capacity:
    .word 0x00
    
.global systick_counter
systick_counter:
    .word 0x00
