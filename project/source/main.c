#include <F401RE.h>
#include <constants.h>

#include <clock.h>
#include <systick.h>
#include <IO.h>

void init();
void loop();

int main()
{
    _clock_init(CPU_FREQUENCY);
    _systick_init(SYSTICK_RATE_US);

    init();

	while(1) {
        loop();
    }
}
