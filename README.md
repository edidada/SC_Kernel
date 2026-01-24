# A PERSONAL PROJECT CONTAINING A BOOT-LOADER AND A KERNEL IN DEVELOPMENT.

Custom bootloader and bare-metal kernel implementation for x86 architecture, built from scratch for learning OS development.

## Features

### Bootloader
- Custom 16-bit real mode bootloader
- GDT initialization and protected mode switching
- Disk reading via BIOS interrupts (INT 0x13)
- Loads kernel from disk sectors

### Kernel
- **IDT (Interrupt Descriptor Table)**: 48 entries (32 CPU exceptions + 16 IRQs)
- **PIC (8259)**: Remapped to interrupts 32-47
- **Interrupt Handlers**: Assembly stubs with C dispatcher
- **VGA Text Mode Driver**: 80x25 color text, scrolling, cursor control
- **PS/2 Keyboard Driver**: Scancode Set 1, ASCII translation, backspace/newline support

## Build & Run

### Requirements
- NASM assembler
- GCC (32-bit cross-compiler: `gcc-multilib`)
- GNU ld linker
- QEMU or KVM

### Commands
```bash
make run           # Boot with custom bootloader
make run-grub      # Not yet functional .. needs special grub handling!!
make clean         # Remove build artifacts
```
## Memory Layout
- Bootloader: `0x7C00` (BIOS loads here)
- Kernel: `0x1000` (custom bootloader) / `0x100000` (GRUB)
- VGA Text: `0xB8000`

## References
- [Bootloader](https://github.com/tpn/pdfs/blob/master/Writing%20a%20Simple%20Operating%20System%20from%20Scratch%20-%20Nick%20Blundell%20-%20Dec%202010.pdf)
- [OSDev Wiki](https://wiki.osdev.org/)
- [Intel® 64 and IA-32 Architectures Software Developer Manuals](https://www.intel.com/content/www/us/en/content-details/782158/intel-64-and-ia-32-architectures-software-developer-s-manual-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4.html)
- [Intel 8259A PIC Datasheet](https://pdos.csail.mit.edu/6.828/2014/readings/hardware/8259A.pdf)
- [PS/2 Keyboard Scancodes](https://wiki.osdev.org/PS/2_Keyboard)

## License
Educational project - use freely for learning purposes.
