#include <F401RE.h>
#include <constants.h>

#include <setup.h>
#include <systick.h>
#include <io.h>

void blinker()
{
    io_flip(GPIOA, 5);
}

int main()
{
    setup_clock(CPU_FREQUENCY);
    setup_systick(SYSTICK_RATE_US);

    io_mode(GPIOA, 5, MODE_OUTPUT);

    struct systick_binding blinker_binding;
    blinker_binding.countdown = 0U;
    blinker_binding.period = 10000U;
    blinker_binding.callback = blinker;

    systick_add_listener(blinker_binding);

	while(1) 
    {
        __asm__ volatile("nop");
    }
}
