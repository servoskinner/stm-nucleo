#include <dispchar.h>

void dispchar(uint8_t gpio, uint8_t chr) {
    if (chr > 15) {
        chr = 15;
    }
    uint16_t gpio_state = io_gread(gpio);
    gpio_state &= ~MASK(8);
    gpio_state |= seg_chars[chr];

    io_gwrite(gpio, gpio_state);
}