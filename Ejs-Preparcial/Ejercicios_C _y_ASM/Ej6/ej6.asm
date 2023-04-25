global codificacion_cesar_asm
extern strlen
extern malloc

section .data

section .text

;char *codificacion_cesar_asm(char* str, int x);
;obs: rdi <- char* str ; rsi <- x
codificacion_cesar_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push r13
    mov r9, rdi    ;Guardo str (pointer) en r8
    call strlen
    mov rbx, rax    ;Paso el resultado (rax) a rsi
    inc rbx         ; Tengo len + 1 para el nulo
    xor rax, rax    ;Limpio rax
    mov rdi, rbx    ;Muevo la longitud+1 a rdi
    mov r13, rsi
    call malloc     ;Malloc toma rdi (es decir el str)
    mov rdx, rax    ;Guardo en rdx el pointer asignado
    xor rax, rax
    ;Resumiendo:
    ; rdx <- Memoria asignada
    ; r9  <- Puntero a str
    ; rbx <- longitud + 1 de str
    ; r13 <- x
    mov rcx, rbx
    mov byte [rdx + rcx], 0
    .ciclo:
        mov al, [r9 + rcx - 1]
        add rax, r13
        ; Tenemos el nuevo valor
        mov [rdx + rcx -1], al


    loop .ciclo
    mov rax, rdx

fin:
    pop r13
    pop rbx
    pop rbp
    ret