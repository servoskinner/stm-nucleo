.syntax unified
.thumb

.section .text
.align 4
@ Register macros
.equ CPU_FREQ,      48000000

.equ RCC_CTRL,      0x40023800 @ Clock Control
.equ RCC_PLLCFG,    0x40023804 @ PLL Configuration
.equ RCC_CFG,       0x40023808 @ Clock Configuration

.equ RCC_CLIR,      0x4002380C @ Clock Interrupts

.equ RCC_AHB1ENA,   0x40023830 @ AHB1 Peripheral clock enable
.equ RCC_AHB2ENA,   0x40023834 @ AHB2 Peripheral clock enable
.equ RCC_APB1ENA,   0x40023840 @ APB1 Peripheral clock enable
.equ RCC_APB2ENA,   0x40023844 @ APB2 Peripheral clock enable

.equ RCC_AHB1RST,   0x40023810 @ AHB1 Peripheral clock reset
.equ RCC_AHB2RST,   0x40023814 @ AHB2 Peripheral clock reset
.equ RCC_APB1RST,   0x40023820 @ APB1 Peripheral clock reset
.equ RCC_APB2RST,   0x40023824 @ APB2 Peripheral clock reset

.equ RCC_CLCCS,     0x40023874 @ Clock control

.equ NVIC_ISER,     0xE000E100 @ Interrupt enable

.equ SYSTICK_CTRL,  0xE000E010 @ Systick control
.equ SYSTICK_RELV,  0xE000E014 @ Systick reload value
.equ SYSTICK_CURV,  0xE000E018 @ Systick current value
.equ SYSTICK_CALIB, 0xE000E01C @ Systick calibration value

.equ GPIOA,         0x40020000 
.equ GPIOB,         0x40020400
.equ GPIOC,         0x40020800
.equ GPIOD,         0x40020C00
.equ GPIOE,         0x40021000

.equ IO_MODE,       0x00
.equ IO_TYPE,       0x04
.equ IO_SPEED,      0x08
.equ IO_PULL,       0x0C
.equ IO_INPUT,      0x10
.equ IO_OUTPUT,     0x14
.equ IO_RESET,      0x18



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
    @ Set reload value to 1s
    ldr     r0, =SYSTICK_CALIB
    ldr     r1, [r0]
    mov     r2, #1
    mul     r1, r2
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
.align 4

.global systick_counter_capacity
systick_counter_capacity:
    .word 0x00
    
.global systick_counter
systick_counter:
    .word 0x00
