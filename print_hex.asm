;[org 0x7c00]

;mov dx , 0x1fb6 ; store the value to print in dx

;mov bx, HEX_OUT ; print the string pointed to

;call print_hex ; call the function
;jmp continue

; prints the value of DX as hex.

print_hex :
; TODO -> manipulate chars at HEX_OUT to reflect DX
	pusha		; pushing all the registers to the stack for later retrieval of thier original values.
	xor ax, ax	; clearing any garbage value in ax.
	mov ax, 5	; setting ax to 5.

	hex_loop:		; our hex loop to store the hex values.
		mov cx, dx	; cpying the value of dx to cx to mask out only the char (4-bits) value.
		and cx, 0xf	; masking ah and the high 4 bits of al to get only the last 4-bits.

		add bx, ax	; moving the address pointer of bx to the last char to convert.
		cmp cl, 0xa	; checking if that byte if it's a number or letter.
		jl conv_num	; converting to number.
		add cl, 0x27	; converting to letter; 0x27 + 0x30 + the letter value = the hex ascii code value of that letter.

	conv_num:			; function to finish converting and store the ascii code in the template HEX_OUT.
		add cl, 0x30		; adding 0x30, if it's a number.
		mov byte [bx], cl	; storing the byte we converted into the template at [bx+ax].
		shr dx, 4		; shifting to the right to convert the next char.
		sub bx, ax		; substracting bx address pointer to reset it to the start of the template.
		dec ax			; decrementing ax to write to the next byte in the template.
		cmp al, 0x2		; checking if we wrote 4 char. as we need only to write 4 chars.
		jl hex_return		; if al < 2 return.
		jmp hex_loop		; if not continue looping.

	hex_return:			; return function.
		popa			; poping the saved registers values from the stack to the registers. restoring the original values.
		ret			; returning to the next address after the call.

;continue:

;%include "print_string.asm"

;call print_string ; by BX

;ret

; global variables

;HEX_OUT : db '0x0000' ,0

;jmp $

; Padding and magic BIOS number.

;times 510-($-$$) db 0

;dw 0xaa55

