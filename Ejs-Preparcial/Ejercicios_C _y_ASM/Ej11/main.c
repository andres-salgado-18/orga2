#include "ej11.h"
int main(){
    str_array_t* myTest1 = strArrayNew(3);
    strArrayAddLast(myTest1, "Hola");
    strArrayAddLast(myTest1, "Chau");
    strArrayAddLast(myTest1, "Mundo");
    printf("Mi elemento 0: %s \n", strArrayGet(myTest1, 0));
    printf("Mi elemento 1: %s \n", strArrayGet(myTest1, 1));
    printf("Mi elemento 2: %s \n", strArrayGet(myTest1, 2));
    return 0;
}