#pragma once

#include <IO.h>
#include <stdint.h>

struct button_entry {
    struct gpio_pin pin;
    uint8_t debouncing_saturation;
    uint8_t state;
    void (*callback)(uint8_t);
};

// Initializes button subsystem
void _button_init();
// Processes all buttons
void _button_process();
// Registers a button
void button_add(void (*callback)(uint8_t), uint8_t id);
// Removes a button
void button_rm(uint8_t id);
// Fetches debounced button state
uint8_t button_read(uint8_t id);