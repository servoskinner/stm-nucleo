#include <stdint.h>
#include <stdbool.h>

// Functional Macros

#define ONE(x)       (uint32_t)(0b1U << (x))
#define ZERO(x)      (uint32_t)(~ONE((x)))

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

#define RCC_CLCCS    (volatile uint32_t*)(uintptr_t)0x40023844U // Clock control and status

// GPIO Registers________________________________________

#define GPIOA(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020000U + (reg))
#define GPIOB(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020400U + (reg))
#define GPIOC(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020800U + (reg))
#define GPIOD(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40020C00U + (reg))
#define GPIOE(reg)   (volatile uint32_t*)(uintptr_t)((uint32_t)0x40021000U + (reg))

#define IO_MODE      (uint32_t)0x00U
#define IO_TYPE      (uint32_t)0x04U
#define IO_SPEED     (uint32_t)0x08U
#define IO_PULL      (uint32_t)0x0CU
#define IO_INPUT        (uint32_t)0x10U
#define IO_OUTPUT       (uint32_t)0x14U
#define IO_RESET        (uint32_t)0x18U

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
    // (1) Enable GPIOA clocking:
    *RCC_AHB1ENA |= ONE(0);
    *RCC_AHB1ENA |= ONE(2);
    // (2) Configure GPIOA_5 mode:
    *GPIOA(IO_MODE)|= 0b01U << (2*5U);
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
        // *GPIOA(IO_OUTPUT) |= ONE(5);

        // delay(600);

        // *GPIOA(IO_OUTPUT) &= ZERO(5);

        // delay(100);

        
        bool button_reading = *GPIOC(IO_INPUT) & ONE(13);

        if(button_reading)
        {
            if(saturation == DEBOUNCING_THRESHOLD)
            {
                button_state = true;
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
