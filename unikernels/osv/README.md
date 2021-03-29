# OSv

This readme summarise documentation I gathered while using OSv unikernel.
If you don't find what you're looking for here, you should take a look at the official repo of OSv : [https://github.com/cloudius-systems/osv](https://github.com/cloudius-systems/osv).

# Installing OSv

This section details the necessary steps to install OSV.

## Requirements

Packages required :
* git
* build-essential
* libboost-all-dev
* qemu-system-x86

You can install theses packages with the following commands :
```
$ apt-get install git build-essential libboost-all-dev qemu-system-x86
```

## Compiling OSv unikernel

Clone the git repository of OSv, then compile the sources :
```
$ git clone https://github.com/cloudius-systems/osv
$ cd osv
$ git submodule update --init
$ make
```

# Building applications for OSv

The script `scripts/build` is used to compile an application and link it with OS. Once the unikernel has been built successfully, it can be started with `scripts/run.py`.
Template applications for OSv are located in the `apps` directory. can can build of those application with the build script.
Here are the commands that build the `native-example` application, and run it :
```
$ ./scripts/build image=native-example -j12
$ ./scripts/run.py
```

You should see a "Hello from C code." pop in your console.

> There are a lot of parameters that can be given to the build and run scripts. There are examples of application build on the [OSv repository](https://github.com/cloudius-systems/osv).

# Building custom applications for OSv

A simple way to quickly build application for OSv is to put them in a folder inside the `apps` directory of OSv's repository. That way, you can use the build script to compile and link your application to the unikernel.

> There is also a tool named *Capstan* that have been designed by OSv's creators for building application packages for OSv. If you are interested, you can find a lot of information on its [repository](https://github.com/cloudius-systems/capstan).

Create a folder for your application. We'll assume that it is named `hello`, so as the folder containing it.
In this folder, put the source code of your program.

Write a `module.py` that will contain the following :

```
from osv.modules import api

default = api.run("/hello")
```

Write a `usr.manifest file` containing the following :
```
/hello: ${MODULE_DIR}/hello
```

Finally, write the makefile of your application :
```
.PHONY: module
module: hello

CFLAGS = -fpie -rdynamic -std=gnu99

hello: hello.c
	$(CC) -pie -o $@ $(CFLAGS) $(LDFLAGS) hello.c

clean:
	rm -f hello
```

With this, your application can be build and launched with the following commands :
```
./scripts/build image=hello -j12
./scripts/run.py
```

## Compiling and running OMP applications for OMP

Running OMP application on OSV is quite troubelsome. For now, I have only managed to compile a basic OMP application (a simple program that print threads numbers while counting to 100), but not making it run as a multi-core application. It runs only with 1 thread.

I changed a few lines of code in OSv's sources to be able to compile an OMP application. You can take a look at this link : [https://github.com/p-jacquot/osv](https://github.com/p-jacquot/osv).
