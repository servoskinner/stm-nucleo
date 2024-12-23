#include <systick.h>

volatile struct systick_binding _systick_list[255];
volatile uint8_t _systick_nvacant = 255;
volatile BARRAY(_systick_vacant, 255); // Filled with 0xFF

void _systick_init(uint32_t period_us)
{
    // Systick clock is divided by 8.
    uint32_t reload_value = period_us * ONE_MICROSECOND / 8;
    // set reload value
    *REG_SYSTICK_RVR = (reload_value - 1U) & MASK(24);
    // clear current value
    *REG_SYSTICK_CVR = 0U;
    // set clock source
    *REG_SYSTICK_CTRL = 0b111U;
}

void _systick_handler() {
    uint8_t entries_processed = 0;
    for (uint8_t i = 0; i < 255; i++) {
        if (entries_processed == 255 - _systick_nvacant) {
            break; // All entries processed, don't scan further
        }
        if (!barray_get(_systick_vacant, i)) {
            struct systick_binding binding = _systick_list[i];
            // Trigger callback and reset countown if it
            // reached zero
            if (binding.countdown == 0) {
                binding.callback(i + 1);
                _systick_list[i].countdown = binding.period;
            }
            _systick_list[i].countdown--;
            entries_processed++;
        }
    }
}

uint8_t systick_add(struct systick_binding binding) {
    // Check that there are subscription slots available
    if (_systick_nvacant == 0) {
        return 0;
    }
    // Find first vacant binding id
    uint8_t vacant_binding_id;
    for (uint8_t i = 0; i < 255; i++) {
        if (barray_get(_systick_vacant, i)) {
            vacant_binding_id = i;
            break;
        }
    }
    // Put callback data in table
    _systick_list[vacant_binding_id] = binding;
    barray_set(_systick_vacant, vacant_binding_id, 0U);
    _systick_nvacant--;
    
    return vacant_binding_id + 1;
}

void systick_rm(uint8_t id) {
    if (id != 0) {
        if (!barray_get(_systick_vacant, id - 1)) {
            _systick_nvacant++;
        }
        barray_set(_systick_vacant, id - 1, 1U);
    }
}