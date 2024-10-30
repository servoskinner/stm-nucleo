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




.extern setup_clock
.extern setup_timer
.extern systick_counter_capacity
.extern systick_counter



.global reset
.thumb_func
reset:
    ldr     r0, =data_lma_start
    ldr     r1, =data_vma_start
    ldr     r2, =data_vma_end

    loop_copy_data:
        cmp     r1, r2
        beq     end_copy_data
        ldr     r4, [r0]
        str     r4, [r1]

        adds    r0, r0, #4
        adds    r1, r1, #4
        b       loop_copy_data
    end_copy_data:

    bl main



.thumb_func
setup_gpio:
    push    {r0, r1, r2, lr} 

    ldr     r0, =RCC_AHB1ENA
    ldr     r1, [r0]
    orr     r1, r1, #0b00101
    str     r1, [r0]

    @ Configure A5 as output
    ldr     r0, =GPIOA
    ldr     r1, [r0, #IO_MODE]
    bic     r1, r1, 0b11 << (5*2)
    orr     r1, r1, 0b01 << (5*2)
    str     r1, [r0, #IO_MODE]

    pop     {r0, r1, r2, pc}



.global main
.thumb_func
main:
    bl setup_clock
    bl setup_gpio

    ldr     r0, =100
    push    {r0}
    bl      setup_timer
    add     sp, sp, #4 @ discard arg

    main_infinite_loop:
        b   main_infinite_loop
        


.global systick_handler
.thumb_func
systick_handler:
    push    {r0, r1, r2, lr} 

    adds    r5, r5, #1

    ldr     r0, =systick_counter
    ldr     r1, [r0]
    adds    r1, r1, #1
    ldr     r0, =systick_counter_capacity
    ldr     r2, [r0]
    cmp     r1, r2

    bne     systick_handler_continue
        ldr     r0, =GPIOA
        ldr     r1, [r0, #IO_OUTPUT]
        eor     r1, r1, 0b1 << 5
        str     r1, [r0, #IO_OUTPUT]
        mov     r1, #0
    systick_handler_continue:

    ldr     r0, =systick_counter
    str     r1, [r0]

    pop     {r0, r1, r2, pc}



__exc_handler:
    b __exc_handler

__dummy_handler:
    bx lr



.align 4
data_lma_start:
    .word data_lma_start
data_vma_start:
    .word data_vma_start
data_vma_end:
    .word data_vma_end


.section .vector_table

.word __stack_start         @ Initial SP
.word reset                 @ Reset Handler
.word __exc_handler         @ NMI Handler
.word __exc_handler         @ Hard Fault Handler
.word __exc_handler         @ MemManage Handler
.word __exc_handler      	@ BusFault Handler
.word __exc_handler      	@ UsageFault Handler
.fill 4, 4, 0x00            @ Reserved



.word __exc_handler         @ SVCall
.word __exc_handler         @ DebugMon Handler
.word 0x00                  @ Reserved
.word __exc_handler         @ PendSV
.word systick_handler       @ SysTick
