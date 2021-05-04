# C compiler
CC = g++
CC_FLAGS = -g -fopenmp -O2

all: bfs

bfs: bfs.cpp 
	$(CC) $(CC_FLAGS) bfs.cpp -o bfs 

debian: bfs.cpp
	clang-11 -O2 -c -fopenmp bfs.cpp
	clang-11 -O2 -fopenmp -liomp5 -L/usr/local/lib -R/usr/local/lib -o bfs bfs.o

hermitux: bfs.cpp
	clang-11 -O2 -c -fopenmp bfs.cpp
	/root/hermitux/musl/obj/musl-gcc -O2 -static -fopenmp -o bfs /root/omp/*.o bfs.o

clean:
	rm -f bfs result.txt
