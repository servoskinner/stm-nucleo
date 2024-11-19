#include <IO.h>
#include <button.h>
#include <systick.h>

void blinker(uint8_t state)
{
    if(!state) {
        io_flip(GPIOA, 5);
    }
}

void init() 
{
    io_mode(GPIOA, 5, MODE_OUTPUT);

    button_add(GPIOC, 13, blinker);
}

void loop()
{ 
    return;
} 