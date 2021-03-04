# Hermitux

Hermitux is a binary compatible POSIX-like unikernel. It is able to run linux binaries without recompiling them.
It can be very useful, if you want to run an application in an unikernel but don't have its sources.

The repo of Hermitux can be found here : [](https://github.com/ssrg-vt/hermitux)

# Installing Hermitux

## Required packages

Before compiling Hermitux, you need to have HermitCore's toolchain installed on your machine. Follow the instructions of this [README](https://github.com/p-jacquot/unikernel-tools/blob/main/hermitcore/README.md) before typing any command of this README.

## Compiling Hermitux

As usual, clone the repo, update the submodules and use make to compile Hermitux.

```
$ git clone https://github.com/ssrg-vt/hermitux
$ cd hermitux
$ git submodule init && git submodule update
$ make
```


# Running an application with Hermitux

## statically linked application

```
$ sudo HERMIT_ISLE=uhyve HERMIT_TUX=1 ../../../hermitux-kernel/prefix/bin/proxy ../../../hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux your-application
```

## dynamically linked application

```
HERMIT\_ISLE=uhyve HERMIT\_TUX=1 ../../../hermitux-kernel/prefix/bin/proxy ../../../hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux /lib64/ld-linux-x86-64.so.2 ./your-C-application
```


