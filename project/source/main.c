#include <F401RE.h>
#include <constants.h>

#include <clock.h>
#include <systick.h>
#include <button.h>
#include <IO.h>

void init();
void loop();

int main()
{
    _clock_init(CPU_FREQUENCY);
    _systick_init(SYSTICK_RATE_US);
    _button_init();

    init();

	while(1) {
        loop();
    }
}
