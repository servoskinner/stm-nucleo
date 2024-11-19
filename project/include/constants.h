#pragma once

#include <stdint.h>

// Clock
#define CPU_FREQUENCY 32000000 // TRUE and HONEST CPU frequency: 32 MHz
#define ONE_MICROSECOND (CPU_FREQUENCY/1000000U)

// Systick
#define SYSTICK_RATE_US 100

// Button
#define BUTTON_DEBOUNCING_THRES 8