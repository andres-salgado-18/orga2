#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef struct node_t {
struct node_t *next;
struct node_t *prev;
char *string;
} node;

void borrarTerminadasEn(node** l, char c);
uint32_t strLen(char* a);