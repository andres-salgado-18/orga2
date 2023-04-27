global InicializarVector
extern malloc

section .data

;Comparación: pcmpgtb, pcmpgtw, pcmpgtd, pcmpeqb, pcmpeqw, pcmpeqd
;Lógicas: pand, por, pxor, pandn
;Nivel de Bit: psrlw, psrld, psrlq, psrldq, pslld,psllq, pslldq

;void InicializarVector(short *A, short valorInicial, int dimension)
section .text

InicializarVector:
  ;rdi <- A ; rsi <- valorInicial, rdx <- dimension
  ;Memo: Short tiene 2 bytes!
    push rbp 
    mov rbp, rsp 
    movq xmm2, rsi
    ;Ahora podremos hacer 128/16 = 8 operaciones a la vez
    shr rcx, 3 ; dimension del vector / 8

    .ciclo:
        movdqu xmm0, [rdi]
        pshuflw xmm0, xmm2, 0  ;Suffle a low xmm0
        punpcklwd xmm0, xmm0   ;Unpack el valor (es decir se llena con este mismo)
        movdqu [rdi], xmm0
        add rdi, 16
    loop .ciclo

    pop rbp
    ret