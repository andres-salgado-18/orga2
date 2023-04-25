#include "ej9.h"
#define NODE_SIZE 16
node_t* agregarAdelante(int32_t valorNew, node_t* siguienteNew){
    node_t* nuevo = (struct node_str*) malloc(sizeof(NODE_SIZE));
    nuevo->valor = valorNew;
    nuevo->siguiente = (struct node_t*) siguienteNew;
    return nuevo;
}

int valueNode(node_t* actual){
    return actual->valor;
}