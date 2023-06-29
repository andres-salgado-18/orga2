global miraQueCoincidencia

section .data
align 16
bgra: dd 0.114, 0.587, 0.299, 0.0
c255: dd 255, 255, 255, 255

section .text

;void miraQueCoincidencia( uint8_t *A, uint8_t *B, uint32_t N, uint8_t *laCoincidencia );
;                          rdi         rsi         edx         rcx  

miraQueCoincidencia:
    push rbp
    mov rbp, rsp

    mov r8, rcx
    movdqa xmm15, [bgra] ; cargo coeficientes bgra
    movdqa xmm13, [c255] ; cargo 255's como dwords

    mov eax, edx
    mul edx              ; multiplico NxN
    shr eax, 2           
    mov ecx, eax         ; en eax queda NxN / 4, ya que se leen de a 4 pixels

    xor eax, eax
    xor edx, edx

    .cycle:
    
        movdqu xmm1, [rdi + rax] ; cargo 4 pixels de A
        movdqu xmm2, [rsi + rax] ; cargo 4 pixels de B

        movdqa xmm0, xmm1
        pcmpeqd xmm0, xmm2 ; comparo pixels y guardo máscara en xmm8
                           ; ej: si pixel 0 y 3 son iguales queda
                           ; FFFFFFFF | 00000000 | 00000000 | FFFFFFFF

        pmovzxbd xmm3, xmm1 ; extiendo pixel 0 a dwords
        
        psrldq xmm1, 4
        pmovzxbd xmm4, xmm1 ; extiendo pixel 1 a dwords

        psrldq xmm1, 4
        pmovzxbd xmm5, xmm1 ; extiendo pixel 2 a dwords

        psrldq xmm1, 4
        pmovzxbd xmm6, xmm1 ; extiendo pixel 3 a dwords
        
        cvtdq2ps xmm3, xmm3 ; convierto dwords a floats
        cvtdq2ps xmm4, xmm4
        cvtdq2ps xmm5, xmm5
        cvtdq2ps xmm6, xmm6

        mulps xmm3,xmm15 ; multiplico por coeficientes
        mulps xmm4,xmm15
        mulps xmm5,xmm15
        mulps xmm6,xmm15

        haddps xmm3, xmm3 ; acumulo total pixel 0
        haddps xmm3, xmm3

        haddps xmm4, xmm4 ; acumulo total pixel 1
        haddps xmm4, xmm4

        haddps xmm5, xmm5 ; acumulo total pixel 2
        haddps xmm5, xmm5

        haddps xmm6, xmm6 ; acumulo total pixel 3
        haddps xmm6, xmm6

        ; Tengo ahora 4 xmms con
        ; xmm3 V0 | V0 | V0 | V0 
        ; xmm4 V1 | V1 | V1 | V1
        ; xmm5 V2 | V2 | V2 | V2
        ; xmm6 V3 | V3 | V3 | V3


        ; armo en xmm3 el vector con dwords resultantes
        ; V3 | V2 | V1 | V0

        blendps xmm3, xmm4, 0000_0010b 
        blendps xmm3, xmm5, 0000_0100b 
        blendps xmm3, xmm6, 0000_1000b

        cvttps2dq xmm3, xmm3 ; convierto floats a dwords
        
        movdqa xmm14, xmm13  ; cargo 255's como dwords
        blendvps xmm14, xmm3 ; guardo valor o 255 segun mascara en xmm0
        
        packusdw xmm14, xmm14 ; packing dwords to bytes
        packuswb xmm14, xmm14

        movd [r8 + rdx], xmm14 ; guardo resultado en uint8_t *laCoincidencia

        add eax, 16 ; muevo el offset a los siguientes 4 pixels BGRA
        add edx, 4  ; muevo el offset a los siguientes 4 pixeles escala de grises

        dec ecx
        jnz .cycle

    pop rbp
    ret
