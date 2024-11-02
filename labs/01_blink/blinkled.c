#include <stdint.h>
#include <stdbool.h>
#include "../F401RE_reg_map.h"

#define CPU_FREQUENCY 1920000U // TRUE and HONEST CPU frequency: 1.92 MHz
#define ONE_MILLISECOND (CPU_FREQUENCY/1000U)

void board_clocking_init()
{
    // (1) Clock HSE and wait for oscillations to setup.
    *RCC_CTRL |= ONE(16);
    while ((*RCC_CTRL & ONE(17)) != ONE(17));

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
    while ((*RCC_CTRL & ONE(25)) != ONE(25));
    // (6) Configure AHB frequency to 48 MHz:
    *RCC_CFG |= 0b0000U << 4;
    // (7) Select PLL as SYSCLK source:
    *RCC_CFG |= 0b10U;
    while ((*RCC_CFG & 0b1100U) != 0b1000U);
    // (8) Set APB frequency to 48 MHz
    *RCC_CFG |= 0b000U << 10U;
}
void board_gpio_init()
{
    // (1) Enable GPIOA, GPIOC clocking:
    *RCC_AHB1ENA |= ONE(0);
    *RCC_AHB1ENA |= ONE(2);
    // (2) Configure GPIOA_5, GPIOC_13 mode:
    *GPIOA(IO_MODE)|= 0b01U << (2*5U);
    *GPIOC(IO_MODE)|= 0b00U << (2*13U);
}

void delay(uint32_t millis)
{
    for (uint32_t i = 0; i < millis * ONE_MILLISECOND; ++i)
    {
        // Insert NOP for no power consumption:
        __asm__ volatile("nop");
    }
}

#define DEBOUNCING_THRESHOLD 5

int main()
{
#ifndef INSIDE_QEMU
    board_clocking_init();
#endif

    board_gpio_init();

    char saturation = 0U;
    bool button_state = false;

    while (1)
    {   
        bool button_reading = *GPIOC(IO_INPUT) & ONE(13);

        if(button_reading)
        {
            if(saturation == DEBOUNCING_THRESHOLD)
            {
                button_state = true;
             	saturation = 0;
            }
            else
            {
                saturation++;
            }
        }
        else
        {
            if(button_state)
                {
                    *GPIOA(IO_OUTPUT) ^= ONE(5); // xor the button
                }
            saturation = 0;
            button_state = false;
        }

        delay(5);
    }
}
