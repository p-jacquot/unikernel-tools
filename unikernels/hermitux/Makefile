APP_DIR=../../apps
HELLO_APP=hello-world
OMP-TEST_APP=omp-test

hello-run: hello
	HERMIT_ISLE=uhyve HERMIT_TUX=1 \
				hermitux/hermitux-kernel/prefix/bin/proxy \
				hermitux/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
				hello

hello : 
	cd $(APP_DIR)/$(HELLO_APP) && make \
		CFLAGS=-static \
		LFLAGS=-static
	mv $(APP_DIR)/$(HELLO_APP)/hello . 
	cd $(APP_DIR)/$(HELLO_APP) && make clean

omp-test-run: omp-test
	HERMIT_ISLE=uhyve HERMIT_CPUS=4 OMP_NUM_THREADS=4 HERMIT_TUX=1 \
				hermitux/hermitux-kernel/prefix/bin/proxy \
				hermitux/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
				omp-test

omp-test:
	PWD=$(pwd)
	cd $(APP_DIR)/$(OMP-TEST_APP) && make \
		CC=$(PWD)/hermitux/musl/obj/musl-gcc \
		CFLAGS="-fopenmp -static" \
		LD=$(PWD)/hermitux/musl/obj/musl-gcc \
	    LFLAGS="-fopenmp -L$(PWD)/hermitux/libiomp/build/runtime/src -static"	
	mv $(APP_DIR)/$(OMP-TEST_APP)/omp-test .
	cd $(APP_DIR)/$(OMP-TEST_APP)/ && make clean

clean:
	rm -rf hello omp-test
