#include <setup.h>

void setup_clock(uint32_t frequency_hz)
{
    // Enable HSE and wait for oscillations to setup.
    *REG_RCC_CR |= ONE(16);
    while ((*REG_RCC_CR & ONE(17)) != ONE(17));

    // Configure PLL:
    uint32_t pllcfg;
    uint32_t plln_value = frequency_hz / 125000U;

    if (plln_value < 192) { // Min 24 MHz
        plln_value = 192;
    }
    else if (plln_value > 432) { // Max 54 MHz
        plln_value = 432;
    }

    pllcfg = *REG_RCC_PLLCFGR;
    pllcfg = (pllcfg & ~MASK(6)) | 0b100000; // PLLM = 32
    pllcfg = (pllcfg & ~(MASK(9) << 6)) | (plln_value << 6); // PLLN

    *REG_RCC_PLLCFGR = pllcfg;

    // Select HSE output as PLL input (8 MHz):
    *REG_RCC_PLLCFGR |= ONE(22);

    // Enable PLL:
    *REG_RCC_CR |= ONE(24);
    while ((*REG_RCC_CR & ONE(25)) != ONE(25)) {};
    // Configure AHB frequency to PLL
    *REG_RCC_CFGR |= 0b0000U << 4;
    // Select PLL as SYSCLK source:
    *REG_RCC_CFGR |= 0b10U;
    while ((*REG_RCC_CFGR & 0b1100U) != 0b1000U) {};
    // Set APB frequency to PLL
    *REG_RCC_CFGR |= 0b000U << 10U;
}
