#include <barray.h>

void barray_set(volatile uint8_t *data, uint32_t idx, uint8_t val) {
    uint32_t bit = idx / 8;
    uint32_t offset = idx % 8;

    if(val) {
        data[bit] |= (0b1 << offset);
    }
    else {
        data[bit] &= ~(0b1 << offset);
    }
}

uint8_t barray_get(volatile uint8_t *data, uint32_t idx) {
    uint32_t bit = idx / 8;
    uint32_t offset = idx % 8;

    uint8_t mask = 0b1 << offset;
    return (data[bit] & mask) >> offset;
}

void barray_flip(volatile uint8_t *data, uint32_t idx) {
    uint32_t bit = idx / 8;
    uint32_t offset = idx % 8;

    data[bit] ^= 0b1 << offset;
}