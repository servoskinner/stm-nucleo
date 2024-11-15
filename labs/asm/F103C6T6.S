.ifndef F103C6T6
.define F103C6T6
@ Register macros
.equ CPU_FREQ,      48000000  @ STM32F103C6T6 max frequency

.equ RCC_CTRL,      0x40021000 @ Clock Control
.equ RCC_PLLCFG,    0x40021004 @ PLL Configuration
.equ RCC_CFG,       0x40021008 @ Clock Configuration

.equ RCC_CLIR,      0x4002100C @ Clock Interrupts

.equ RCC_AHBENA,    0x40021014 @ AHB Peripheral clock enable
.equ RCC_APB1ENA,   0x4002101C @ APB1 Peripheral clock enable
.equ RCC_APB2ENA,   0x40021018 @ APB2 Peripheral clock enable

.equ RCC_AHBRST,    0x40021028 @ AHB Peripheral clock reset
.equ RCC_APB1RST,   0x40021020 @ APB1 Peripheral clock reset
.equ RCC_APB2RST,   0x40021024 @ APB2 Peripheral clock reset

.equ RCC_CLCCS,     0x40021030 @ Clock control

.equ NVIC_ISER,     0xE000E100 @ Interrupt enable

.equ SYSTICK_CTRL,  0xE000E010 @ Systick control
.equ SYSTICK_RELV,  0xE000E014 @ Systick reload value
.equ SYSTICK_CURV,  0xE000E018 @ Systick current value
.equ SYSTICK_CALIB, 0xE000E01C @ Systick calibration value

.equ ADC_SR,        0x40012400 @ Analog-digital converter status
.equ ADC_CR1,       0x40012404 @ Analog-digital converter control 1
.equ ADC_CR2,       0x40012408 @ Analog-digital converter control 2
.equ ADC_SMPR1,     0x4001240C @ Analog-digital converter sample rate 1
.equ ADC_SMPR2,     0x40012410 @ Analog-digital converter sample rate 2
.equ ADC_SQR3,      0x4001242C @ Analog-digital converter conversion sequence 3
.equ ADC_DR,        0x4001244C @ Analog-digital converter output

.equ GPIOA,         0x40010800 
.equ GPIOB,         0x40010C00
.equ GPIOC,         0x40011000
.equ GPIOD,         0x40011400
.equ GPIOE,         0x40011800

.equ IO_MODE,       0x00
.equ IO_TYPE,       0x04
.equ IO_SPEED,      0x08
.equ IO_PULL,       0x0C
.equ IO_INPUT,      0x10
.equ IO_OUTPUT,     0x14
.equ IO_RESET,      0x18

.endif