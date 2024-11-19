#include <F401RE.h>
#include <constants.h>
#include <setup.h>
#include <systick.h>

void blinker()
{
    *GPIOA(IO_OUTPUT) ^= ONE(5); // flip
}

int main()
{
    setup_clock(CPU_FREQUENCY);
    setup_gpio();
    setup_systick(SYSTICK_RATE_US);

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
