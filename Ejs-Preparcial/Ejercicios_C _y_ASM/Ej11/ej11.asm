;global agregarAdelante_asm
global strArrayNew
global strArrayGetSize
global strArrayAddLast
global strArrayGet
%define SIZE_ARR_STRUCT 16 ;Esto es size y capacity (bytes)
extern malloc
extern strLen
extern strClone
section .data


section .text


;str_array_t* strArrayNew(uint8_t capacity);
; Obs: rdi <- dil <- capacity
;Crea un array de strings nuevo con capacidad indicada por capacity.
; Qué tengo qué hacer?
; Tengo que crear un array de string con la capacidad especificada
; Tengo que pedir la memoria adecuada que será el tamaño del struct
; Sumado a la cantidad de strings(punteros a string de hecho) que
; ocuparán.
strArrayNew:
    push rbp
    mov rbp, rsp
    push r14
    push r15
    ;Primero pediré memoria para el arr es decir lo que apunta data
    ;Sé que tendrá capacidad (rdi) así puedo crear cuantos quiera, como son 
    ;punteros a char (strings) serán de 8 bytes cada uno, con lo cual debo multiplicar
    ;la capacidad * 8, así reservo el espacio correcto!
    mov r15, rdi
    mov rax, rdi
    mov rsi, 8
    mul rsi
    ;Tengo en rax lo que tengo que resarvar para los str
    mov rdi, rax ; rdi <- size para reservar data
    call malloc
    mov r14, rax ; r14 <- espacio reservado para data

    ;Ahora voy con el struct (a reservar lo siguiente)
    ; [ Size | Capactiy | - | - | - | - | - | - ]     Total = 16 bytes
    ; [                 DATA                    ]
    mov rdi, SIZE_ARR_STRUCT
    call malloc
    mov rdx, rax   ;r15 <- reservado para el struct
    ; Comienzo a mover los datos
    xor r8, r8
    mov [rdx] , r8
    mov [rdx + 1] ,  r15
    mov [rdx + 8] , r14 ;Es decir lo reservado para data!
    pop r15
    pop r14
    pop rbp
    ret 

;uint8_t strArrayGetSize(str_array_t* a)
; rdi <- a
strArrayGetSize:
    push rbp
    mov rbp, rsp
    mov rax, [rdi + 1] ;Se que en struct[1] está el size
    pop rbp
    ret

;void  strArrayAddLast(str_array_t* a, char* data);
;Agrega un string al final del arreglo. Si el arreglo no tiene capacidad suficiente, entonces no 
; hace nada. Esta función debe hacer una copia del string.
strArrayAddLast:
    ; rdi <- a ; rsi <- data
    ;Tengo que fijarme en la capacidad
    ; Si Size == capacidad entonces no hace nada
    push rbp
    mov rbp, rsp
    push r13
    push r14
    mov r13, rdi
    mov r14, rsi
    mov dl, [rdi] ;obtengo size -> rdx
    mov cl, [rdi+1] ;obtengo capacity -> rcx
    cmp cl, dl
    je notValid

    ;Ahora si es valido tengo que:
    ;Escribir en el arreglo data, lo que me pasan, pero viendo su indice
    ;Su indice será el tamaño, es decir si tengo size = 0, el elemento se debe
    ;agregar ahí mismo 0, sino en 1, etc.
    mov rdi, r14
    call strLen
    mov rdi, rax
    inc rdi
    call malloc ;En rax tengo lo asignado para copiar el str
    xor r9, r9
    mov rsi, [r13 + 8] ;Donde copiare el str
    mov r9b, [r13]      ;Obtengo el size
    mov [rsi + r9*8], rax 
    mov rsi, rax
    mov rdi, r14
    call strClone
    
    inc byte [r13] ;Size + 1

    pop r14
    pop r13
    pop rbp
    ret

notValid:
    pop rbp
    ret

;char* strArrayGet(str_array_t* a, uint8_t i);
;Obtiene el i-esimo elemento del arreglo, si i se encuentra fuera de rango, retorna 0.
; rdi <- a, rsi - sil <- i
strArrayGet:
    ;Primer caso i, fuera de rango
    push rbp
    mov rbp, rsp
    mov dl, sil ;RDX - dl <- i
    mov byte cl, [rdi] ;Muevo a cl el primer byte de a, que es el size
    cmp cl, dl ; Si size - i < 0, entonces está fuera de rango, 3-
    js notValidIndex

    ;Ahora caso valido,
    ;Tengo que ir a donde apunta data y avanzar según me indique i
    xor rdx, rdx
    xor rcx, rcx
    mov rdx, [rdi + 8] ;Así estoy en el puntero que es el arr
    ;Ahora tengo que avanzar en memoria según me indique i, como cada uno es pointer *8
    mov rax, [rdx + rsi*8]
    ;En teoría tengo el que quiero
 

    pop rbp
    ret

notValidIndex:
    xor rax, rax
    pop rbp
    ret