global MultiplicarVectores
global ProductoInterno
global SepararMaximosMinimos
extern malloc

section .data
section .text

;Desempaquetado: punpcklbw, punpcklwd, punpcklddq, punpckhbw, punpckhwd, punpckhddq
;Aritméticas: pmullw, pmulld, pmulhw, pmulhd, pmaddwd, pmaxub, pmaxuw, pmaxud, pminub,
;pminuw, pminud
;Empaquetado: packsswb, packssdw, packuswb, packusdw

;void MultiplicarVectores(short *A, short *B, int *Res, int dimension)
MultiplicarVectores:
    ;rdi <- A, rsi <- B, rdx <- Res, rcx <- dimension
    ;Asumo que el tamaño de vector es de 32 bits (4 bytes)
    movq xmm0, rdi 
    movq xmm1, rsi
    pmulld xmm0, xmm1
    movdqu [rdx], xmm0
    ;Espero sea así!
    pop rbp
    ret   
;int ProductoInterno(short *A, short *B, int dimension)
ProductoInterno:
  ;Multiplicar todo elemento de los vectores y lueg osumar
  ;rdi <- A, rsi <- B ; rdx <- dimension
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    mov rcx, rdx
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx
    mov rdi, 256 ; 64 * 4
    call malloc ;Ahora tengo en rax lo asignado
    mov r15, rax ;r15 <- mem asignada
    mov rdi, r12
    mov rsi, r13
    mov rdx, r15
    mov rcx, r14
    call MultiplicarVectores ;Calculo su mult
    ;Me devuelve algo escrito en [r15]
    pxor xmm0,xmm0
    movdqu xmm0, [r15]
    ;Necesito la suma horizaontal
    phaddd xmm0, xmm0
    movq rax, xmm0
    ;ESPERO FUNCIONE!!!!
    pop r15
    pop r14
    pop r13
    pop rbp
    ret

;void SepararMaximosMinimos(char *A, char *B, int dimension)
SepararMaximosMinimos:
    push rbp
    mov rbp, rsp
    ;Guardo en A los maximos y B los mínimos
    ;rdi <- A, rsi <- B, rdx <- dimension
    movdqu xmm0, [rdi]
    movdqu xmm1, [rsi]
    ;Comenzamos con máximos
    movdqu xmm2, xmm0 ;Me guardo el val de xmm0
    ;Max -> xmm0
    pmaxud xmm0, xmm1
    ;Min -> xmm1
    pminud xmm1, xmm2
    movdqu [rdi], xmm0
    movdqu [rsi], xmm1
    ;Y vuelvo a decir, espero funcione!
    pop rbp
    ret

