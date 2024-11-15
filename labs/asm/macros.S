.ifndef MACROS 
#define MACROS


@ Enables multiple bits in simple register
.macro ONES reg, val, offs
    ldr     r4, =\reg
    ldr     r5, [r4]
    orr     r5, (\val) << (\offs)
    str     r5, [r4]
.endm

@ Enables multiple bits in grouped register
.macro ONESG group, reg, val, offs
    ldr     r4, =\group
    ldr     r5, [r4, #\reg]
    orr     r5, (\val) << (\offs)
    str     r5, [r4, #\reg]
.endm

@ Clears multiple bits in simple register
.macro ZEROS reg, val, offs
    ldr     r4, =\reg
    ldr     r5, [r4]
    bic     r5, \val << \offs
    str     r5, [r4]
.endm

@ Clears multiple bits in grouped register
.macro ZEROSG group, reg, val, offs
    ldr     r4, =\group
    ldr     r5, [r4, #\reg]
    bic     r5, \val << \offs
    str     r5, [r4, #\reg]
.endm

@ Flips multiple bits in simple register
.macro FLIPS reg, val, offs
    ldr     r4, =\reg
    ldr     r5, [r4]
    eor     r5, \val << \offs
    str     r5, [r4]
.endm

@ Flips multiple bits in grouped register
.macro FLIPSG group, reg, val, offs
    ldr     r4, =\group
    ldr     r5, [r4, #\reg]
    eor     r5, \val << \offs
    str     r5, [r4, #\reg]
.endm

@ Sets bit group in simple register
.macro SETB reg, val, size, offs
    ldr     r4, =\reg
    ldr     r5, [r4]
    bic     r5, (0b1 << (\size+1) - 1) << \offs
    orr     r5, \val << \offs
    str     r5, [r4]
.endm

@ Sets bit group in grouped register
.macro SETBG group, reg, val, size, offs
    ldr     r4, =\group
    ldr     r5, [r4, #\reg]
    bic     r5, (0b1 << (\size+1) - 1) << \offs
    orr     r5, \val << \offs
    str     r5, [r4, #\reg]
.endm

@ Moves const to simple register
.macro SETC reg, val
    ldr     r4, =\reg
    mov     r5, \val
    str     r5, [r4]
.endm

@ Moves const to grouped register
.macro SETCG group, reg, val
    ldr     r4, =\group
    mov     r5, \val
    str     r5, [r4, #\reg]
.endm

.endif
