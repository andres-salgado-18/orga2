#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ej1.h"


int main(){
    char A[] = {2,2,2,2,2,2,2};
    char B[] = {5,5,5,5,5,5,5};

    //Para escribir la respuesta
    char* myTest = malloc(7);
    SumarVectores(A,B,myTest,1);
    return 0;
}