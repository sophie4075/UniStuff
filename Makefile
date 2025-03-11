# Makefile

CC = gcc
CFLAGS = -Wall -Wextra -std=c99
TARGETS = read_hex pipe_and_child

all: $(TARGETS)

read_hex: read_hex.c
	$(CC) $(CFLAGS) -o read_hex read_hex.c

pipe_and_child: pipe_and_child.c
	$(CC) $(CFLAGS) -o pipe_and_child pipe_and_child.c

clean:
	rm -f $(TARGETS)

package:
	tar -czvf PA3.tgz read_hex.c pipe_and_child.c Makefile