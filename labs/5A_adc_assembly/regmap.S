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

.equ ADC_SR,        0x40012000 @ Analog-digital converter status
.equ ADC_CR1,       0x40012004 @ Analog-digital converter control 1
.equ ADC_CR2,       0x40012008 @ Analog-digital converter control 2
.equ ADC_SMPR1,     0x4001200C @ Analog-digital converter sample rate 1
.equ ADC_SMPR2,     0x40012010 @ Analog-digital converter sample rate 2
.equ ADC_SQR3,      0x40012032 @ Analog-digital converter conversion sequence 3
.equ ADC_DR,        0x4001204C @ Analog-digital converter output

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
