#pragma once
// Functional Macros

#define ONE(x)       (uint32_t)(0b1U << (x))
#define ZERO(x)      (uint32_t)(~ONE((x)))
#define MASK(x)      (uint32_t)(0b1U << ((x)+1) - 0b1U)

// RCC Registers ________________________________________

#define RCC_CTRL     (volatile uint32_t*)(uintptr_t)0x40023800U // Clock Control Register (RCC_CR)
#define RCC_PLLCFG   (volatile uint32_t*)(uintptr_t)0x40023804U // PLL Configuration (RCC_PLLCFGR)
#define RCC_CFG      (volatile uint32_t*)(uintptr_t)0x40023808U // Clock configuration (RCC_CFGR)

#define RCC_CLIR     (volatile uint32_t*)(uintptr_t)0x4002380CU // Clock interrupts (RCC_CLIR)

#define RCC_AHB1RST  (volatile uint32_t*)(uintptr_t)0x40023810U // AHB1 Peripheral Clock Reset
#define RCC_AHB2RST  (volatile uint32_t*)(uintptr_t)0x40023814U // AHB2 Peripheral Clock Reset
#define RCC_APB1RST  (volatile uint32_t*)(uintptr_t)0x40023820U // APB1 Peripheral Clock Reset
#define RCC_APB2RST  (volatile uint32_t*)(uintptr_t)0x40023824U // APB2 Peripheral Clock Reset

#define RCC_AHB1ENA  (volatile uint32_t*)(uintptr_t)0x40023830U // AHB1 Peripheral clock enable
#define RCC_AHB2ENA  (volatile uint32_t*)(uintptr_t)0x40023834U // AHB2 Peripheral clock enable
#define RCC_APB1ENA  (volatile uint32_t*)(uintptr_t)0x40023840U // APB1 Peripheral clock enable
#define RCC_APB2ENA  (volatile uint32_t*)(uintptr_t)0x40023844U // APB2 Peripheral clock enable

#define RCC_CLCCS    (volatile uint32_t*)(uintptr_t)0x40023874U // Clock control and status

// GPIO Registers________________________________________

#define GPIOA(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020000U + (reg))
#define GPIOB(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020400U + (reg))
#define GPIOC(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020800U + (reg))
#define GPIOD(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020C00U + (reg))
#define GPIOE(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40021000U + (reg))

#define IO_MODE      (uint32_t)0x00U // Sets mode: input/output/analog/special
#define IO_TYPE      (uint32_t)0x04U
#define IO_SPEED     (uint32_t)0x08U // Sets speed mode
#define IO_PULL      (uint32_t)0x0CU
#define IO_INPUT     (uint32_t)0x10U
#define IO_OUTPUT    (uint32_t)0x14U
#define IO_RESET     (uint32_t)0x18U
#define IO_AFRL      (uint32_t)0x20U
#define IO_AFRH      (uint32_t)0x24U

// Timer Registers_______________________________________

#define TIM2_CR1     (volatile uint32_t*)(uintptr_t)0x40000000U // TIM2 Control Register 1
#define TIM2_DIER    (volatile uint32_t*)(uintptr_t)0x4000000CU // TIM2 DMA/Interrupt Enable Register
#define TIM2_SR      (volatile uint32_t*)(uintptr_t)0x40000010U // TIM2 Status Register
#define TIM2_CNT     (volatile uint32_t*)(uintptr_t)0x40000024U // TIM2 Counter

// NVIC Registers________________________________________

#define NVIC_ISER0   (volatile uint32_t*)(uintptr_t)0xE000E100U // Interrupt Set-Enable Register 0
#define NVIC_ICPR0   (volatile uint32_t*)(uintptr_t)0xE000E280U // Interrupt Clear-Pending Register 0

// SysTick registers_____________________________________

#define SYSTICK_CTRL   (volatile uint32_t*)(uintptr_t)0xE000E010U // SysTick Control and Status Register
#define SYSTICK_RVR   (volatile uint32_t*)(uintptr_t)0xE000E014U // SysTick Reload Value Register
#define SYSTICK_CVR   (volatile uint32_t*)(uintptr_t)0xE000E018U // SysTick Current Value Register
#define SYSTICK_CALIB (volatile uint32_t*)(uintptr_t)0xE000E01CU // SysTick Calibration Value Register
