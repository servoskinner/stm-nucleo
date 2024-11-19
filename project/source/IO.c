#include <F401RE.h>
#include <IO.h>

uint8_t _gpio_disabled[5]; // Filled with 0xFF

void io_enable(uint8_t gpio) {
    if (gpio > 4) {
        return;
    }
    *REG_RCC_AHB1ENR |= ONE(gpio);
    _gpio_disabled[gpio] = 0U;
}

void io_disable(uint8_t gpio) {
    if (gpio > 4) {
        return;
    }
    *REG_RCC_AHB1ENR &= ZERO(gpio);
    _gpio_disabled[gpio] = 1U;
}

uint8_t io_clock_status(uint8_t gpio) {
    if (gpio > 4) {
        return 0U;
    }
    return !_gpio_disabled[gpio];
}

void io_mode(uint8_t gpio, uint8_t pin, uint8_t mode) {
    if (gpio > 4U || pin > 16U || mode > 3U) {
        return;
    }
    if (_gpio_disabled[gpio]) { // Clock up GPIO if not enabled
        io_enable(gpio);
    }
    uint32_t mask = 0b11 << 2 * pin;
    uint32_t value = (uint32_t)mode << 2U * pin;

    volatile uint32_t *reg = (volatile uint32_t*)(REG_GPIO_ORIGIN + REG_GPIO_SPACING * gpio + GPIO_MODE);
    
    *reg = (*reg & ~mask) | value;
}

void io_type(uint8_t gpio, uint8_t pin, uint8_t type) {
    if (gpio > 4U || pin > 16U || type > 1U) {
        return;
    }
    if (_gpio_disabled[gpio]) { // Clock up GPIO if not enabled
        io_enable(gpio);
    }
    uint32_t mask = 0b1U << pin;
    uint32_t value = (uint32_t)type << pin;

    volatile uint32_t *reg = (volatile uint32_t*)(REG_GPIO_ORIGIN + REG_GPIO_SPACING * gpio + GPIO_TYPE);
    
    *reg = (*reg & ~mask) | value;
}

void io_write(uint8_t gpio, uint8_t pin, uint8_t value) {
    if (gpio > 4U || pin > 15U) {
        return;
    }
    volatile uint32_t *reg = (volatile uint32_t*)(REG_GPIO_ORIGIN + REG_GPIO_SPACING * gpio + GPIO_OUTPUT);

    if (value) {
        *reg |= ONE(pin);
    }
    else {
        *reg &= ZERO(pin);
    }
}

void io_flip(uint8_t gpio, uint8_t pin) {
    if (gpio > 4 || pin > 15U) {
        return;
    }
    volatile uint32_t *reg = (volatile uint32_t*)(REG_GPIO_ORIGIN + REG_GPIO_SPACING * gpio + GPIO_OUTPUT);

    *reg ^= ONE(pin);
}

uint8_t io_read(uint8_t gpio, uint8_t pin) {
    if (gpio > 4U || pin > 15U) {
        return 0U;
    }
    volatile uint32_t *reg = (volatile uint32_t*)(REG_GPIO_ORIGIN + REG_GPIO_SPACING * gpio + GPIO_INPUT);

    uint32_t masked = *reg & ONE(pin);
    return (uint8_t)(masked >> pin);
}

void io_gwrite(uint8_t gpio, uint16_t value) {
    if (gpio > 4U) {
        return;
    }
    volatile uint32_t *reg = (volatile uint32_t*)(REG_GPIO_ORIGIN + REG_GPIO_SPACING * gpio + GPIO_OUTPUT);
    *reg = (uint32_t)value;
}

uint16_t io_gread(uint8_t gpio) {
    if (gpio > 4U) {
        return 0U;
    }
    volatile uint32_t *reg = (volatile uint32_t*)(REG_GPIO_ORIGIN + REG_GPIO_SPACING * gpio + GPIO_INPUT);
    return (uint16_t)*reg;
}