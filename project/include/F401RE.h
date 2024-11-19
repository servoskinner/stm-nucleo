#pragma once

#include <stdint.h>
// Functional Macros

#define ONE(x)           (uint32_t)(0b1U << (x))
#define ZERO(x)          (uint32_t)(~ONE((x)))
#define MASK(x)          (uint32_t)((0b1U << ((x)+1)) - 0b1U)

// RCC Registers ________________________________________

#define REG_RCC_CR       (volatile uint32_t*)(uintptr_t)0x40023800U // Clock Control Register (RCC_CR)
#define REG_RCC_PLLCFGR  (volatile uint32_t*)(uintptr_t)0x40023804U // PLL Configuration (RCC_PLLCFGR)
#define REG_RCC_CFGR     (volatile uint32_t*)(uintptr_t)0x40023808U // Clock configuration (RCC_CFGR)

#define REG_RCC_CLIR     (volatile uint32_t*)(uintptr_t)0x4002380CU // Clock interrupts (RCC_CLIR)

#define REG_RCC_AHB1RST  (volatile uint32_t*)(uintptr_t)0x40023810U // AHB1 Peripheral Clock Reset
#define REG_RCC_AHB2RST  (volatile uint32_t*)(uintptr_t)0x40023814U // AHB2 Peripheral Clock Reset
#define REG_RCC_APB1RST  (volatile uint32_t*)(uintptr_t)0x40023820U // APB1 Peripheral Clock Reset
#define REG_RCC_APB2RST  (volatile uint32_t*)(uintptr_t)0x40023824U // APB2 Peripheral Clock Reset

#define REG_RCC_AHB1ENR  (volatile uint32_t*)(uintptr_t)0x40023830U // AHB1 Peripheral clock enable
#define REG_RCC_AHB2ENR  (volatile uint32_t*)(uintptr_t)0x40023834U // AHB2 Peripheral clock enable
#define REG_RCC_APB1ENR  (volatile uint32_t*)(uintptr_t)0x40023840U // APB1 Peripheral clock enable
#define REG_RCC_APB2ENR  (volatile uint32_t*)(uintptr_t)0x40023844U // APB2 Peripheral clock enable

#define REG_RCC_CLCCS    (volatile uint32_t*)(uintptr_t)0x40023874U // Clock control and status

// GPIO Registers________________________________________

#define REG_GPIO_ORIGIN  (uint32_t)0x40020000U
#define REG_GPIO_SPACING (uint32_t)0x400U

#define REG_GPIOA(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020000U + (reg))
#define REG_GPIOB(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020400U + (reg))
#define REG_GPIOC(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020800U + (reg))
#define REG_GPIOD(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020C00U + (reg))
#define REG_GPIOE(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40021000U + (reg))

#define GPIO_MODE        (uint32_t)0x00U // Sets mode: input/output/analog/special
#define GPIO_TYPE        (uint32_t)0x04U
#define GPIO_SPEED       (uint32_t)0x08U // Sets speed mode
#define GPIO_PULL        (uint32_t)0x0CU
#define GPIO_INPUT       (uint32_t)0x10U
#define GPIO_OUTPUT      (uint32_t)0x14U
#define GPIO_RESET       (uint32_t)0x18U
#define GPIO_AFRL        (uint32_t)0x20U
#define GPIO_AFRH        (uint32_t)0x24U

// Timer Registers_______________________________________

#define REG_TIM2_CR1     (volatile uint32_t*)(uintptr_t)0x40000000U // TIM2 Control Register 1
#define REG_TIM2_DIER    (volatile uint32_t*)(uintptr_t)0x4000000CU // TIM2 DMA/Interrupt Enable Register
#define REG_TIM2_SR      (volatile uint32_t*)(uintptr_t)0x40000010U // TIM2 Status Register
#define REG_TIM2_CNT     (volatile uint32_t*)(uintptr_t)0x40000024U // TIM2 Counter

// NVIC Registers________________________________________

#define REG_NVIC_ISER0   (volatile uint32_t*)(uintptr_t)0xE000E100U // Interrupt Set-Enable Register 0
#define REG_NVIC_ICPR0   (volatile uint32_t*)(uintptr_t)0xE000E280U // Interrupt Clear-Pending Register 0

// SysTick registers_____________________________________

#define REG_SYSTICK_CTRL  (volatile uint32_t*)(uintptr_t)0xE000E010U // SysTick Control and Status Register
#define REG_SYSTICK_RVR   (volatile uint32_t*)(uintptr_t)0xE000E014U // SysTick Reload Value Register
#define REG_SYSTICK_CVR   (volatile uint32_t*)(uintptr_t)0xE000E018U // SysTick Current Value Register
#define REG_SYSTICK_CALIB (volatile uint32_t*)(uintptr_t)0xE000E01CU // SysTick Calibration Value Register
