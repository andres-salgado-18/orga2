#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ej1.h"


int main(){
    char A[] = {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2};
    char B[] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};

    //Para escribir la respuesta
    char* myTest = malloc(32);
    SumarVectores(A,B,myTest,32);
    return 0;
}