#include <button.h>

volatile struct button_entry _buttons[31];
volatile uint8_t _button_nvacant = 31;
volatile BARRAY(_button_vacant, 31);

void _button_init() {
    struct systick_binding check_buttons;

    check_buttons.period = 10U;
    check_buttons.callback = _button_process;

    systick_add_listener(check_buttons);
}

void _button_process() {
    for (int i = 0; i < 31; i++) {
        if(!barray_get(_button_vacant, i)) {
            struct button_entry entry = _buttons[i];
            uint8_t pin_state = io_read(entry.gpio, entry.pin);
            if (pin_state != entry.state) {
                _buttons[i].debouncing_saturation++;
            }
            else {
                _buttons[i].debouncing_saturation = 0;
            }
            if (_buttons[i].debouncing_saturation == BUTTON_DEBOUNCING_THRES) {
                uint8_t new_state = !entry.state;
                _buttons[i].state = new_state;
                _buttons[i].debouncing_saturation = 0;
                _buttons[i].callback(new_state);
            }
        }
    }
}

uint8_t button_add(uint8_t gpio, uint8_t pin, void (*callback)(uint8_t)) {
    if (_button_nvacant == 0) {
        return 0;
    }
    // Find first vacant binding id
    uint8_t vacant_binding_id;
    for (int i = 0; i < 255; i++) {
        if (barray_get(_button_vacant, i)) {
            vacant_binding_id = i;
            break;
        }
    }
    // Put callback data in table
    struct button_entry new_entry;
    new_entry.debouncing_saturation = 0;

    new_entry.gpio = gpio;
    new_entry.pin = pin;
    io_mode(gpio, pin, MODE_INPUT);
    new_entry.state = io_read(gpio, pin);

    new_entry.callback = callback;

    _buttons[vacant_binding_id] = new_entry;
    barray_set(_button_vacant, vacant_binding_id, 0U);
    _button_nvacant--;

    return vacant_binding_id + 1;
}

void button_rm(uint8_t id) {
    if (!barray_get(_button_vacant, id)) {
        _button_nvacant++;
    }
    barray_set(_button_vacant, id, 0U);
}

uint8_t button_read(uint8_t id){
    if (barray_get(_button_vacant, id)) {
        return 0U;
    }
    return _buttons[id].state;
}