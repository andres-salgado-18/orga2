Un sistema de manejo de proyectos mantiene todos los proyectos registrados en
una gran lista enlazada. Cada proyecto tiene un array de tareas a ser
completadas y cada tarea posee una dificultad numérica (la dificultad de
realizarla). Para poder visualizar rápidamente la dificultad de los proyectos
se mantiene una copia precalculada de la suma de las dificultades. Esta copia
debe ser actualizada cada vez que se modifica el proyecto.

```ditaa
+------------+   +------------+   +------------+
|  next: ptr---->|  next: ptr---->|  next: ptr----> NULL
|   sum: u32 |   |   sum: u32 |   |   sum: u32 |
|  size: u64 |   |  size: u64 |   |  size: u64 |
| array: ptr |   | array: ptr |   | array: ptr |
+---|--------+   +---|--------+   +--|---------+
    |                |               |
    V                V               V
 [x0, x1, ...]    [y0, y1, ...]   [z0, z1, ...]
```

Para mejorar el rendimiento y bajar los costos de alojamiento del sistema se
solicita implementar las operaciones más comunes en ensamblador. La estructura
utilizada en C es:

```c
typedef struct lista_s {
  // Siguiente elemento de la lista o NULL si es el final
  struct lista_s*  next;
  // Suma de los elementos en array
  uint32_t  sum;
  // Cantidad de elementos en array
  uint64_t  size;
  // El array en cuestión que posee este proyecto de la lista
  uint32_t* array;
} lista_t;
```

Notar que:
  - La lista vacía es `NULL`
  - Si `size` es 0 entonces no deberíamos leer nada del campo `array`
  - Al modificar `array` no necesitamos recalcular la `sum`, alcanza con
    sumarle o restarle la cantidad de puntos afectados

a. (5 puntos) Realizar un diagrama de la estructura en cuestión. ¿Cuál es el
   offset de cada campo? ¿Cuánto padding posee la estructura? ¿Cuál es su
   requisito de alineación?

   +-------------------------------------------------------+
   | `lista_t`                                             |
   +=======================================================+
   | campo | tipo       | tamaño   | offset   | alineación |
   +=======+============+==========+==========+============+
   | next  | `lista_t*` | __ bytes | __ bytes | __ bytes   |
   +-------+------------+----------+----------+------------+
   | sum   | `uint32_t` | __ bytes | __ bytes | __ bytes   |
   +-------+------------+----------+----------+------------+
   | size  | `uint64_t` | __ bytes | __ bytes | __ bytes   |
   +-------+------------+----------+----------+------------+
   | array | `uint64_t` | __ bytes | __ bytes | __ bytes   |
   +-------+------------+----------+----------+------------+
   | TOTAL              | __ bytes |          | __ bytes   |
   +--------------------+----------+----------+------------+

   La estructura `lista_t` tiene __ bytes de padding.

b. (20 puntos) Implementar `uint32_t proyecto_mas_dificil(lista_t*)` que dada
   una lista de proyectos calcula la cantidad de puntos de el más difícil de
   ellos.

   - La solución debe recorrer la lista pasada como parámetro y encontrar el
     valor más grande de los campos `sum`
   - La solución no debe modificar la lista pasada como parámetro
   - El proyecto más difícil de la lista vacía (`NULL`) tiene dificultad 0

   Ejemplos:
     - proyecto_mas_dificil((1, 2, 3) -> (98, 99) -> (9) -> NULL) = 197
     - proyecto_mas_dificil(() -> () -> () -> NULL) = 0
     - proyecto_mas_dificil((3) -> (2, 1) -> (1, 1, 1) -> NULL) = 3
     - proyecto_mas_dificil(() -> (1, 1, 1) -> (100) -> NULL) = 100
     - proyecto_mas_dificil(NULL) = 0

