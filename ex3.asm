[org 0x7c00]



mov bx, HELLO_MSG
call print_string

mov bx/recruiter/billingy now , GOODBYE
call print_string


jmp $

%include "print_string.asm"

; Data
HELLO_MSG:
	db 'Hello, World! ', 0x00 ; null terminated string stored in the label offset Hello_msg

GOODBYE:
	db 'Goodbye!', 0x00

; padding and magic nuber
times 510-($-$$) db 0
dw 0xaa55
