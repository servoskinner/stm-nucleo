#pragma once

#include <stdint.h>
#include <IO.h>
#include <systick.h>

struct button_entry {
    uint8_t gpio;
    uint8_t pin;
    uint8_t debouncing_saturation;
    uint8_t state;
    void (*callback)(uint8_t, uint8_t);
};

// Initializes button subsystem
void _button_init();
// Processes all buttons
void _button_process(uint8_t binding_id);
// Registers a button
uint8_t button_add(uint8_t gpio, uint8_t pin, void (*callback)(uint8_t));
// Removes a button
void button_rm(uint8_t id);
// Fetches debounced button state
uint8_t button_read(uint8_t id);