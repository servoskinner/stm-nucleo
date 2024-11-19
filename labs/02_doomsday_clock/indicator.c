#include <stdint.h>
#include <stdbool.h>
#include "../F401RE.h"
//___________________
//
// 7-segment display
//___________________

// TRUE and HONEST Pin Mapping:
#define A  ONE(0)
#define B  ONE(1)
#define C  ONE(2)
#define D  ONE(3)
#define E  ONE(4)
#define F  ONE(5)
#define G  ONE(6)
#define DP ONE(7)

static const uint32_t PINS_USED = A|B|C|D|E|F|G|DP;

// TOTALLY CORRECT digit composition:
static const uint32_t DIGITS[10] =
{
    A|B|C|D|E|F,   // 0
    B|C,           // 1
    A|B|G|E|D,     // 2
    A|B|G|C|D,     // 3
    F|G|B|C,       // 4
    A|F|G|C|D,     // 5
    A|F|G|C|D|E,   // 6
    A|B|C,         // 7
    A|B|C|D|E|F|G, // 8
    A|B|C|D|F|G    // 9
};


void display_number(int digit)
{
    uint32_t unchanged_pins = *REG_GPIOB(GPIO_INPUT) & ~PINS_USED;
    *REG_GPIOB(GPIO_OUTPUT) = unchanged_pins | DIGITS[(digit) % 10]; 
}

//___________________
// RCC configuration
//___________________

#define CPU_FREQUENCY 32000000U // TRUE and HONEST CPU frequency: 32 MHz
#define ONE_MILLISECOND (CPU_FREQUENCY/1000U)

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

void delay(uint32_t millis)
{
    for (uint32_t i = 0; i < millis * ONE_MILLISECOND; ++i)
    {
        // Insert NOP for no power consumption:
        __asm__ volatile("nop");
    }
}
//____________________
// GPIO configuration
//____________________

void board_gpio_init()
{
    // (1) Enable GPIOB and GPIOC clocking:
    *REG_RCC_AHB1ENR |= ONE(1);
    *REG_RCC_AHB1ENR |= ONE(2);
    // (2) Configure GPIOB_(0-7) mode:
    *REG_GPIOB(GPIO_MODE) = 0b0101010101010101U;
}

//______
// Main
//______
#define DEBOUNCING_THRESHOLD 5

int main()
{
    board_clocking_init();

    board_gpio_init();

    char saturation = 0U;
    bool button_state = false;

    uint32_t digit = 0U;
    display_number(digit);

    while (1)
    {
        bool button_reading = *REG_GPIOC(GPIO_INPUT) & ONE(13);

        if(button_reading)
        {
            if(saturation == DEBOUNCING_THRESHOLD)
            {
                button_state = true;
                *REG_GPIOB(GPIO_OUTPUT) &= ZERO(7);
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
                    digit = (digit + 1U) % 10U;
                    display_number(digit);
                }
            saturation = 0;
            button_state = false;
            *REG_GPIOB(GPIO_OUTPUT) |= ONE(7);
        }

        delay(5);
    }
}
