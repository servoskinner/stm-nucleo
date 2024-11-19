#include <IO.h>
#include <button.h>
#include <systick.h>

void blinker(uint8_t id, uint8_t state)
{
    if(state) {
        io_flip(GPIOA, 5);
        button_rm(id);
    }
}

void init() 
{
    io_mode(GPIOA, 5, MODE_OUTPUT);
    button_add(GPIOC, 13, blinker);

    struct systick_binding blink;
    blink.period = 100;
}

void loop()
{ 
    return;
} 