section .data
myVector: times 16 dd 1 ;dd: dobleword
myVectorLength: equ $ - myVector
section .text
global _start

_start:
    jmp sumMemory

; - (a , b)
; Guarde todos los números en registros, al usar no volatiles en el prologo pushee su valor original
; En el epilogo "pop" todos estos para devolver sus valores originales
; Para guardar el valor que no alcanzó a entrar, reutilicé un registro

sumMemory:
    push rbp
    ; Guardo los no volatiles RBX, RBP, R12, R13, R14 y R15
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    ;Tengo impar push -> Alineada!
    ;Ahora guardar en registros distintos
    mov edi,  [myVector]
    mov esi,  [myVector + 4*1]
    mov edx,  [myVector + 4*2]
    mov ecx,  [myVector + 4*3]
    mov ebx,  [myVector + 4*4]
    mov r8d,  [myVector + 4*5]
    mov r9d,  [myVector + 4*6]
    mov eax,  [myVector + 4*7]
    mov ebp,  [myVector + 4*8]
    mov r10d, [myVector + 4*9]
    mov r11d, [myVector + 4*10]
    mov r12d, [myVector + 4*11]
    mov r13d, [myVector + 4*12]
    mov r14d, [myVector + 4*13]
    mov r15d, [myVector + 4*14]

    add edi, esi     
    add edi, edx
    add edi, ecx
    add edi, ebx
    add edi, r8d
    add edi, r9d
    add eax, edi 
    add eax, ebp
    add eax, r10d
    add eax, r11d
    add eax, r12d
    add eax, r13d
    add eax, r14d
    add eax, r15d

    mov edi, [myVector + 4*15]
    add eax, edi
    mov r8d, eax
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    pop rbp

fin:
    mov	eax, 1   
	int	0x80    
