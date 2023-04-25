global Intercalar
extern malloc
section .data
section .text
%define mask_shuff: 15,13,11,9,7,5,3,1
;Reordenamiento: pshufb, pshufw, pshufd
;void Intercalar(char *A, char *B, char *vectorResultado, int dimension)

Intercalar:
    push rbp
    mov rbp, rsp
    movdqu xmm0, [rdi]
    movdqu xmm1, [rsi]
    movdqu xmm2, [mask_shuff]
    ; rdx <- vectorRes
    ; Son doble words (asumo) -> pshufd
    pshufd xmm0, xmm1, xmm2
    movdqu [rdx] , xmm0
    ;Asumo que hay que intercalarlos sin generar nuevas pos
    ;EJ: [ a | b | c | d]  [ x | y | w | z ]
    
    ;Res:         [ y | a | z | d ]
    pop rbp