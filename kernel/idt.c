#include "../drivers/screen.h"
#include "idt.h"

static bool vectors[IDT_MAX_DESCRIPTORS];

extern void* isr_stub_table[];

// general exception handler
void	exception_handler(void) {
	print_string("ERROR: DIVIDING BY ZERO!!", (BLACK << 4) + RED);
	__asm__ volatile ("cli; hlt"); // completely hangs the computer
}

void	idt_set_descriptor(u8 vector, void* isr, u8 flags) {
	idt_entry_t* descriptor = &idt[vector];

	descriptor->isr_low = (u32)isr & 0xFFFF;
	descriptor->kernel_cs = 0x08;
	descriptor->reserved = 0;
	descriptor->attributes = flags;
	descriptor->isr_high = (u32)isr >> 16;
}

void	idt_init(void) {
	idtr.base = (u32)&idt[0];
	idtr.limit = (u16)sizeof(idt_entry_t) * IDT_MAX_DESCRIPTORS - 1;

	for (u8 vector = 0; vector < 32; vector++) {
		idt_set_descriptor(vector, isr_stub_table[vector], 0x8E);
		vectors[vector] = true;
	}

	__asm__ volatile ("lidt %0" : : "m"(idtr)); // loading the new IDT;
	__asm__ volatile ("sti"); // enabling interrupts by setting the interrupt flag
}
