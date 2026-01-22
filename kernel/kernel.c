#include "../drivers/screen.h"
#include "low_level.h"
#include "idt.h"


void delay(unsigned int count) {
	for (volatile unsigned int i = 0; i < count; i++) {
		__asm__ __volatile__("nop");
	}
}


void main() {
	// Create a pointer to a char , and point it to the first text cell of
	// video memory (i.e. the top - left of the screen )
	// char* video_memory = (char *) 0xb8000;
	// At the address pointed to by video_memory , store the character ’X’
	// (i.e. display ’X’ in the top - left of the screen ).
	// *video_memory = 'X';
	u8 *test = "abcdefghij\nklmnopqrstuvwxyz\n123456789";
	u8 i = 0;


	clear_screen();
	PIC_remap(0x20, 0x28);
	idt_init();
	// u8 x = 1 / 0;
	// print_string("RONIN!!", (BLACK << 4) + DARK_GRAY);
	// print_string("lekher ajmi", (BLACK << 4) + YELLOW);
	// while(1) {
	// 	delay(10000000);
	// 	if (test[i] == '\0')
	// 		i = 0;
	// 	print_char(test[i], WHITE_ON_BLACK);
	// 	i++;
	// }
	//port_byte_out(REG_SCREEN_CTRL, 14);
	//port_byte_out(REG_SCREEN_DATA, 0x00);
	//port_byte_out(REG_SCREEN_CTRL, 15);
	//port_byte_out(REG_SCREEN_DATA, 0x50);
}
