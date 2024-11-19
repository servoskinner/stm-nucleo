#include <stdint.h>
#include <stdbool.h>
#include "../F401RE.h"

// RCC configuration _________________________

#define HSEFREQ_HZ 8000000
#define PLLM 32
#define PLLN 256
#define PLLQ 2

#define CPU_FREQUENCY (HSEFREQ_HZ / PLLM / PLLQ * PLLN) // TRUE and HONEST CPU frequency: 32 MHz
#define ONE_MILLISECOND (CPU_FREQUENCY/1000U)

void board_clocking_init()
{
    // (1) Clock HSE and wait for oscillations to setup.
    *RCC_CTRL |= ONE(16);
    while ((*RCC_CTRL & ONE(17)) != ONE(17));

    // (2) Configure PLL:
    // PREDIV output: HSE*256/32/2 = 32 MHz
    uint32_t pllcfg;

    pllcfg = *RCC_PLLCFG;
    pllcfg = (pllcfg & ~MASK(6)) | 0b100000; // PLLM = 32
    pllcfg = (pllcfg & ~(MASK(9) << 6)) | (256U << 6); // PLLN = 256

    *RCC_PLLCFG = pllcfg;

    // (3) Select PREDIV output as PLL input (4 MHz):
    *RCC_PLLCFG |= ONE(22);

    // (5) Enable PLL:
    *RCC_CTRL |= ONE(24);
    while ((*RCC_CTRL & ONE(25)) != ONE(25)) {};
    // (6) Configure AHB frequency to 32 MHz:
    *RCC_CFG |= 0b0000U << 4;
    // (7) Select PLL as SYSCLK source:
    *RCC_CFG |= 0b10U;
    while ((*RCC_CFG & 0b1100U) != 0b1000U) {};
    // (8) Set APB frequency to 32 MHz
    *RCC_CFG |= 0b000U << 10U;
}

// GPIO Setup
void board_gpio_init()
{
    // (1) Enable GPIOA, GPIOB and GPIOC clocking:
    *RCC_AHB1ENA |= 0b111;
    // (2) Configure GPIOA_(0-7) mode:
    for (int i = 0; i < 8; i++) {
        *GPIOA(IO_MODE) &= ~(MASK(2) << i*2);
        *GPIOA(IO_MODE) |= 0b01U << i*2;
    }
}

// Systick setup
void systick_init(uint32_t period_ms)
{
    // (0) Read STM32F051 SysTick configuration:
    // - There is a reference clock and it can be chosen as clock source.
    // - The SYST_CALIB SKEW bit is 1.
    uint32_t reload_value = ONE_MILLISECOND;

    // (1) Set reload value:
    *SYSTICK_RVR = (reload_value - 1U) & MASK(24);
    // (2) Clear current value:
    *SYSTICK_CVR = 0U;
    // (3) Set clock source
    *SYSTICK_CTRL = 0b111U;
}

void systick_handler(void)
{

    *GPIOA(IO_OUTPUT) ^= ONE(5); // flip
}

int main(void)
{
    board_clocking_init();
    board_gpio_init();

    systick_init(2000U);

	while(1) 
    {
        __asm__ volatile("nop");
    }
}
