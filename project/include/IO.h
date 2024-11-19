#pragma once

#include <stdint.h>
#include <barray.h>

#include <constants.h>
#include <F401RE.h>

#define GPIOA 0
#define GPIOB 1
#define GPIOC 2
#define GPIOD 3
#define GPIOE 4

#define MODE_INPUT  0
#define MODE_OUTPUT 1
#define MODE_ALT    2
#define MODE_ANALOG 3

struct gpio_pin {
    uint8_t gpio;
    uint8_t pin;
};

// Clock up GPIO group
void io_enable(uint8_t gpio);
// Clock down GPIO group
void io_disable(uint8_t gpio);
// Check wheter gpio is clocked up
uint8_t io_clock_status(uint8_t gpio);

// Set pin mode
void io_mode(uint8_t gpio, uint8_t pin, uint8_t mode);

#define TYPE_PUSHPULL  0
#define TYPE_OPENDRAIN 1
// Set pin type
void io_type(uint8_t gpio, uint8_t pin, uint8_t type);

// Write to a single GPIO pin
void io_write(uint8_t gpio, uint8_t pin, uint8_t value);
// Flip a single GPIO pin
void io_flip(uint8_t gpio, uint8_t pin);
// Read from a single GPIO pin
uint8_t io_read(uint8_t gpio, uint8_t pin);

// Write to GPIO group
void io_gwrite(uint8_t gpio, uint16_t value);
// Read from a GPIO group
uint16_t io_gread(uint8_t gpio);


