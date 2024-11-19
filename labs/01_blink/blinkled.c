#include <stdint.h>
#include <stdbool.h>
#include "../F401RE.h"

#define CPU_FREQUENCY 4000000U // TRUE and HONEST CPU frequency: 1.92 MHz
#define ONE_MILLISECOND (CPU_FREQUENCY/1000U)

int peepee = 256;
int pooopoo = 16;

void board_clocking_init()
{
    // (1) Clock HSE and wait for oscillations to setup.
    *REG_RCC_CR |= ONE(16);
    while ((*REG_RCC_CR & ONE(17)) != ONE(17));

    // (2) Configure PLL:
    // PREDIV output: HSE*256/32/2 = 32 MHz
    uint32_t pllcfg;

    pllcfg = *REG_RCC_PLLCFGR;
    pllcfg = (pllcfg & ~MASK(6)) | 0b100000; // PLLM = 32
    pllcfg = (pllcfg & ~(MASK(9) << 6)) | (256U << 6); // PLLN = 256

    *REG_RCC_PLLCFGR = pllcfg;

    // (3) Select PREDIV output as PLL input (4 MHz):
    *REG_RCC_PLLCFGR |= ONE(22);

    // (5) Enable PLL:
    *REG_RCC_CR |= ONE(24);
    while ((*REG_RCC_CR & ONE(25)) != ONE(25)) {};
    // (6) Configure AHB frequency to 32 MHz:
    *REG_RCC_CFGR |= 0b0000U << 4;
    // (7) Select PLL as SYSCLK source:
    *REG_RCC_CFGR |= 0b10U;
    while ((*REG_RCC_CFGR & 0b1100U) != 0b1000U) {};
    // (8) Set APB frequency to 32 MHz
    *REG_RCC_CFGR |= 0b000U << 10U;
}

void board_gpio_init()
{
    // (1) Enable GPIOA, GPIOC clocking:
    *REG_RCC_AHB1ENR |= ONE(0);
    *REG_RCC_AHB1ENR |= ONE(2);
    // (2) Configure GPIOA_5, GPIOC_13 mode:
    *REG_GPIOA(GPIO_MODE)|= 0b01U << (2*5U);
    *REG_GPIOC(GPIO_MODE)|= 0b00U << (2*13U);
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
        bool button_reading = *REG_GPIOC(GPIO_INPUT) & ONE(13);

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
                    *REG_GPIOA(GPIO_OUTPUT) ^= ONE(5); // xor the button
                }
            saturation = 0;
            button_state = false;
        }

        delay(5);
    }
}
