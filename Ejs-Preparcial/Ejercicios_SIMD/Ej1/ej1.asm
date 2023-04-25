global SumarVectores
extern malloc

section .data
section .text

;Mov. de datos: movd, movq, movdqu
;Aritméticas: paddb, paddw, paddd, paddq, psubb, psubw, psubd, psubq

;void SumarVectores(char *A, char *B, char *Resultado, int dimension)

;rdi <- *A ; rsi <- *B, rdx <- *res ; rcx <- dimension (8)

; Memo:SIMD funciona con registros de 128 bits (16 bytes)

; Se procesan 8 a la vez, ya que es 16/2 = 8, 2 bytes pq son word
; Una es para alineados y otro desalineados
; Mismo solo que en términos de bytes

; No sé si esté bien!!!
SumarVectores:
    ;Cómo más dimensiones?
    push rbp
    mov rbp, rsp
    movdqu xmm0, [rdi]
    movdqu xmm1, [rsi]

    ;Ojo son 16 bytes c/uno
    paddw xmm0, xmm1 ;Es decir paddWORD

    movdqu [rdx], xmm0 
    pop rbp
    ret