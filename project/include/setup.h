#pragma once

#include <constants.h>
#include <F401RE.h>

// Board clock setup
void setup_clock(uint32_t freq_hz);
// GPIO Setup
void setup_gpio();
// Systick setup
void setup_systick(uint32_t period_us);


