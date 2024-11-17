#include <stdint.h>
#include <stddef.h>


#include "../F401RE.h"


// UART Registers___________________________________________________

#define USART1_CR1 (volatile uint32_t*)(uintptr_t)0x40013800U // Control register 1
#define USART1_CR2 (volatile uint32_t*)(uintptr_t)0x40013804U // Control register 2
#define USART1_BRR (volatile uint32_t*)(uintptr_t)0x4001380CU // Baud rate register
#define USART1_ISR (volatile uint32_t*)(uintptr_t)0x4001381CU // Interrupt and status register
#define USART1_TDR (volatile uint32_t*)(uintptr_t)0x40013828U // Transmit data register

// RCC configuration_______________________________________________

#define CPU_FREQUENCY 48000000U // CPU frequency: 48 MHz
#define ONE_MILLISECOND CPU_FREQENCY/1000U

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

//--------------------
// GPIO configuration
//--------------------

void board_gpio_init()
{
    // Enable GPIOC
    *RCC_AHB1ENA |= ONE(2);
    // Configure PC8 mode:
    *GPIOC(IO_MODE) |= (0b01U << (2U * 8U));
    // Configure PC8 type:
    *GPIOC(IO_TYPE) |= (0U << 8U);

    // Enable GPIOA
    *RCC_AHB1ENA |= ONE(0);

    // Set alternate functions:
    *GPIOA(IO_AFRH) |= 
    *GPIOA(IO_AFRH) |= 
    // Configure pin operating speed:
    *GPIOA(IO_SPEED) |= (0b11U << (2U *  9U));
    *GPIOA(IO_SPEED) |= (0b11U << (2U * 10U));
    // Configure mode register:
    *GPIOA(IO_MODE) |= (0b10U << (2U *  9U));
    *GPIOA(IO_MODE) |= (0b10U << (2U * 10U));
}

//--------------------
// GPIO configuration
//--------------------

void uart_init(size_t baudrate, size_t frequency)
{
    // (1) Configure USART1 clocking:
    *RCC_APB2ENA |= (1U << 14U);
    *RCC_CFG     |= 0b00U; //CFGR3

    // (2) Set USART1 parameters:
    uint32_t reg_usart_cr1 = 0U;
    uint32_t reg_usart_cr2 = 0U;

    reg_usart_cr1 |= 0x00000000U;  // Data length: 8 bits
    reg_usart_cr1 |=  (0U << 15U); // Use oversampling by 16
    reg_usart_cr1 &= ~(1U << 10U); // Parity control: disabled
    reg_usart_cr1 |=  (1U <<  3U); // Transmitter: enabled

    reg_usart_cr2 |= (0U << 19U);    // Endianness: LSB first
    reg_usart_cr2 |= (0b10U << 12U); // Number of stop bits: 2 stop bit

    *USART1_CR1 = reg_usart_cr1;
    *USART1_CR2 = reg_usart_cr2;

    // (3) Configure USART baud rate:
    uint32_t usartdiv = (frequency + baudrate/2)/baudrate;

    *USART1_BRR = usartdiv;

    // (4) Enable UART:
    *USART1_CR1 |= (1U << 0U);

    // (5) Wait for TX to enable:
    while ((*USART1_ISR & (1U << 21U)) == 0U);
}

void send_byte(char sym)
{
    // Wait for TXE:
    while ((*USART1_ISR & (1U <<  7U)) == 0U);

    // Put data into DR:
    *USART1_TDR = sym;
}

char recv_byte()
{
	return '\0';
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
