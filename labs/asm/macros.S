.ifndef MACROS 
#define MACROS


@ Enables multiple bits in simple register
.macro ONES reg, val, offs
    ldr     r0, =\reg
    ldr     r1, [r0]
    orr     r1, (\val) << (\offs)
    str     r1, [r0]
.endm

@ Enables multiple bits in grouped register
.macro ONESG group, reg, val, offs
    ldr     r0, =\group
    ldr     r1, [r0, #\reg]
    orr     r1, (\val) << (\offs)
    str     r1, [r0, #\reg]
.endm

@ Clears multiple bits in simple register
.macro ZEROS reg, val, offs
    ldr     r0, =\reg
    ldr     r1, [r0]
    bic     r1, \val << \offs
    str     r1, [r0]
.endm

@ Clears multiple bits in grouped register
.macro ZEROSG group, reg, val, offs
    ldr     r0, =\group
    ldr     r1, [r0, #\reg]
    bic     r1, \val << \offs
    str     r1, [r0, #\reg]
.endm

@ Flips multiple bits in simple register
.macro FLIPS reg, val, offs
    ldr     r0, =\reg
    ldr     r1, [r0]
    eor     r1, \val << \offs
    str     r1, [r0]
.endm

@ Flips multiple bits in grouped register
.macro FLIPSG group, reg, val, offs
    ldr     r0, =\group
    ldr     r1, [r0, #\reg]
    eor     r1, \val << \offs
    str     r1, [r0, #\reg]
.endm

@ Sets bit group in simple register
.macro SETB reg, val, size, offs
    ldr     r0, =\reg
    ldr     r1, [r0]
    bic     r1, (0b1 << (\size+1) - 1) << \offs
    orr     r1, \val << \offs
    str     r1, [r0]
.endm

@ Sets bit group in grouped register
.macro SETBG group, reg, val, size, offs
    ldr     r0, =\group
    ldr     r1, [r0, #\reg]
    bic     r1, (0b1 << (\size+1) - 1) << \offs
    orr     r1, \val << \offs
    str     r1, [r0, #\reg]
.endm

@ Moves const to simple register
.macro SETC reg, val
    ldr     r0, =\reg
    mov     r1, \val
    str     r1, [r0]
.endm

@ Moves const to grouped register
.macro SETCG group, reg, val
    ldr     r0, =\group
    mov     r1, \val
    str     r1, [r0, #\reg]
.endm

.endif
