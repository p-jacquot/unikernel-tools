APP_DIR=../../apps
HELLO_APP=hello-world
OMP-TEST_APP=omp-test

hello-run: hello
	HERMIT_ISLE=uhyve /opt/hermit/bin/proxy hello

hello : 
	cd $(APP_DIR)/$(HELLO_APP) && make \
		CC=/opt/hermit/bin/x86_64-hermit-gcc \
		LD=/opt/hermit/bin/x86_64-hermit-gcc
	mv $(APP_DIR)/$(HELLO_APP)/hello . 
	cd $(APP_DIR)/$(HELLO_APP) && make clean

omp-test-run: omp-test
	HERMIT_ISLE=uhyve HERMIT_CPUS=4 OMP_NUM_THREADS=4 \
				/opt/hermit/bin/proxy omp-test

omp-test:
	cd $(APP_DIR)/$(OMP-TEST_APP) && make \
		CC=/opt/hermit/bin/x86_64-hermit-gcc \
		LD=/opt/hermit/bin/x86_64-hermit-gcc 
	mv $(APP_DIR)/$(OMP-TEST_APP)/omp-test .
	cd $(APP_DIR)/$(OMP-TEST_APP)/ && make clean

clean:
	rm -rf hello omp-test
