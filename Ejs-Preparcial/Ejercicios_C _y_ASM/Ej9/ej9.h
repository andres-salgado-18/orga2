#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

/*
a) Tenemos que usar memoria dinámica es decir malloc y free
- Para agregarAdelante resevo espacio (con malloc)
- Para valorEn no necesito hacer nada, solo leer en memoria
- Para destruirLista debo usar free para liberar todas las 
*/

typedef struct node_str {
    struct node_t *siguiente;
    int32_t valor;
} node_t;

node_t* agregarAdelante(int32_t valor, node_t* siguiente);
int valueNode(node_t* actual);
node_t* agregarAdelante_asm(int32_t, node_t* siguiente);
int valueNode_asm(node_t* actual);