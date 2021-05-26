all: OPENMP/kmeans SERIAL/kmeans

OPENMP/kmeans:
	cd kmeans_openmp; make
	
SERIAL/kmeans:
	cd kmeans_serial; make

debian:
	cd kmeans_openmp; make debian
	cd kmeans_serial; make debian
hermitux:
	cd kmeans_openmp; make hermitux
	cd kmeans_serial; make hermitux

hermitcore:
	cd kmeans_openmp; make hermitcore
	cd kmeans_serial; make hermitcore

clean:
	cd kmeans_serial; make clean
	cd kmeans_openmp; make clean
