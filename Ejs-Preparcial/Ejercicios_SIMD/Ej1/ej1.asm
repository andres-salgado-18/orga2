global SumarVectores
extern malloc
%define SIZE_XMM 16
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


SumarVectores:

    ;Es byte a byte entonces puedo hacer 128/8 = 16 op a la vez
    push rbp 
    mov rbp, rsp
    shr ecx, 4 ; Size vector / 16 -> Cuantas operaciones debo hacer
    .ciclo:
        movdqu xmm0, [rdi] ;xmm0 <- A
        movdqu xmm1, [rsi] ;xmm1 <- B
        add rdi, 16
        add rsi, 16
        paddb xmm0, xmm1
        movdqu [rdx], xmm0
        add rdx, 16
    loop .ciclo
    pop rbp