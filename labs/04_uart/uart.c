#include <stdint.h>
#include <stddef.h>


#include "../F401RE.h"


// UART Registers___________________________________________________

#define USART1_CR1 (volatile uint32_t*)(uintptr_t)0x40011000U // Control register 1
#define USART1_CR2 (volatile uint32_t*)(uintptr_t)0x40011004U // Control register 2
#define USART1_BRR (volatile uint32_t*)(uintptr_t)0x4001100CU // Baud rate register
#define USART1_ISR (volatile uint32_t*)(uintptr_t)0x4001101CU // Interrupt and status register
#define USART1_RDR (volatile uint32_t*)(uintptr_t)0x40011024U // Receive data register
#define USART1_TDR (volatile uint32_t*)(uintptr_t)0x40011028U // Transmit data register

// RCC configuration_______________________________________________

#define CPU_FREQUENCY 32000000U // CPU frequency: 32 MHz
#define ONE_MILLISECOND CPU_FREQENCY/1000U

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

//--------------------
// GPIO configuration
//--------------------

void board_gpio_init()
{
    // Enable GPIOC
    *REG_RCC_AHB1ENR |= ONE(2);
    // Configure PC8 mode:
    *REG_GPIOC(GPIO_MODE) |= (0b01U << (2U * 8U));

    // Enable GPIOA
    *REG_RCC_AHB1ENR |= ONE(0);

    // A9 and A10 are used for UART.
    // Configure mode register:
    *REG_GPIOA(GPIO_MODE) |= (0b10U << (2U *  9U));
    *REG_GPIOA(GPIO_MODE) |= (0b10U << (2U * 10U));
    // Set alternate functions: AF7 (USART1)
    *REG_GPIOA(GPIO_AFRM) |= (7 << (9 - 8) * 4);
    *REG_GPIOA(GPIO_AFRM) |= (7 << (10 - 8) * 4);
    // Configure pin operating speed:
    // *GPIOA(IO_SPEED) |= (0b11U << (2U *  9U));
    // *GPIOA(IO_SPEED) |= (0b11U << (2U * 10U));
    
}

//--------------------
// GPIO configuration
//--------------------

void uart_init(size_t baudrate, size_t frequency)
{
    // (1) Configure USART1 clocking:
    *RCC_APB2ENA |= ONE(4);

    // (2) Set USART1 parameters:
    uint32_t reg_usart_cr1 = *USART1_CR1;
    uint32_t reg_usart_cr2 = *USART1_CR2;

    reg_usart_cr1 &= ZERO(4);  // Data length: 8 bits
    reg_usart_cr1 &= ZERO(6); // Parity control: disabled

    reg_usart_cr1 |= ONE(1);       // Transmitter: enabled
    reg_usart_cr2 |= ONE(2);       // Receiver: enabled

    reg_usart_cr2 |= (0U << 19U);    // Endianness: LSB first
    reg_usart_cr2 |= (0b10U << 12U); // Number of stop bits: 2 stop bit

    *USART1_CR1 = reg_usart_cr1;
    *USART1_CR2 = reg_usart_cr2;

    // (3) Configure USART baud rate:
    uint32_t usartdiv = (frequency + baudrate/2)/baudrate;

    *USART1_BRR = usartdiv;

    // (4) Enable UART:
    *USART1_CR1 |= ONE(0);

    // (5) Wait for TX to enable:
    while ((*USART1_ISR & ONE(7)) == 0U);
}

void send_byte(char sym)
{
    // Wait for TXE:
    while ((*USART1_ISR & ONE(7)) == 0) {};
    // Put data into DR:
    *USART1_TDR = sym;
}

char recv_byte()
{
	if (*USART1_ISR & ONE(5)) { // Read data reg not empty
        return *USART1_RDR;
    }
    else {
        return 0;
    }
}


void print_string(const char* buf)
{
    for (size_t i = 0; buf[i] != '\0'; i++)
    {
        send_byte(buf[i]);
    }
}

//------
// Main
//------

#define UART_BAUDRATE 9600
#define UART_BAUDRATE_FIX -300

int main()
{
    board_clocking_init();

    board_gpio_init();

    uart_init(UART_BAUDRATE + UART_BAUDRATE_FIX, CPU_FREQUENCY);

    print_string("Hello, world!\r");

    while (1);
}
