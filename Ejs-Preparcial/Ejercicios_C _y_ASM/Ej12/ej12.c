#include "ej12.h"

uint32_t strLen(char* a) {
    uint32_t i=0;
    while(a[i]!=0) i++;
    return i;
}


void borrarTerminadasEn(node** l, char c){
    /*
    Recorro toda la lista, nodo por nodo, usando el next,
    así tengo que calcular el length -1 del string guardado
    con lo cual luego verifico si es c su ascii, si lo es, 
    entonces libero dicha memoria (la del string), luego conecto 
    el anterior con el siguiente del actual y el previo del siguiente
    de actual con el next del previo de actual, asi reconecto la liasta
    por último free al nodo en si mismo!
    
    */
    //OJO caso lista vacia!
    node* actual = l; //Voy al primer nodo
    uint32_t lengthString = 0;
    while(actual->next != NULL){
        actual = actual->next;
        lengthString = strLen(actual->string);    
        if (lengthString == 0){continue;} //OJO
        //Si el ultimo es c
        if(actual->string[lengthString -1 ] == c){
            actual->prev->next = actual->next;
            actual->next->prev = actual->prev;
            free(actual->string);
            free(actual);
        }
    }
}