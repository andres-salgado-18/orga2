#include <stdlib.h>
#include <stdio.h>
#include "ej6.h"
int main() {
	char* res = codificacion_cesar_c("CASA",1);
	printf("%s(\"%s\", %d) -> \"%s\"\n", "cesar", "CASA", 1, res); //By honi
	free(res); // Libero ese pedazo de memoria

	char* resAsm = codificacion_cesar_asm("CASA", 2);
	printf("%s(\"%s\", %d) -> \"%s\"\n", "cesar", "CASA", 2, resAsm); //By honi
	free(resAsm);
    return 0;
}
