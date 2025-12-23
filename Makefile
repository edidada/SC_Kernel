# automatically generate lists of sources using wildcards.
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

# Default build target
all: os-image

# Run kvm/qemu to simulate booting of our code.
run : all
	kvm -drive format=raw,file=os-image
	#qemu-system-x86_64 -drive format=raw,file=os-image

# This is the actual disk image that the computer loads ,
# which is the combination of our compiled bootsector and kernel.
os-image : boot/boot_sector.bin kernel.bin
	truncate -s 7680 kernel.bin	# padding the kernel.bin file to 15 sectors as we read 15 sectors in our boot/disk_load.asm routine.
	cat $^ > os-image

# This builds the binary of our kernel from two object files :
# - the kernel_entry , which jumps to main() in our kernel
# - the compiled C kernel
kernel.bin : kernel/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# Generic rule for compiling C code to an object file
# For simplicity , we C files depend on all header files.
%.o : %.c ${HEADERS}
	gcc -m32 -fno-pic -fno-pie -ffreestanding -c $< -o $@

# Assemble the kernel_entry.
%.o : %.asm
	nasm $< -f elf -o $@

# Assemble the boot sector to raw machine code
# The -I options tells nasm where to find our useful assembly
# routines that we include in boot_sector.asm
%.bin : %.asm
	nasm $< -f bin -I 'boot/' -o $@

# Clear away all generated files .
clean :
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o

# Disassemble our kernel - might be useful for debugging.
kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@
