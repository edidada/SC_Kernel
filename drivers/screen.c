#include "screen.h"

void	clear_screen(void) {
	u16 *video = (u16 *)VIDEO_ADDRESS;
	u16 blank = 0x0F20;

	for (u16 i = 0; i < 2000; i++) {
		video[i] = blank;
	}
}

void	print_char(u8 c) {
	volatile u8 *video = (volatile u8 *)VIDEO_ADDRESS;

	*video++ = c;
	*video++ = WHITE_ON_BLACK;
	return ;
}
