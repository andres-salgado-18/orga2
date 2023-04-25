section .data
myVector: times 16 dd 1 ;dd: dobleword
myVectorLength: equ $ - myVector
section .text
global _start

_start:
    jmp sumStack


sumStack:
    ;Lo habia hecho de forma que solo se pusheara sin usar registro pero no funcionó (OJO)

    push rbp 
    mov rbp, rsp
    ;Memo: Ancho 8 bytes
    ; Enunciado item: Trabajar con 32 bits los push
    xor rdx, rdx
    mov ecx, myVectorLength >> 2 
    dec ecx
    .ciclo:  ; Guardo el valor en registro y luego lo pusheo
        mov edx, [myVector + 4*ecx]
        push rdx
    loop .ciclo
    mov edx, [myVector] ;Me falta uno para pushear
    push rdx




    mov ecx, myVectorLength >> 2  ;Cantidad de elementos pusheados? 16
    xor rsi, rsi
    .sum:
        pop rsi                ;Saco elemento y guarda en rsi
        add rax, rsi           ;Para luego sumar esto en rax, asi con todos
    loop .sum

    push rax                   ;Guardo el valor en el stack
;Use no volatiles, es decir da igual si los cambio
fin:
    pop rbp
    mov eax, 1   
	int	0x80    
