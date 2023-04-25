CC=c99
CFLAGS= -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter -no-pie
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: main

OBJS := ej2_c.o ej2_asm.o 

main: main.c $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

ej2_c.o: ej2.c ej2.h
	$(CC) $(CFLAGS) -c $< -o $@

ej2_asm.o: ej2.asm ej2.h
	$(NASM) $(NASMFLAGS) $< -o $@


# ej2_c.o: ej2.c ejs.h
# 	$(CC) $(CFLAGS) -c $< -o $@

# ej2_asm.o: ej2.asm ejs.h
# 	$(NASM) $(NASMFLAGS) $< -o $@
clean:
	rm -f *.o
	rm -f main tester
	rm -f salida.propios.*
