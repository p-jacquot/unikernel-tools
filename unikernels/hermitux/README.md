# Hermitux

Hermitux is a binary compatible POSIX-like unikernel. It is able to run linux binaries without recompiling them.
It can be very useful, if you want to run an application in an unikernel but don't have its sources.

The repo of Hermitux can be found here : [https://github.com/ssrg-vt/hermitux](https://github.com/ssrg-vt/hermitux)

# Installing Hermitux

## Required packages

Before compiling Hermitux, you need to have HermitCore's toolchain installed on your machine. Follow the instructions of [this README](https://github.com/p-jacquot/unikernel-tools/blob/main/unikernels/hermitcore/README.md) to install this toolchain.

To build Hermitux succesfully, you will need GCC 8 or an older version. If you try to use GCC 9, the compilation of the openMP runtime will fail. You can install GCC 8 with the following command :

```
apt-get install gcc-8
```

## Compiling Hermitux

Clone and build the repo with a make command. Don't forget to export `CC=gcc-8` variable before starting the compilation, so that your gcc-8 will be used for compiling.

```
export CC=gcc-8
git clone https://github.com/ssrg-vt/hermitux
cd hermitux
git submodule init && git submodule update
make
```

## Testing if Hermitux has been successfully installed

To test if Hermitux has been successfully installed, you can use the makefile in this directory to execute test applications. If the compilation and the execution of the applications completes, then Hermitux is correctly built. 

This command will test a simple hello-world program :

```
make hello-run
```

The following command will execute an program using a `pragma omp parallel for`, to check if openMP is functionnal.

```
make omp-test-run
```

# Running an application with Hermitux

## statically linked application

```
HERMIT_ISLE=uhyve HERMIT_TUX=1 \
    hermitux/hermitux-kernel/prefix/bin/proxy \
    hermitux/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
    your-application
```

## dynamically linked application

```
HERMIT_ISLE=uhyve HERMIT_TUX=1 \
    hermitux/hermitux-kernel/prefix/bin/proxy \
    hermitux/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
    /lib64/ld-linux-x86-64.so.2 \
    ./your-C-application
```


