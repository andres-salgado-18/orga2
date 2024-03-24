%define OFFSET_NEXT  0
%define OFFSET_SUM   8
%define OFFSET_SIZE  16
%define OFFSET_ARRAY 24
%define SIZE_OF_UINT32_T 4
%define SIZE_OF_UINT64_T 8

BITS 64

extern malloc

section .text


; uint32_t proyecto_mas_dificil(lista_t*)
;
; Dada una lista enlazada de proyectos devuelve el `sum` más grande de ésta.
;
; - El `sum` más grande de la lista vacía (`NULL`) es 0.
;
; lista_t* -> RDI
global proyecto_mas_dificil
proyecto_mas_dificil:
	push rbp
	mov rbp, rsp

	mov r12, rdi
	mov eax, 0

	.ciclo:
		cmp r12, 0
		je .fin
		cmp eax, [r12 + OFFSET_SUM]

		jae .next
		mov eax, [r12 + OFFSET_SUM]

		.next:
		mov r12, [r12 + OFFSET_NEXT]
		jmp .ciclo

	.fin:
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; void tarea_completada(lista_t*, size_t)
;
; Dada una lista enlazada de proyectos y un índice en ésta setea la i-ésima
; tarea en cero.
;
; - La implementación debe "saltearse" a los proyectos sin tareas
; - Se puede asumir que el índice siempre es válido
; - Se debe actualizar el `sum` del nodo actualizado de la lista
;
global marcar_tarea_completada
marcar_tarea_completada:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15

	mov r12, rdi 								; R12 -> lista_t*
	mov r13, rsi        						; R13 -> index

	mov r14, 0									; curr_i = 0
	.ciclo:
		;guarda ciclo:
		cmp r12, 0								 ; lista != null
		je .saleCiclo

		add r14, [r12 + OFFSET_SIZE]             ; curr_i + lista_size <= index
		cmp r14, r13

		jbe .next                                ; si se cumple que <= index, entro al ciclo, osea sigo iterando
		sub r14, [r12 + OFFSET_SIZE]             ; si no se cumple, restauro el valor del curr_i, le resto lo que le sume
		jmp .saleCiclo                           ; y salgo del ciclo

		;cuerpo ciclo:
		.next:
		mov r12, [r12 + OFFSET_NEXT]
		jmp .ciclo

	.saleCiclo:

	cmp r12, 0									 ; if lista==null return
	je .fin

	sub r13, r14 								 ; index -= curr_i 

	xor r14, r14                                 ; para reusar r14

	mov r14, [r12 + OFFSET_ARRAY]				 ; ahora en r14 tengo el array

	xor r15, r15                                 ; usare r15 para guardame lista->array[index] momentaneamente, para hacer la resta siguiente

	mov r15d, [r14 + SIZE_OF_UINT32_T * r13]     ; (el array es de uint32_t, asique al elemento lo muevo a un registro de 32)

	sub DWORD [r12 + OFFSET_SUM], r15d                 ; lista->sum -= lista->array[index]

	mov DWORD [r14 + SIZE_OF_UINT32_T * r13], 0  ; lista->array[index] = 0

	.fin:	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; uint64_t lista_len(lista_t* lista)
;
; Dada una lista enlazada devuelve su longitud.
;
; - La longitud de `NULL` es 0
;
; RDI -> lista_t*
global lista_len
lista_len:
	push rbp
	mov rbp, rsp

	mov rax, 0  			             ; size_t i = 0
	
	.ciclo:					
		cmp rdi, 0              		 ; lista != NULL
		je .fin
		mov rdi, [rdi + OFFSET_NEXT]     ; lista = lista->next
		inc rax							 ; i++
		jmp .ciclo

	.fin:
	pop rbp
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; uint64_t tareas_completadas(uint32_t* array, size_t size) {
;
; Dado un array de `size` enteros de 32 bits sin signo devuelve la cantidad de
; ceros en ese array.
;
; - Un array de tamaño 0 tiene 0 ceros.
; RDI -> array
; RSI -> size
global tareas_completadas
tareas_completadas:
	push rbp
	mov rbp, rsp

	xor rax, rax										; size_t res = 0
	xor rcx, rcx										; size_t i = 0

	.ciclo:
		cmp rcx, rsi                                    ; while (i < size)
		je .fin

		cmp DWORD [rdi + rcx * SIZE_OF_UINT32_T], 0     ; if array[i] == 0
		jne .next
		inc rax                                         ; res++

		.next:
		inc rcx                                         ; i++
		jmp .ciclo

	.fin:
	pop rbp
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; uint64_t* tareas_completadas_por_proyecto(lista_t*)
;
; Dada una lista enlazada de proyectos se devuelve un array que cuenta
; cuántas tareas completadas tiene cada uno de ellos.
;
; - Si se provee a la lista vacía como parámetro (`NULL`) la respuesta puede
;   ser `NULL` o el resultado de `malloc(0)`
; - Los proyectos sin tareas tienen cero tareas completadas
; - Los proyectos sin tareas deben aparecer en el array resultante
; - Se provee una implementación esqueleto en C si se desea seguir el
;   esquema implementativo recomendado
;
; RDI -> lista_t*

global tareas_completadas_por_proyecto
tareas_completadas_por_proyecto:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15

	mov r12, rdi                            ; me guardo el puntero a la lista que viene por parametro

	call lista_len							; en rdi ya esta la lista, asique llamo de una a lista_len
	mov r13, rax							; me guardo la longitud en r13

	mov rdi, r13							; uint64_t* results = malloc(length * sizeof(uint64_t));
	lea rdi, [rdi * SIZE_OF_UINT64_T]
	call malloc
	mov r14, rax

	xor r15, r15                                ; i = 0
	;xor rcx, rcx
	.ciclo:

		cmp r15, r13                            ; i < len
		;cmp rcx, r13
		je .fin

		mov rdi, [r12 + OFFSET_ARRAY]
		mov rsi, [r12 + OFFSET_SIZE]
		call tareas_completadas 				; tareas_completadas(lista->array, lista->size)
		mov [r14 + r15 * SIZE_OF_UINT64_T], rax ; results[i] = tareas_completadas(lista->array, lista->size)
		;mov [r14 + rcx * SIZE_OF_UINT64_T], rax ; ESTO ROMPE!
		mov r12, [r12 + OFFSET_NEXT]            ; lista = lista->next

		inc r15                                 ; i++
		;inc rcx
		jmp .ciclo

	.fin:
	; el array de result lo tengo en r14, lo muevo a rax para devolverlo
	mov rax, r14

	;.fin:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
