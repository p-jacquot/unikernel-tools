# C compiler
CC = gcc
CC_FLAGS = -g -fopenmp -O2 

kmeans: cluster.o getopt.o kmeans.o kmeans_clustering.o 
	$(CC) $(CC_FLAGS) cluster.o getopt.o kmeans.o kmeans_clustering.o  -o kmeans

%.o: %.[ch]
	$(CC) $(CC_FLAGS) $< -c

cluster.o: cluster.c 
	$(CC) $(CC_FLAGS) cluster.c -c
	
getopt.o: getopt.c 
	$(CC) $(CC_FLAGS) getopt.c -c
	
kmeans.o: kmeans.c 
	$(CC) $(CC_FLAGS) kmeans.c -c

kmeans_clustering.o: kmeans_clustering.c kmeans.h
	$(CC) $(CC_FLAGS) kmeans_clustering.c -c

debian:
	clang-11 -O2 -c -fopenmp *.c
	clang-11 -O2 -fopenmp -liomp5 -L/usr/local/lib -R/usr/local/lib -o kmeans *.o

hermitux:
	clang-11 -O2 -c -fopenmp *.c
	/root/hermitux/musl/obj/musl-gcc -O2 -static -fopenmp -o kmeans /root/omp/*.o *.o

clean:
	rm -f *.o *~ kmeans 