c. (20 puntos) Implementar `void marcar_tarea_completada(lista_t*, size_t)` que
   dada una lista y un índice `i` marca a la `i`ésima tarea como completada.

   - La 0ésima tarea es la primer tarea del primer proyecto no-vacío
   - La lista pasada como parámetro puede tener proyectos sin tareas

     Ejemplo:
       La tercera tarea de la lista `(1, 2, 3) -> () -> () -> (9) -> NULL` es
       aquella con dificultad 9.

   - El valor de `sum` deberá reflejar los cambios

     Ejemplo:
       Luego de marcar la quinta tarea de `(0, 0, 99) -> NULL` como completada
       la suma del primer nodo de la lista pasa de valer 99 a valer 0.

   - El índice trata a la lista de arrays como un array gigante

     Ejemplo:
       La tercera tarea de la lista `(1, 2, 3) -> (4, 5, 6) -> NULL` es aquella
       con dificultad 4.

   - Se puede asumir que el índice es válido

   Ejemplos:
     - marcar_tarea_completada((1, 2, 3) -> NULL, 0)
         La lista queda (0, 2, 3) -> NULL
     - marcar_tarea_completada(() -> (1) -> NULL, 0)
         La lista queda () -> (0) -> NULL
     - marcar_tarea_completada((1, 2, 3) -> (4, 5) -> NULL, 4)
         La lista queda (1, 2, 3) -> (4, 0) -> NULL
     - marcar_tarea_completada((1) -> (2) -> (3) -> NULL, 2)
         La lista queda (1) -> (2) -> (0) -> NULL
     - marcar_tarea_completada((1) -> (2) -> (3) -> NULL, 1)
         La lista queda (1) -> (0) -> (3) -> NULL

d. (15 puntos) Implementar `uint64_t* tareas_completadas_por_proyecto(lista_t*)`
   que dada una lista devuelve un array con la cantidad de tareas completadas
   en cada proyecto.

   - Si se provee a la lista vacía como parámetro (`NULL`) la respuesta puede
     ser `NULL` o el resultado de `malloc(0)`
   - Los proyectos sin tareas tienen cero tareas completadas
   - Los proyectos sin tareas deben aparecer en el array resultante
   - Se provee una implementación esqueleto en C si se desea seguir el esquema
     implementativo recomendado

   Ejemplos:
     - tareas_completadas_por_proyecto(NULL) = [] ó NULL
     - tareas_completadas_por_proyecto(() -> NULL) = [0]
     - tareas_completadas_por_proyecto(() -> () -> NULL) = [0, 0]
     - tareas_completadas_por_proyecto((1, 2, 3) -> NULL) = [0]
     - tareas_completadas_por_proyecto((0, 2, 0) -> NULL) = [2]
     - tareas_completadas_por_proyecto((1, 2) -> (3, 4) -> NULL) = [0, 0]
     - tareas_completadas_por_proyecto((1, 2) -> (0, 0) -> NULL) = [0, 2]
     - tareas_completadas_por_proyecto((1, 0) -> (0, 4) -> NULL) = [1, 1]

   Recomendaciones:
     - Implementar la función auxiliar `uint64_t lista_len(lista_t*)` para
       calcular el tamaño de la lista.
     - Implementar la función auxiliar
       `uint64_t tareas_completadas(uint32_t* array, size_t tamaño)` para
       calcular la cantidad de tareas completadas en uno de los arrays.

Recomendaciones generales:
- Programar las funciones en C antes de hacerlo en ensamblador
- Asegurarse de que el código ensamblador escrito exprese la intención
  esperada (es decir, sea fácil de leer)
- Comentar claramente el código, de ser posible
- En caso de encontrar errores, revisar el ABI manualmente y el uso de la
  memoria con valgrind
- En caso de no comprender un mensaje de error de valgrind o el compilador
  preguntar a un docente

El `Makefile` del ejercicio 1 genera cuatro binarios `main_c`, `main_asm`,
`tests_c` y `tests_asm`. Los primeros dos son para pruebas personales mientras
que los otros dos poseen los tests de la cátedra. El sufijo `_c` y `_asm`
refiere a cuál de las implementaciones está compilada en cada uno de ellos.

Los siguientes comandos están disponibles para su conveniencia:
- `make all`: Crea los binarios `main_c`, `main_asm`, `tests_c` y `tests_asm`
- `make clean`: Borra todos los archivos generados
- `make run_tests`: Compila y corre los tests usando la implementación en
  ensamblador.
  - Los tests se ejecutan utilizando valgrind. Si no desea hacer uso de la
    herramienta puede ejecutar `./tests_c` manualmente
  - Si valgrind no detecta errores de memoria se imprime "No se detectaron
    errores de memoria" en la terminal
- `make run_c_tests`: Compila y corre los tests usando la implementación en
  ensamblador.
  - Los tests se ejecutan utilizando valgrind. Si no desea hacer uso de la
    herramienta puede ejecutar `./tests_c` manualmente
  - Si valgrind no detecta errores de memoria se imprime "No se detectaron
    errores de memoria" en la terminal
