[org 0x7c00] ; org directive

xor ax, ax
mov ds, ax
mov es, ax

mov ah, 0x0e

mov al, secret_char
int 0x10

mov al, ':'
int 0x10

mov al, [secret_char]
int 0x10

mov al, ':'
int 0x10

xor bx, bx
mov bx, secret_char
mov al, [bx]
int 0x10

mov al, ':'
int 0x10

mov al, [0x7c2d]
int 0x10

jmp $

secret_char:
db "X"

times 510-($-$$) db 0

dw 0xaa55
