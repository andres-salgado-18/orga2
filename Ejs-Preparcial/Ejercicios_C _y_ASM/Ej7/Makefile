CC=c99
CFLAGS= -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter -no-pie
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: main

OBJS := ej7_c.o 

main: main.c $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

ej7_c.o: ej7.c ej7.h
	$(CC) $(CFLAGS) -c $< -o $@


clean:
	rm -f *.o
	rm -f main tester
	rm -f salida.propios.*