.syntax unified
.thumb

.include "regmap.S"

.extern setup_clock
.extern setup_timer
.extern systick_counter_capacity
.extern systick_counter

.extern dispchar


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
.fill 18, 4, 0x00           @ Skip

.word adc_handler           @ ADC1 Handler



.section .text
.align 4

.global reset
.thumb_func
reset:
    ldr     r0, =data_lma_start
    ldr     r1, =data_vma_start
    ldr     r2, =data_vma_end

    _loop_copy_data:
        cmp     r1, r2
        beq     _end_copy_data
        ldr     r4, [r0]
        str     r4, [r1]

        add     r0, r0, #4
        add     r1, r1, #4
        b       _loop_copy_data
    _end_copy_data:

    bl main



.thumb_func
setup_gpio:
    push    {r0, r1, r2, r3, lr} 

    @ activate GPIOB, GPIOC
    ldr     r0, =RCC_AHB1ENA
    ldr     r1, [r0] 
    orr     r1, r1, #0b00110
    str     r1, [r0]

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
    ldr     r0, =GPIOC
    ldr     r1, [r0, #IO_MODE]
    bic     r1, r1, 0b11 << (13*2)
    str     r1, [r0, #IO_MODE]

    pop     {r0, r1, r2, r3, pc}



.thumb_func
setup_adc:
    push {r0, r1, r2, lr}

    @ activate GPIOA
    ldr     r0, =RCC_AHB1ENA
    ldr     r1, [r0] 
    orr     r1, r1, #0b00001
    str     r1, [r0]

    @ Configure A0 as analog
    ldr     r0, =GPIOA
    ldr     r1, [r0, #IO_MODE]
    orr     r1, r1, 0b11 << (0*2)
    str     r1, [r0, #IO_MODE]

    @ activate ADC1
    ldr     r0, =RCC_APB2ENA
    ldr     r1, [r0]
    orr     r1, r1, 0b1 << 8
    str     r1, [r0]

    @ configure ADC control 1
    ldr     r0, =ADC_CR1
    ldr     r1, [r0]
    orr     r1, r1, 0b10 << 24 @ 8-bit mode
    orr     r1, r1, 0b1 << 5   @ enable end of conversion interrupt
    str     r1, [r0]

    @ configure ADC control 2
    ldr     r0, =ADC_CR2
    ldr     r1, [r0]
    orr     r1, r1, 0b1 << 0 @ enable ADC
    str     r1, [r0]

    @ enable interrupt handling
    ldr     r0, =NVIC_ISER
    ldr     r1, [r0]
    orr     r1, r1, 0b1 << 18
    str     r1, [r0]

    @ ADC_SQR3 is already configured
    @ sample rate is already configured

    pop {r0, r1, r2, pc}



.global main
.thumb_func
main:
    bl setup_clock
    bl setup_gpio
    bl setup_adc

    @ Set timer to 10 ms
	mov		r0, #1000
    push    {r0}
    bl      setup_timer
    add     sp, sp, #4

    _main_infinite_loop:
        nop
        b   _main_infinite_loop
        


.global systick_handler
.thumb_func
systick_handler:
    push    {r0, r1, r2, lr} 

    ldr     r0, =systick_counter
    ldr     r1, [r0]
    add     r1, r1, #1
    ldr     r0, =systick_counter_capacity
    ldr     r2, [r0]
    cmp     r1, r2

    bne     _systick_handler_continue   
        ldr     r0, =ADC_CR2
        ldr     r1, [r0]
        orr     r1, r1, 0b1 << 30 @ start conversion
        str     r1, [r0]

        eor     r1, r1, r1

    _systick_handler_continue:

    ldr     r0, =systick_counter
    str     r1, [r0]

    pop     {r0, r1, r2, pc}	


.thumb_func
__exc_handler:
    b __exc_handler

.thumb_func
__dummy_handler:
    pop {pc}



.align 4
data_lma_start:
    .word data_lma_start
data_vma_start:
    .word data_vma_start
data_vma_end:
    .word data_vma_end



.section .data
.align 4
