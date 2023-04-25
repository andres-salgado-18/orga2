global InicializarVector
extern malloc

section .data

;Comparación: pcmpgtb, pcmpgtw, pcmpgtd, pcmpeqb, pcmpeqw, pcmpeqd
;Lógicas: pand, por, pxor, pandn
;Nivel de Bit: psrlw, psrld, psrlq, psrldq, pslld,psllq, pslldq

;void InicializarVector(short *A, short valorInicial, int dimension)
section .text

InicializarVector:
    push rbp
    mov rbp, rsp
;rdi <- A, rsi <- valorInicial , rdx <-dimension
    ;Tengo que ir a la direccion A, luego agregar valorIncial
    ;A lo largo del vector
    movd xmm0, esi
    ;Es decir el valor incial que tiene 4 bytes
    ; psrad, para hacer el shift ?
    psrad xmm0, 4
    movdqu [rdi], xmm0
    pop rbp
    ret