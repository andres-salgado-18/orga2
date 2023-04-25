CC=c99
CFLAGS= -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter -no-pie
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: main

OBJS := ej11_c.o ej11_asm.o 

main: main.c $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

ej11_c.o: ej11.c ej11.h
	$(CC) $(CFLAGS) -c $< -o $@

ej11_asm.o: ej11.asm ej11.h
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f *.o
	rm -f main tester
	rm -f salida.propios.*
