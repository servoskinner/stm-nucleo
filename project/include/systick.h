#pragma once

#include <stdint.h>

#include <barray.h>
#include <F401RE.h>
#include <constants.h>

struct systick_binding {
    uint32_t countdown;
    uint32_t period;
    void (*callback)(void);
};

// Systick setup
void _systick_init(uint32_t period_us);
// Systick handler
void systick_handler();
// Add systick listener
uint8_t systick_add_listener(struct systick_binding binding);
// Remove systick listener
void systick_rm_listener(uint8_t id);