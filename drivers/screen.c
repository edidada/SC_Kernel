#include "screen.h"

static u8	c_rows = 0;
static u8	c_cols = 0;

void	clear_screen(void) {
	u16 *video = (u16 *)VIDEO_ADDRESS;
	u16 blank = 0x0F20;

	c_rows = 0;
	c_cols = 0;
	move_cursor(0);

	for (u16 i = 0; i < VGA_MAX_CHAR; i++) {
		video[i] = blank;
	}
}

void	print_char(u8 c, u8 color) {
	volatile u8 *video = (volatile u8 *)VIDEO_ADDRESS + (c_rows * MAX_COLS + c_cols) * 2;

	*video++ = c;
	*video = color;
	c_cols++;
	if (c_cols >= MAX_COLS) {
		c_cols = 0;
		c_rows++;
		if (c_rows >= MAX_ROWS) {
			c_rows--;
			scroll_screen();
		}
	}
	move_cursor((c_rows * MAX_COLS + c_cols));
}

void	print_string(u8 *str, u8 color) {
	//volatile u8 *video = (volatile u8 *)VIDEO_ADDRESS + (c_rows * MAX_COLS + c_cols);

	while (*str != '\0') {
		print_char(*str, color);
		*str++;
		//*video++ = *str++;
		//*video++ = color;
	}
}

void	scroll_screen(void) {
	for (u8 i = 1; i < MAX_ROWS; i++){
		mem_move(((u16 *)VIDEO_ADDRESS + ((i - 1) * MAX_COLS)), ((u16 *)VIDEO_ADDRESS + i * MAX_COLS), MAX_COLS);
	}
}

void	mem_move(u16 *dst, u16 *src, u8 len) {
	u8 i = 0;
	while (i < len * 2) {
		dst[i] = src[i];
		i++;
	}	
}
