#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ej7.h"

int prefijo_de(char* str1, char* str2){
    /*
    Recorro ambas funciones y veo si difieren en su valor
    si es así ahí termina el prefijo
    */
    int len = strlen(str1);
    int len2 = strlen(str2);
    if (len == 0 || len2 == 0){
        return 0;
    }
    int counter = 0;
    for(int i = 0; i < len; i++){
        //str[i]  //Asi tengo el ascii
        if(str1[i] == str2[i]){
            counter++;
        }else{
            break;
        }
    }
    return counter;
}

char chr(int n) { return (char)n; }


char* quitar_prefijo(char* str1, char* str2){
    /*
    Recorro ambas strings y calculo la longitud de su prefijo
    luego pido la memoria, asigno el valor nulo (final del string)
    y en cada posición asiganada agrego el char correspondiente, que 
    son los que van desde el prefijo hasta la longitud de str2
    */
    int lenB = strlen(str2);
    int prefijoLen = prefijo_de(str1,str2);
    char* res = malloc(8*((lenB - prefijoLen)+1)); //Pido la memoria adecuada
    res[prefijoLen] = 0; //Nulo al final
    int k = 0;
    for(int i = prefijoLen; i < lenB; i++){
        //str[i]  //Asi tengo el ascii
        res[k] = chr(str2[i]);
        k++;
    }
    return res;
}