[org 0x7c00]

mov bx, 50

;if (bx <= 4)
cmp bx, 4
jle first

;else if (bx < 40)
cmp bx, 40
jl second

;else 
jmp last

first:
	mov al, 'A'
	jmp end

second:
	mov al, 'B'
	jmp end
last:
	mov al,'C'

end:
mov ah , 0x0e ; int =10/ ah =0 x0e -> BIOS tele - type output
int 0x10 ; print the character in al

jmp $

; Padding and magic number.

times 510-($-$$) db 0

dw 0xaa55
