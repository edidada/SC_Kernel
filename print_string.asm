; this is a function to print a null terminated string

print_string:
	pusha
	mov ah, 0x0e ; setting the BIOS tele-type 10/0e = 0eh to move the cursor  step after printing.
	loop:
;		lodsb
		mov al, [bx]
		cmp al, 0x00
		je return
		int 0x10
		inc bx
		jmp loop
return:
	popa
	ret
