section .data
myVector: times 16 dd 1 ;dd: dobleword
myVectorLength: equ $ - myVector
section .text
global _start

_start:

    jmp sumVector
;1) Usé dd para double word, recordemos que una palabra son 16 bits!
sumVector:
    push rbp
    mov rbp, rsp                    ;Stack aligned
    xor eax, eax                    ;Counter <- 0
    mov ecx, myVectorLength >> 2    ; "iterator" -  Vector_size / 4 -> Cause every i-th number has a 32 bits (4 bytes) size.

            ;Memo: Just as left shifts are equivalent to multiplying a number by 2, right shifts are equivalent to dividing a number by 2.
    dec ecx
    add eax, [myVector] ;First element + eax
    .ciclo:
        mov edx, [myVector + ecx*4] ;Mov 4 bytes and then I add this value with rax -> Avoiding overflow
        add eax, edx
    loop .ciclo
    jmp fin

fin:
    pop rbp
    mov	eax, 1   
	int	0x80    

