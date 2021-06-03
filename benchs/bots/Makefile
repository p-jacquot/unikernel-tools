TARGET_DIR ?=.

all: hermitcore hermitux debian

hermitcore: bots/hermitcore-bin

hermitux: bots/hermitux-bin

debian: bots/debian-bin

bots/hermitux-bin: bots bots/bin
	cp .make_configs/hermitux_config bots/config/make.config
	cd bots && $(MAKE) clean
	cd bots && $(MAKE)
	mv bots/bin bots/hermitux-bin
	mkdir bots/bin

bots/hermitcore-bin: bots bots/bin
	cp .make_configs/hermitcore_config bots/config/make.config
	cd bots && $(MAKE) clean
	cd bots && $(MAKE)
	mv bots/bin bots/hermitcore-bin
	mkdir bots/bin

bots/debian-bin: bots bots/bin
	cp .make_configs/debian_config bots/config/make.config
	cd bots && $(MAKE) clean
	cd bots && $(MAKE)
	mv bots/bin bots/debian-bin
	mkdir bots/bin

bots/bin: bots
	mkdir bots/bin

bots:
	git clone https://github.com/p-jacquot/bots

clean: 
	rm -rf bots

all-exp: benchs stability strace

benchs : all
	./../../tools/benchs.sh "commands/serial/*" $(TARGET_DIR) 20 1
	./../../tools/benchs.sh "commands/omp-tasks/*" $(TARGET_DIR) 20 "1 2 4 8 16" 
	./../../tools/benchs.sh "commands/omp-tasks-manual-tied/*" $(TARGET_DIR) 20 "1 2 4 8 16"

stability : all
	./../../tools/stability_bench.sh "stability-commands/*-serial" $(TARGET_DIR) 20 1
	./../../stability_bench.sh "stability-commands/*-omp" $(TARGET_DIR) 20 "2 4 8 16"

strace : all
	mkdir -p $(TARGET_DIR)/debian-strace $(TARGET_DIR)/hermitux-strace $(TARGET_DIR)/hermitcore-strace
	./../../tools/strace_benchs.sh stability-commands/debian-serial $(TARGET_DIR)/debian-strace 1
	./../../tools/strace_benchs.sh stability-commands/debian-omp $(TARGET_DIR)/debian-strace 8
	./../../tools/strace_benchs.sh stability-commands/hermitux-serial $(TARGET_DIR)/hermitux-strace 1
	./../../tools/strace_benchs.sh stability-commands/hermitux-omp $(TARGET_DIR)/hermitux-strace 8
	./../../tools/strace_benchs.sh stability-commands/hermitcore-serial $(TARGET_DIR)/hermitcore-strace 1
	./../../tools/strace_benchs.sh stability-commands/hermitcore-omp $(TARGET_DIR)/hermitcore-strace 8
