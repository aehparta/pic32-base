
#include <proc/p32mz1024efg064.h>
#include <sys/types.h>

void init(void)
{
	/* ANSELx: digital or analog (not supported on all ports), 0 digital, 1 analog
	 * TRISx: direction, 0 output, 1 input
	 * ODCx: open drain, 0 disabled, 1 enabled
	 * CNENx: change notification, 0 disabled, 1 enabled
	 * CNPUx: pull up, 0 disabled, 1 enabled
	 * CNPDx: pull down, 0 disabled, 1 enabled
	 */

	/* port B */
	ANSELB = 0x0000;

	/* port D */
	TRISD = 0xffff;
	ODCD = 0x0000;
	CNEND = 0x0000;
	CNPUD = 0xffff;
	CNPDD = 0x0000;

	/* port E */
	ANSELE = 0x0000;

	/* port F */
	TRISF = 0xfffc;
	ODCF = 0x0000;
	CNENF = 0x0000;
	CNPUF = 0x0000;
	CNPDF = 0x0000;

	/* port G */
	ANSELG = 0x0000;
}

int main(void)
{
	uint16_t mask = (1 << 11);

	init();

	while (1) {
		PORTF ^= 1;
	}

	return 0;
}
