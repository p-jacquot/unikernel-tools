all: lud_omp

lud_omp:
	cd omp; make

debian:
	cd omp; make debian

hermitux:
	cd omp; make hermitux

hermitcore:
	cd omp; make hermitcore

clean:
	cd omp; make clean ; make -f Makefile.offload clean
