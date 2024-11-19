#pragma once

#include <stdint.h>

#define CPU_FREQUENCY 32000000 // TRUE and HONEST CPU frequency: 32 MHz
#define ONE_MICROSECOND (CPU_FREQUENCY/1000000U)

#define SYSTICK_RATE_US 1000