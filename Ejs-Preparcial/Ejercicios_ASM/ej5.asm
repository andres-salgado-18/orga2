section .data
myVector: times 16 dd 1 ;dd: dobleword
myVectorLength: equ $ - myVector
section .text
global _start

_start:
    push rbp
    mov rbp, rsp
    jmp llamadora  ;Salto a llamadora

llamadora:
    call invocada  ; Llamo a invocada
    jmp fin
invocada:
    mov rax, [rsp]      
    ;Guardo el stack pointer
    ;Este mismo contiene la proxima dirección a 
    ;volver cuando se haga el pop de ret
    add rax, 6 ;Número arbitrario, no sé cómo los recibe
    ret            ;Vuelvo a llamadora

; c) Veo que lo que se agregue al stack sea igual al rip (instruction pointer)
;    No sé si haya manera de acceder al stack desde gbd (espero que si!)
; d) Verifiqué y todo anda bien (en términos de memoria)

fin:
    pop rbp
    mov eax, 1   
	int	0x80   