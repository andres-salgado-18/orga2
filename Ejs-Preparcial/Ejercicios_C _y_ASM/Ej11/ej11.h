#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>


typedef struct str_array {
    uint8_t size;
    uint8_t capacity;
    char** data;
} str_array_t;

str_array_t* strArrayNew(uint8_t capacity);
uint8_t strArrayGetSize(str_array_t* a);
void  strArrayAddLast(str_array_t* a, char* data);
char* strArrayGet(str_array_t* a, uint8_t i);
void  strArrayDelete(str_array_t* a);


int32_t strCmp(char* a, char* b);

char* strClone(char* a, char* p);

void strDelete(char* a);

uint32_t strLen(char* a);

void strPrint(char* a, FILE* pFile);