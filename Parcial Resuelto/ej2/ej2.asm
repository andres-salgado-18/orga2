global maximosYMinimos_asm

maskA :   db 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0x00
maskEven: dw 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00  
maskOdd:  dw 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF
maskB :      db 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00
maskG :      db 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00
maskR :      db 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00
maskShuf1:   db 0x0E,  0x80, 0x80, 0x80, 0x80, 0x0A, 0x80 ,0x80 ,0x06 ,0x80, 0x80 ,0x80 ,0x02 ,0x80, 0x80, 0x80
maskShuf2:   db 0x0D,  0x80, 0x80, 0x80, 0x80, 0x09, 0x80 ,0x80 ,0x05 ,0x80, 0x80 ,0x80 ,0x01 ,0x80, 0x80, 0x80
maskShufRGB: db 0x0F,  0x0F, 0x0F, 0x0C, 0x0B, 0x0B, 0x0B, 0x08, 0x07, 0x07, 0x07, 0x04, 0x03, 0x03, 0x03, 0x00 
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text


;Procesare de 4 pixeles debido a que un pixel son 4 bytes que es lo mismo que 32 bits y como los xmm procesan 128, tendremos 4 pixeles.

;void maximosYMinimos_asm(uint8_t *src, uint8_t *dst, uint32_t width, uint32_t height);
; rdi <- pointer src
; rsi <- pointer dst
; edx <- width
; ecx <- height
maximosYMinimos_asm:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi ; r12 <- src
    mov r13, rsi ; r13 <- dst
    mov r14d, edx; r14 <- widht
    mov r15d, ecx; r15 <- height

    ;Cantidad de iteraciones
    
    ;Ciclo height

    mov rdx, r15d ;Height
    shr rdx, 2    ;Ya que proceso de a 4 pixeles
    ;Pongo rdx por si hay ov
    .cicloHeight:

        ;ciclo width
        mov rcx, r14d ; rcx <- width
        shr rcx, 2    ; proceso de a 4 pixeles
        .cicloWidth:
            movdqu xmm0, [r12] ;levanto 4 pixeles
            ;Tengo 4 pixeles y dos cosas que hacer para los j impar o par
            ;Como avanzo de a 4 pixeles, el 0 y 2 serán j par y el 1 y 3 serán impares
            movdqa xmm2, xmm0
            movdqu xmm1, [maskEven] ; Tengo máscara de pares
            pand xmm2, xmm1 ; Tengo los 4 pixeles con sus pixeles pares con su valor

            ;Mismo para impares
            movdqa xmm3, xmm0
            movdqu xmm4, [maskOdd]
            pand xmm3, xmm4 ; Tengo los 4 pixeles con sus pixeles impares con su valor

            ;Como A no importa para el cálculo de max/min en el cálculo lo filtro a mano con la mascara de A
            pand xmm2, [maskA]
            pand xmm3, [maskA] 
            ; | r g b 0 | 0 0 0 0 | r g b 0 | 0 0 0 0 | -> xmm2
            ; | 0 0 0 0 | r g b 0 | 0 0 0 0 | r g b 0 | -> xmm3


            ; Mi idea era usar una max/min horizontal, pero no existe
            ; Ahora expandiré los registros en cada caso y asi obtengo 3 nuevos xmm
            ; para cada caso y asi poder comparar de forma vertical r , g , b
        
            ;Ahora xmm2 estará dividido por componente en xmm5, 6 y 7
            ;Ahora xmm3 estará dividido por componente en xmm8, 9 y 10

            ;Las nuevas mascaras estaran en xmm11, 12 y 13

            movdqu xmm11, [maskR]
            movdqu xmm12, [maskG]
            movdqu xmm13, [maskB]

            ;"Expandimos" el caso par (xmm2)
            movdqa xmm5, xmm2
            movdqa xmm6, xmm2
            movdqa xmm7, xmm2
            ;"Expandimos" el caso impar (xmm3)
            movdqa xmm8, xmm3
            movdqa xmm9, xmm3
            movdqa xmm10, xmm3

            ;Pasamos las mascaras por cada uno
            pand xmm5, xm11
            pand xmm6, xmm12
            pand xmm7, xmm13

            pand xmm8, xmm11
            pand xmm9, xmm12
            pand xmm10,xmm13

            ;Caso par queda:
            ; | r 0 0 0 | 0 0 0 0 | r 0 0 0 | 0 0 0 0 | -> xmm5
            ; | 0 g 0 0 | 0 0 0 0 | 0 g 0 0 | 0 0 0 0 | -> xmm6
            ; | 0 0 b 0 | 0 0 0 0 | 0 0 b 0 | 0 0 0 0 | -> xmm7

            ;Analogo para impar
            ; | 0 0 0 0 | r 0 0 0 | 0 0 0 0 | r 0 0 0 | -> xmm5
            ;| 0 0 0 0 | 0 g 0 0 | 0 0 0 0 | 0 g 0 0 | -> xmm6
            ;| 0 0 0 0 | 0 0 b 0 | 0 0 0 0 | 0 0 b 0 | -> xmm7
            ;Ahora para comparar debo 'shiftear' para alinear el byte que comparare
            ;Elegire el primero
            ; | r 0 0 0  | --- 
            ; | g 0 0 0  | --- 
            ; | b 0 0 0  | ---
            ; No tengo instruccion para shiftear bytes, reacomodaré a mano los valores
            ; Usare xmm14 y 15 para mascaras de shuffle asi puedo reacomodar los bytes
            movdqu xmm14, [maskShuf1] ;Shuffle para reacomodar g (mask)
            movdqu xmm15, [maskShuf2] ;Shuffle para reacomodar b (mask)

            pshufb xmm6, xmm14 
            pshufb xmm7, xmm15 ;Tengo alineados los valores de par

            ;Ahora para los impares

            pshufb xmm9, xmm14
            pshufb xmm10, xmm15 ;Tengo alineados los valores de impar

            ;Comparacion par
            pmaxsb xmm5, xmm6
            pmaxsb xmm5, xmm7

            ;Tengo en el byte mas alto de mi pixel el mayor!

            ;Comparación impar
            pminsb xmm8, xmm9
            pminsb xmm8, xmm10

            ;Tengo en el byte mas alto de mi pixel el mayor!

            ;Solo falta copiar dicho valor en las demas componentes
            ;Lo hare con un shuffle, uno para cada caso

            ;Me sirve una misma mascara para ambos casos
            ;Ya que si copio el byte R de todos los bytes que componen el pixel
            ;En los pares habra un 0 y se copiara un 0 en byte [1, 3]
            ;En los impares habra un 0 y se copiara un 0 en byte [0,2]


            movdqu xmm15, [maskShufRGB] ;xmm15 <- Mask para copiar el valor

            pshufb xmm5, xmm15 ;Tengo el max en las 3 componentes de los pares
            pshufb xmm8, xmm15 ;Tengo el min en las 3 componentes de los impares

            por xmm5, xmm8    ;Uno los resultados (tanto pares e impares procesados)

            movdqa xmm1, xmm5 ;En xmm1 tendre los valores ya "mergeados"
            movdqu [r13], xmm1 ;Paso al puntero de dst el valor
            add r12, 16 ;Ya que levanté 4 pixeles
            add r13, 16 ;Ya que levanté 4 pixeles

        dec rcx
        jnz .cicloWidth

    add r12, 16 ;Sig fila
    add r13, 16 ;Sig fila
    dec rdx
    jnz .cicloHeight

    pop rbp
    ret