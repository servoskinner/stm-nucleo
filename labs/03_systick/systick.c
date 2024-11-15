#include <stdint.h>
#include <stdbool.h>
#include "../F401RE.h"

// RCC configuration _________________________

#define CPU_FREQUENCY 1920000U // TRUE and HONEST CPU frequency: 1.92 MHz
#define ONE_MILLISECOND (CPU_FREQUENCY/1000U)

// Clocking setup.
void board_clocking_init()
{
    // (1) Clock HSE and wait for oscillations to setup.
    *RCC_CTRL |= ONE(16);
    while ((*RCC_CTRL & ONE(17)) != ONE(17)) {};

    // (2) Configure PLL:
    // PREDIV output: HSE*192/32 = 48 MHz
    *RCC_PLLCFG |= ONE(5);
    *RCC_PLLCFG &= ZERO(4);

    // (3) Select PREDIV output as PLL input (4 MHz):
    *RCC_PLLCFG |= ONE(22);

    // (4) Set PLLMUL to 12 (omitted)
    // SYSCLK frequency = 48 MHz

    // (5) Enable PLL:
    *RCC_CTRL |= ONE(24);
    while ((*RCC_CTRL & ONE(25)) != ONE(25)) {};
    // (6) Configure AHB frequency to 48 MHz:
    *RCC_CFG |= 0b0000U << 4;
    // (7) Select PLL as SYSCLK source:
    *RCC_CFG |= 0b10U;
    while ((*RCC_CFG & 0b1100U) != 0b1000U) {};
    // (8) Set APB frequency to 48 MHz
    *RCC_CFG |= 0b000U << 10U;
}

// GPIO Setup
void board_gpio_init()
{
    // (1) Enable GPIOA, GPIOB and GPIOC clocking:
    *RCC_AHB1ENA |= ONE(0);
    *RCC_AHB1ENA |= ONE(1);
    *RCC_AHB1ENA |= ONE(2);
    // (2) Configure GPIOA_(0-7) mode:
    *GPIOA(IO_MODE) = 0b0101010101010101U;
}

// Systick setup
void systick_init(uint32_t period_us)
{
    // (0) Read STM32F051 SysTick configuration:
    // - There is a reference clock and it can be chosen as clock source.
    // - The SYST_CALIB SKEW bit is 1.
    uint32_t reload_value = period_us * CPU_FREQUENCY / 8 / 1000000U;

    // (1) Set reload value:
    *SYSTICK_RVR = (reload_value - 1U) & 0x00FFFFFFU;
    // (2) Clear current value:
    *SYSTICK_CVR = 0U;
    // (3) Set clock source
    *SYSTICK_CTRL = 0b111U;
}

void systick_handler(void)
{
    static int handler_ticks = 0U;
    handler_ticks += 1U;

    if (handler_ticks == 10000U)
    {
        handler_ticks = 0U;
        *GPIOA(IO_OUTPUT) ^= ONE(5); // invert
    }
}

int main(void)
{
    board_clocking_init();
    board_gpio_init();

    systick_init(1000U);

	while(1) 
    {
        __asm__ volatile("nop");
    }
}
