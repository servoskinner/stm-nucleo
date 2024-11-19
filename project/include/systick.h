#pragma once

#include <F401RE.h>
#include <constants.h>

struct systick_binding {
    uint32_t countdown;
    uint32_t period;
    void (*callback)(void);
};

// Systick handler
void systick_handler();
// Add systick listener
char systick_add_listener(struct systick_binding binding);
// Remove systick listener
void systick_rm_listener(char id);
