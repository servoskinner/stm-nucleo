#include <setup.h>

// GPIO Setup
void setup_gpio()
{
    // Enable GPIOA, GPIOB and GPIOC clocking
    *RCC_AHB1ENA |= 0b111;
    // Configure GPIOA (0-7) mode
    for (int i = 0; i < 8; i++) {
        *GPIOA(IO_MODE) &= ~(MASK(2) << i*2);
        *GPIOA(IO_MODE) |= 0b01U << i*2;
    }
}