all: hermitcore hermitux

hermitcore: bots/hermitcore-bin

hermitux: bots/hermitux-bin

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

bots/bin: bots
	mkdir bots/bin

bots:
	git clone https://github.com/p-jacquot/bots

clean: 
	rm -rf bots

benchs : all
	./bots_benchs.sh "commands/*-serial" 50 1
	./bots_benchs.sh "commands/hermitux commands/hermitcore" 50 "2 4 8 16" 

stability : all
	./stability_bench.sh stability-commands/serial-commands 1 50 30 hermitcore /opt/hermit bots/hermitcore-bin
	./stability_bench.sh stability-commands/serial-commands 1 50 30 hermitux /root/hermitux bots/hermitux-bin
	./stability_bench.sh stability-commands/omp-commands "2 4 8 16" 50 30 hermitcore /opt/hermit bots/hermitcore-bin
	./stability_bench.sh stability-commands/serial-commands "2 4 8 16" 50 30 hermitux /root/hermitux bots/hermitux-bin
