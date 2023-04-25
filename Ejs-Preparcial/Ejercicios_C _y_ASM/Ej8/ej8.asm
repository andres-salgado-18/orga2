global random_choice
extern strlen
extern malloc
extern rand
extern random_choice

section .data

section .text

random_choice:
    push rbp
    mov rbp, rsp
    mov rax, 2
    pop rbp
    ret