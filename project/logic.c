#include <IO.h>
#include <systick.h>

void blinker()
{
    io_flip(GPIOA, 5);
}

void init() 
{
    io_mode(GPIOA, 5, MODE_OUTPUT);

    struct systick_binding binding;
    binding.period = 10000U;
    binding.callback = blinker;

    systick_add_listener(binding);
}

void loop()
{ 
    return;
} 