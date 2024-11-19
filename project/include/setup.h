#pragma once

#include <constants.h>
#include <F401RE.h>

// Board clock setup
void setup_clock(uint32_t freq_hz);
// Systick setup
void setup_systick(uint32_t period_us);


