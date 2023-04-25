#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "ej6.h"

int ord(char c) { return (int)c; }

char chr(int n) { return (char)n; }

char* codificacion_cesar_c(char* str, int x){
    char* result = malloc((strlen(str) + 1)*8); //Pido espacio para escribir
    result[strlen(str)] = 0; //El nulo /00
    for(size_t i = 0; i < strlen(str); i++){
        result[i] = chr((ord(str[i] + x))); //OJO no sirve para cuando x da la vuelta!
    }
    return result;
}