
BASEDIR=$(PWD)

hermitux : links
	cd unikernels/hermitux && $(MAKE) hermitux
	ln -s $(BASEDIR)/unikernels/hermitux/hermitux/musl/obj/musl-* links/hermitux-cc
	ln -s $(BASEDIR)/unikernels/hermitux/hermitux/hermitux-kernel/prefix/bin/proxy links/hermitux-proxy
	

hermitcore : links
	ln -s /opt/hermit/bin/proxy links/hermitcore-proxy
	ln -s /opt/hermit/bin/x86_64-hermit-gcc links/hermitcore-hermit-gcc

links :
	mkdir links


clean :
	rm -rf links
	cd unikernels/hermitux && $(MAKE) clean
