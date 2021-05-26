
debian :
	cd bfs && make debian
	cd lavaMD && make debian
	cd kmeans && make debian
	cd lud && make debian
	mkdir debian-bin
	cp bfs/bfs debian-bin/
	cp lavaMD/lavaMD debian-bin/
	cp kmeans/kmeans_openmp/kmeans debian-bin/kmeans_openmp
	cp kmeans/kmeans_serial/kmeans debian-bin/kmeans_serial
	cp lud/omp/lud_omp debian-bin/lud_omp
	make clean

hermitux :
	cd bfs && make hermitux
	cd lavaMD && make hermitux
	cd kmeans && make hermitux
	cd lud && make hermitux
	mkdir hermitux-bin
	cp bfs/bfs hermitux-bin/
	cp lavaMD/lavaMD hermitux-bin/
	cp kmeans/kmeans_openmp/kmeans hermitux-bin/kmeans_openmp
	cp kmeans/kmeans_serial/kmeans hermitux-bin/kmeans_serial
	cp lud/omp/lud_omp hermitux-bin/lud_omp
	make clean

hermitcore :
	cd bfs && make hermitcore
	cd lavaMD && make hermitcore
	cd kmeans && make hermitcore
	cd lud && make hermitcore
	mkdir hermitcore-bin
	cp bfs/bfs hermitcore-bin/
	cp lavaMD/lavaMD hermitcore-bin/
	cp kmeans/kmeans_openmp/kmeans hermitcore-bin/kmeans_openmp
	cp kmeans/kmeans_serial/kmeans hermitcore-bin/kmeans_serial
	cp lud/omp/lud_omp hermitcore-bin/lud_omp
	make clean


clean :
	cd bfs && make clean
	cd lavaMD && rm -f *.o
	cd kmeans && make clean
	cd lud && make clean

super-clean: clean
	rm -rf *-bin
