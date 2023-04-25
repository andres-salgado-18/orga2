section .data
myVector: times 16 dd 1 ;dd: dobleword
myVectorLength: equ $ - myVector
section .text
global _start

_start:

    jmp sumVector64


;2
; a) Para leerlos lo hice con edx, el cual tiene 32 bits
; lo cual me permitió luego sumar todo el registro con rax y asi evitar posibles ov
; b) 

sumVector64:
    push rbp
    mov rbp, rsp                        ;Alinear
    xor rax, rax                        ;Counter <- 0
    mov ecx, myVectorLength >> 2        ;iterator <- Size / 4
        ;Memo: Just as left shifts are equivalent to multiplying a number by 2, right shifts are equivalent to dividing a number by 2.
    dec ecx
    add eax, [myVector]   ;V[o] + eax
    .ciclo:
        mov edx, [myVector + ecx*4]
        add rax, rdx
    loop .ciclo
    mov r8, rax         ;r8 <-- result
    jmp fin

;c) Evito casos de overflow
;d) Debería limpiar los registros sino la suma se hará erroneamente, por ej en casos de un carry u overflow

fin:
    pop rbp
    mov	eax, 1   
	int	0x80    
