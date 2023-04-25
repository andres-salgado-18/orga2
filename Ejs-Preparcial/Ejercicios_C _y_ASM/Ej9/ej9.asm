global agregarAdelante_asm
global valueNode_asm
extern strlen
extern malloc

section .data
%define NODE_SIZE 128
section .text

;node_t* agregarAdelante_asm(int32_t val, node_t* siguiente);
;rdi - edi <- val, rsi <- siguiente
agregarAdelante_asm:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    mov r12, rdi ; r12 <- val
    mov r13, rsi ; r13 <- siguiente*
    mov rdi, NODE_SIZE
    call malloc ;Ahora tengo en rax la memoria asignada
    mov rdx, rax ; rdx <- mem asignada
    mov [rdx], r13 ;Guardo en lo asignado el puntero
    inc rdx        ; INcremento la posicińo de memoria
    mov [rdx], r12 ; Guardo r12
    dec rdx
    pop r13
    pop r12
    pop rbp
    mov rax, rdx
    ret

;int valueNode_asm(nodo_t* actual);
valueNode_asm:       ;rdi <- actual*
    push rbp
    xor rsi, rsi
    mov rbp, rsp
    inc rdi 
    mov rsi, [rdi]
    mov rax, rsi
    pop rbp
    ret