#include "ej11.h"
int main(){
    str_array_t* myTest1 = strArrayNew(2);
    strArrayAddLast(myTest1, "Hola");
    strArrayAddLast(myTest1, "Chau");
    printf("Mi elemento 0: %s \n", strArrayGet(myTest1, 0));
    printf("Mi elemento 1: %s \n", strArrayGet(myTest1, 1));
    return 0;
}