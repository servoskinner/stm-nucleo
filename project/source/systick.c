#include <setup.h>
#include <systick.h>

struct systick_binding systick_list[255] = {0};
char systick_nvacant = 255;
char systick_occupied[255] = {0};

void setup_systick(uint32_t period_us)
{
    // Systick clock is divided by 8.
    uint32_t reload_value = period_us * ONE_MILLISECOND / 8 / 1000;

    // set reload value
    *SYSTICK_RVR = (reload_value - 1U) & MASK(24);
    // clear current value
    *SYSTICK_CVR = 0U;
    // set clock source
    *SYSTICK_CTRL = 0b111U;
}

void systick_handler() {
    char entries_processed = 0;
    for (int i = 0; i < 255; i++) {
        if (entries_processed == 255 - systick_nvacant) {
            break; // All entries processed, don't scan further
        }
        if (systick_occupied[i]) {
            struct systick_binding binding = systick_list[i];
            // Trigger callback and reset countown if it
            // reached zero
            if (binding.countdown == 0) {
                binding.callback();
                systick_list[i].countdown = binding.period;
            }
            systick_list[i].countdown--;
            entries_processed++;
        }
    }
}

char systick_add_listener(struct systick_binding binding) {
    // Check that there are subscription slots available
    if (systick_nvacant == 0) {
        return 0;
    }
    // Find first vacant binding id
    char vacant_binding_id;
    for (int i = 0; i < 255; i++) {
        if (!systick_occupied[i]) {
            vacant_binding_id = i;
            break;
        }
    }
    // Put callback data in table
    systick_list[vacant_binding_id] = binding;
    systick_occupied[vacant_binding_id] = 1;
    systick_nvacant--;
    return vacant_binding_id + 1;
}

void systick_rm_listener(char id) {
    if (systick_occupied[id - 1]) {
        systick_nvacant++;
    }
    systick_occupied[id - 1] = 0;
}