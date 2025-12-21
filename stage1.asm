; the BIOS scrolling teletype routine(ah = 0eh), which will print a single character on the screen and advance the cursor,
; ready for the next character. , the character to print is stored in al;


; Here, we
; need interrupt 0x10 and to set ah to 0x0e (to indicate tele-type mode) and al to the
; ASCII code of the character we wish to print.

mov ah, 0x0e ; int 10/0e = 0eh -> scrolling teletype BIOS routine

mov al, 'R'
int 0x10

mov al, 'O'
int 0x10

mov al, 'N'
int 0x10

mov al, 'I'
int 0x10

mov al, 'N'
int 0x10

jmp $ 

; Padding and magic BIOS number.

times 510-($-$$) db 0

dw 0xaa55




; assembling:
;	nasm stage1.asm -f bin -o stage1.bin

; the binary content of the file:
;	od -t x1 -A n stage1.bin
