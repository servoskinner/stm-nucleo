#pragma once

#include <stdint.h>

#include <constants.h>
#include <F401RE.h>

// Board clock setup
void _clock_init(uint32_t freq_hz);
// Systick setup
void _systick_init(uint32_t period_us);


