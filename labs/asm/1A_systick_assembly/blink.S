.syntax unified
.thumb

.include "../F401RE.S"
.include "../macros.S"

.extern setup_clock
.extern setup_timer
.extern setup_gpio
.extern systick_counter_capacity
.extern systick_counter



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



.section .text
.align 4

.global reset
.thumb_func
reset:
    ldr     r0, =data_lma_start
    ldr     r1, =data_vma_start
    ldr     r2, =data_vma_end

    loop_copy_data:
        cmp     r1, r2
        beq     end_copy_data
        ldr     r3, [r0]
        str     r3, [r1]

        adds    r0, r0, 4
        adds    r1, r1, 4
        b       loop_copy_data
    end_copy_data:

    bl main



.global main
.thumb_func
main:
    bl setup_clock
    bl setup_gpio

    mov     r0, 100
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
    add     r1, r1, 1
    ldr     r0, =systick_counter_capacity
    ldr     r2, [r0]
    cmp     r1, r2

    bne     _systick_handler_continue

        FLIPSG  GPIOA, IO_OUTPUT, 0b1, 5
        mov     r1, 0
    _systick_handler_continue:

    ldr     r0, =systick_counter
    str     r1, [r0]

    pop     {pc}    


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
