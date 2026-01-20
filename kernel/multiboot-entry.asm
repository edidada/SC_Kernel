MBALIGN  equ  1 << 0            ; align modules on page boundaries
MEMINFO  equ  1 << 1            ; provide memory map
FLAGS    equ  MBALIGN | MEMINFO ; multiboot flags
MAGIC    equ  0x1BADB002        ; multiboot magic number
CHECKSUM equ -(MAGIC + FLAGS)   ; checksum of above

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .text
global _start
_start:
    ; Set up stack
    mov esp, stack_top
    
    ; Call kernel
    extern main
    call main
    
    ; Hang if kernel returns
    cli
    hlt

section .bss
align 16
stack_bottom:
    resb 16384  ; 16 KB stack
stack_top:
