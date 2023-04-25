#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ej9.h"
#define LEN 21
int main(){
    node_t* lista = agregarAdelante(120,NULL);
    printf("Val: %d \n", valueNode(lista));
    lista = agregarAdelante(10, lista);
    printf("Val: %d\n", valueNode(lista));
    lista = agregarAdelante(4, lista);
    printf("Val: %d\n", valueNode(lista));

    node_t* lista2 = agregarAdelante_asm(120, NULL);
    printf("Val: %d \n", valueNode_asm(lista2));
    lista2 = agregarAdelante_asm(10, lista2);
    printf("Val: %d\n", valueNode_asm(lista2));
    lista2 = agregarAdelante_asm(4, lista2);
    printf("Val: %d\n", valueNode_asm(lista2));
    return 0;
}