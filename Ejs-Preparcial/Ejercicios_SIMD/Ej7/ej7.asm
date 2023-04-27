global sumarVector
extern malloc
vector:   db 0x00, 0x10, 0x02, 0x00, 0x30, 0x04, 0x00, 0x50, 0x06, 0x00, 0x70, 0x08, 0x00, 0x90, 0x0a, 0x00
myShuffBytes: db 00, 01, 02, 80 
%define SIZE_TOTAL 384
%define SIZE_XMM 128
%define ITERATIONS 384/128
section .data
section .text

;void sumarVector()
sumarVector:
    push rbp
    mov rbp, rsp
    movdqu xmm0, [vector] ;xmm0 <- Dirección inicial del vector
    mov ecx, ITERATIONS   ;Cantidad de iteraciones+1
    pxor xmm2, xmm2 ;Limpio xmm2
    movdqu xmm2, xmm0

    mov rax, 0xF0
    

    pop rbp
