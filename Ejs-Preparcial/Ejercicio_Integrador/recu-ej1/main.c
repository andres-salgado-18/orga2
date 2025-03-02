#include "utils.h"

#include <stdbool.h>
#include <stdlib.h>

#include "test-utils.h"


bool son_iguales(size_t size, uint64_t a[], uint64_t b[]) {
	for (size_t i = 0; i < size; i++) {
		if (a[i] != b[i]) {
			return false;
		}
	}
	return true;
}


int main(int argc, char* argv[]) {
	// Este es el lugar para hacer pruebas mientras se realiza el ejercicio

	//lista_t* lista_sencillaa = LISTA(
	//	PROYECTO(1, 2, 3, 4),
	//	PROYECTO(9999),
	//	PROYECTO()
	//);

	//printf("LEN: %ld\n", lista_len(lista_sencillaa));

	lista_t* lt = LISTA(PROYECTO(1, 0), PROYECTO(0, 4));
	uint64_t* ejemplo8 = tareas_completadas_por_proyecto(lt);
	if (son_iguales(2, ejemplo8, (uint64_t[]){ 1, 1 })) {
		printf("anda!\n");
	}
	free(ejemplo8);

	// A modo de ayuda se ofrece la macros PROYECTO para construir cada
	// nodo de la lista fácilmente.
	lista_t* mi_proyecto = PROYECTO(1, 2, 3, 4);
	lista_t* una_tarea_muy_dificil = PROYECTO(99);
	lista_t* vacio = PROYECTO();

	// Además se tiene la función `imprimir_proyecto` para imprimir un
	// proyecto dado.
	puts("= Proyecto sencillo");
	imprimir_proyecto(mi_proyecto);
	puts("= Proyecto con una sola tarea");
	imprimir_proyecto(una_tarea_muy_dificil);
	puts("= Proyecto vacio");
	imprimir_proyecto(vacio);

	// A la hora de construir la lista se tiene también la macro LISTA que
	// funciona de una forma similar.
	lista_t* lista_vacia = LISTA(); // Es lo mismo que NULL
	lista_t* lista_sencilla = LISTA(
		PROYECTO(1, 2, 3, 4),
		PROYECTO(9999),
		PROYECTO()
	);
	lista_t* muchos_proyectos_vacios = LISTA(
		PROYECTO(),
		PROYECTO(),
		PROYECTO()
	);

	// Y de igual manera se tiene a la funcion imprimir_proyectos para
	// imprimir una lista de proyectos dada.
	puts("= Lista de proyectos vacia");
	imprimir_proyectos(lista_vacia);
	puts("= Lista de proyectos sencilla");
	imprimir_proyectos(lista_sencilla);
	puts("= Lista de proyectos con proyectos vacios");
	imprimir_proyectos(muchos_proyectos_vacios);

	// Las macros LISTA y PROYECTO utilizan la pila, por lo que no deben
	// preocuparse por liberar la memoria.

	// Finalmente, se pueden usar para armar los parámetros in-situ.
	puts("= Proyecto de prueba");
	imprimir_proyecto(PROYECTO(100, 101, 102));
	puts("= Lista de proyectos de ejemplo");
	imprimir_proyectos(LISTA(
		PROYECTO(10, 9, 8),
		PROYECTO(1000),
		PROYECTO(999)
	));

	return 0;
}
