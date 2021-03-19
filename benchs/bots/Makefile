all: hermitcore hermitux

hermitcore: bots/hermitcore-bin

hermitux: bots/hermitux-bin

bots/hermitux-bin: bots bots/bin
	cp .make_configs/hermitux_config bots/config/make.config
	cd bots && $(MAKE)
	mv bots/bin bots/hermitux-bin
	mkdir bots/bin

bots/hermitcore-bin: bots bots/bin
	cp .make_configs/hermitcore_config bots/config/make.config
	cd bots && $(MAKE)
	mv bots/bin bots/hermitcore-bin
	mkdir bots/bin

bots/bin: bots
	mkdir bots/bin

bots:
	git clone https://github.com/p-jacquot/bots

clean: 
	rm -rf bots
