.syntax unified
.thumb

.include "../F401RE.S"
.include "../macros.S"

.extern setup_clock
.extern setup_timer
.extern setup_gpio
.extern setup_adc
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

.thumb_func
__exc_handler:
    b __exc_handler

.thumb_func
__dummy_handler:
    bx lr

.global reset
.thumb_func
reset:
    ldr     r0, =__data_lma_start
    ldr     r1, =__data_vma_start
    ldr     r2, =__data_vma_end

    _loop_copy_data:
        cmp     r1, r2
        beq     _end_copy_data
        ldr     r3, [r0]
        str     r3, [r1]

        add     r0, r0, #4
        add     r1, r1, #4
        b       _loop_copy_data
    _end_copy_data:

    bl main



.global main
.thumb_func
main:
    @ Set everything up
    bl      setup_clock
    bl      setup_gpio
    @ Set up ADC
    bl      setup_adc
    @ Set timer to 10 ms
	mov		r0, 20
    bl      setup_timer

    _main_infinite_loop:
        nop
    b   _main_infinite_loop
        


.global systick_handler
.thumb_func
systick_handler:
    push    {lr} 

    ldr     r0, =systick_counter
    ldr     r1, [r0]
    add     r1, r1, #1
    ldr     r0, =systick_counter_capacity
    ldr     r2, [r0]
    cmp     r1, r2

    bne     _systick_handler_continue   
        @ Start conversion
        ONES    ADC_CR2, 0b1, 30
        eor     r1, r1, r1

    _systick_handler_continue:

    ldr     r0, =systick_counter
    str     r1, [r0]

    pop     {pc}	

