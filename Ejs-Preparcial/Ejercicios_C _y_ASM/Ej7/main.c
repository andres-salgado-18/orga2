#include <stdlib.h>
#include <stdio.h>
#include "ej7.h"
int main() {
    printf("Prefijo(Astro): %d \n", prefijo_de("Astronomia","Astrologia"));
    printf("Prefijo(Pin) %d \n" , prefijo_de("Pinchado", "Pincel"));
    printf("Prefijo(vacio) %d \n", prefijo_de("Boca", "River"));
    char* test1 = quitar_prefijo("Astronomia","Astrologia");
    printf("Prefijo(Astro): %s \n", test1);
    free(test1);
    char* test2 = quitar_prefijo("Pinchado", "Pincel");
    printf("Prefijo(Pin) %s \n" , test2);
    free(test2);
    char* test3 = quitar_prefijo("Boca", "River");
    printf("Prefijo(vacio) %s \n", test3);
    free(test3);
    return 0;
}