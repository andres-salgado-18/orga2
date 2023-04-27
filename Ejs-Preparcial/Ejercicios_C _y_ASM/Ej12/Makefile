CC=c99
CFLAGS= -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter -no-pie
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: main

OBJS := ej12_c.o ej12_asm.o 

main: main.c $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

ej12_c.o: ej12.c ej12.h
	$(CC) $(CFLAGS) -c $< -o $@

ej12_asm.o: ej12.asm ej12.h
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f *.o
	rm -f main tester
	rm -f salida.propios.*