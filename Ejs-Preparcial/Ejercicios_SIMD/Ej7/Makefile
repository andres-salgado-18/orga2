CC=c99
CFLAGS= -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter -no-pie
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: main

OBJS := ej7_c.o ej7_asm.o 

main: main.c $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

ej7_c.o: ej7.c ej7.h
	$(CC) $(CFLAGS) -c $< -o $@

ej7_asm.o: ej7.asm ej7.h
	$(NASM) $(NASMFLAGS) $< -o $@


# ej2_c.o: ej2.c ejs.h
# 	$(CC) $(CFLAGS) -c $< -o $@

# ej2_asm.o: ej2.asm ejs.h
# 	$(NASM) $(NASMFLAGS) $< -o $@
clean:
	rm -f *.o
	rm -f main tester
	rm -f salida.propios.*
