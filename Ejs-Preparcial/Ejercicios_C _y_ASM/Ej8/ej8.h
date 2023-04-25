#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#define NAME_LEN    21

typedef struct cliente_str {
    char nombre[NAME_LEN];
    char apellido[NAME_LEN];
    uint64_t compra;
    uint32_t dni;
} cliente_t;

typedef struct __attribute__((__packed__)) packed_cliente_str {
    char nombre[NAME_LEN];
    char apellido[NAME_LEN];
    uint64_t compra;
    uint32_t dni;
} __attribute__((packed)) packed_cliente_t;


void random_choice(cliente_t *arr, uint32_t arr_length);
