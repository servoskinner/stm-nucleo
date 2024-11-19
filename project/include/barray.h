#pragma once

#include <stdint.h>

typedef uint8_t* barray;

#define LEAST_MULTIPLE_OF_8(x) (((x) + 7) & ~7)
#define BARRAY(name, len) uint8_t name[LEAST_MULTIPLE_OF_8(len)]

// Sets one bit in a bit array.
void barray_set(barray data, uint32_t idx, uint8_t val);
// Gets one bit from a bit array.
uint8_t barray_get(barray data, uint32_t idx);
// Flips one bit in a bit array.
void barray_flip(barray data, uint32_t idx);




