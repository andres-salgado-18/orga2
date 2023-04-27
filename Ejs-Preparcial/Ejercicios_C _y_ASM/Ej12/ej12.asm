global borrarTerminadasEn
extern malloc
extern strLen
extern strClone
section .data


section .text

;void borrarTerminadasEn(node** l, char c)
borrarTerminadasEn:
    push rbp 
    mov rbp, rsp 
    push r12 ; guardo l -> Es deir el inicio de la lista (?)
    push r13 ;Alineada; Guardo c
    



    pop rbp 
    ret