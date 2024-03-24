global acumuladoPorCliente_asm
global en_blacklist_asm
global blacklistComercios_asm
extern malloc
extern strcmp
section .data
%define OFFSET_MONTO 0
%define OFFSET_COMERCIO 8
%define OFFSET_CLIENTE 16
%define OFFSET_APROBADO 17
%define SIZE_PAGO 24

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;uint32_t* acumuladoPorCliente_asm(uint8_t cantidadDePagos, pago_t* arr_pagos);
; dil <- #Pagos
; rsi <- arr_pagos - POINTER
acumuladoPorCliente_asm:
	push rbp
	mov rbp, rsp

	push r12
	push r13
	push r14
	push r15 ; Stack alineado
	
	mov r12b, dil ; r12b <- #pagos
	mov r13, rsi  ; r13  <- arr_pagos
	
	mov rdi, 40 ; Para el malloc 4 bytes * 10 pos
	call malloc
	mov r14, rax ; En rax tengo el puntero devuelto por malloc ahora está en r14
	mov  cl, r12b ; En cl tengo la cantidad de pagos
	.ciclo:
		mov r9, r14 ;Pointer al inicio del arreglo de 10 - al que devolvió rax
		mov byte r8b, [r13 + OFFSET_APROBADO] ;r8 <- aprobado (i-esimo)
		cmp r8b, 1
		jne .sigue ;Si está aprobado hace lo siguiente
		add r9b, [r13 + OFFSET_CLIENTE]   ; r9 <- pos de memoria pedida + cliente, recordar, cliente: [0..9]                   
		mov rdx, [r13 + OFFSET_MONTO]    ; rdx <- i-esimo monto
		add [r9], rdx                    ;Voy a la pos correspondiente y le sumo al contenido el monto (rdx) 
		.sigue:
		add r13, SIZE_PAGO
	loop .ciclo

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

;uint8_t en_blacklist_asm(char* comercio, char** lista_comercios, uint8_t n);
; rdi <- comercio pointer
; rsi <- lista comercio pointer a pointer
; dl <- # comercios
;retorna 1 <-> comercio pertenece a la lista
en_blacklist_asm:
	push rbp
	mov rbp, rsp
	push r12 
	push r13 
	push r14
	push r15 

	mov r12, rdi ; r12 <- string comercio
	mov r13, rsi ; r13 <- puntero a strings
	mov r14b, dl ; r14 <- n
	.ciclo:
		mov rsi, r13 ; rsi <- Puntero a i-esimo string
		mov rdi, r12                     ; rdi <- Puntero a string (comercio)
		call strcmp         ;Asumo devuelve 1 si son iguales, 0 cc            
		cmp rax, 1
		je .esta
	 	add r13, 8 ;Avanzo al siguiente puntero	
	dec r14
	jnz .ciclo

	jmp .noEsta
	.esta:
		mov rax, 1
		
	.noEsta:
		mov rax, 0



	pop r13
	pop r12
	pop rbp
	ret

;pago_t** blacklistComercios_asm(uint8_t cantidad_pagos, pago_t* arr_pagos, char** arr_comercios, uint8_t size_comercios);
; dil <- #pagos
; rsi <- arr_pagos pointer
; rdx <- pointer a lista de comercios
; rcx <- size_comercios
blacklistComercios_asm:
	push rbp 
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rbp, 8
	mov r12, rdi ;r12 <- #pagos 
	mov r13, rsi ;r13 <- arr_pagos pointer
	mov r14, rdx ;r14 <- pointer a lista de comercios
	mov r15, rcx ;r15 <- size comercios

	xor rbx, rbx
	mov r9, r13 ;R9 <- guardara el pointer original debido a que la funcion llamada no lo usa
	.ciclo: ;Este ciclo es para calcular el size del malloc
		mov r8, [r13 + OFFSET_COMERCIO] ;r8<-Puntero al comercio (str)
		mov rdi, r8 ; rdi <- r8<-Puntero al comercio (comercio)
		mov rsi, r14 ; rsi <- Puntero a la lista de comercio original (lista_comercios)
		mov rdx, r15; rdx <- size comercios (n)
		call en_blacklist_asm
		cmp rax, 1
		jne .continue
		;Caso para agregar al array		
		inc rbx
		.continue:
		add r13, SIZE_PAGO
	dec r12
	jnz .ciclo

	mov r13, r9 ;Reestablezco el valor de r13

	;Ahora en rbx tendre los casos que si (la cantidad)
	mov rdi, rbx
	shl rdi, 3 ;8 bytes un puntero, por lo tanto multiplico los casos que si cumplen por 8.
	call malloc ;LLamo malloc con los casos que si (rbx)

	xor rbx, rbx
	mov rbx, rax ;El puntero que guardara los que si van
	mov r9, rax
	.ciclo2:
		mov r8, [r13 + OFFSET_COMERCIO] ;r8<-Puntero al comercio (str)
		mov rdi, r8 ; rdi <- r8<-Puntero al comercio (comercio)
		mov rsi, r14 ; rsi <- Puntero a la lista de comercio original (lista_comercios)
		mov rdx, r15; rdx <- size comercios (n)
		call en_blacklist_asm
		cmp rax, 1
		jne .continue2
		;Caso para agregar al array		
		mov [rbx], r13
		add rbx, 8 ;Avanzo una pos de memoria
		.continue2:
		add r13, SIZE_PAGO
	dec r12
	jnz .ciclo2

	mov rax, r9 ;Devuelvo el valor original de rax
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret



