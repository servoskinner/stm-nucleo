.syntax unified
.thumb

.include "../F401RE.S"
.include "../macros.S"

.extern setup_clock
.extern setup_timer
.extern systick_counter_capacity
.extern systick_counter

.extern dispchar
.extern pwm_cycle
.extern pwm_state
.extern pwm_resolution



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
    bl      setup_clock
    bl      setup_gpio
    @ Set timer to 10 ms
	mov		r0, 1
    bl      setup_timer
    @ Set up ADC
    bl      setup_adc

    mov     r0, 0
    bl      dispchar

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
        bl      systick_cycle

        ldr     r0, =clock_counter
        ldr     r1, [r0]
        mov     r2, #16
        udiv    r3, r1, r2
        mul     r3, r3, r2
        sub     r1, r1, r3

        mov     r0, r1
        bl      pwm_cycle

       	eor     r1, r1, r1

    _systick_handler_continue:

    ldr     r0, =systick_counter
    str     r1, [r0]

    pop     {pc}



.thumb_func
systick_cycle:
    push    {lr}

    ldr 	r0, =GPIOC
    ldr 	r1, [r0, #IO_INPUT]

    ldr 	r0, =button_saturation
    tst		r1, 0b1 << 13
    beq		_systick_cycle_button_down
    @ button up
        eor		r1, r1, r1
        str 	r1, [r0]
        ldr 	r0, =button_state
        strb	r1, [r0]
    
    b 		_systick_cycle_button_test_end
    _systick_cycle_button_down: 
    @ button down
        ldr		r1, [r0]
        ldr		r0, =button_threshold
        ldr		r2, [r0]
        cmp 	r1, r2
        beq 	_systick_cycle_saturated
            add		r1, r1, #1
            ldr		r0, =button_saturation
            str 	r1, [r0]

        b 		_systick_cycle_button_test_end
        _systick_cycle_saturated:
            ldr		r0, =button_state
            ldrb	r1, [r0]
            tst		r1, 0b1

            bne _systick_cycle_button_test_end
            bl button_down
            
    _systick_cycle_button_test_end:
    pop     {pc}

button_down:
	push	{lr}

	ldr		r0, =button_state
	mov 	r1, 0b00000001
	strb	r1, [r0]
	
	ldr		r0, =clock_counter
	ldr 	r1, [r0]
	add 	r1, r1, #1
	str 	r1, [r0]

	push	{r1}
	bl		dispchar
    add     sp, sp, #4

	pop		{pc}
	


.thumb_func
__exc_handler:
    b __exc_handler

.thumb_func
__dummy_handler:
    pop {pc}



.section .data

clock_counter:
    .word 0x00000000
button_saturation:
    .word 0x00000000
button_threshold:
	.word 0x00000005
button_state:
	.byte 0x00
