# Rumprun Unikernel

Rumprun is a Rump kernel based on the netBSD project.

This README summarise information I gathered by looking at the Rumprun repository and wiki. If you're aving trouble that I can't resolve with this README, you may need to check more in details the following links :

* Rumprun wiki : [https://github.com/rumpkernel/wiki/wiki](https://github.com/rumpkernel/wiki/wiki)
* Rumprun repo : [https://github.com/rumpkernel/rumprun](https://github.com/rumpkernel/rumprun)
* Rumprun-packages : [https://github.com/rumpkernel/rumprun-packages](https://github.com/rumpkernel/rumprun-packages)

> Rumprun-packages repository is worth looking at when you have trouble compiling an application. There are a lot of working compilation scripts and makefiles in this repo, and even if they don't work for some, you still can look at the command they issue to reproduce their behaviour.

# installing Rumprun

## Requirements

In order to be able to compile & install Rumprun, you need the following packages :

* git
* zlib1g-dev
* build-essential

You can install them with the following command :

```
$ apt-get install git zlib1g-dev build-essential
```

> Depending on wich hypervisor you want to use to boot your Rumprun Kernel, you may need to install `qemu-system-x86` on your machine.

## Build the Rumprun kernel

Clone the repo, and launch the script `./build-rr.sh`. This script will generate its own wrappers, that we will use later, so if you want to use a particular compiler be sure to set the `CC` environment variable.

> You may experience compilation errors, when running ./build-rr.sh. If it the case, try modifying the `build-rr.sh` script at the line `361`, by adding the `-F CPPFLAGS=-Wno-error` flag. The line should look like this : ```&& extracflags="$extracflags -F CPPFLAGS=-Wimplicit-fallthrough=0 -F CPPFLAGS=-Wno-error"```

```
$ git clone https://github.com/rumpkernel/rumprun
$ cd rumprun
$ git submodule update --init
$ CC=cc ./build-rr.sh hw
```

Once the script has completed, you have build Rumprun ! Congratulation !

> The tools have been installed in the `rumprun/bin` directory of the repo. You may want to put this folder to your `PATH` to access the toolchain quickly.


# Compiling an application for Rumprun

> In this part, we assume that Rumprun's toolchain is accessible from where you are in your filesystem, thanks to the `PATH` variable, or symbolic links for example.

Let's assume you have a C program `hello.c`, that print some things to the standard output.

You need to compile this program with Rumprun's compiler :

```
$ x86_64-rumprun-netbsd-gcc hello.c -o hello
```

The program has been compiled, but it's not ready to be run by Rumprun yet. Indeed, it contains only the binaries of your hello code. Transform your executable into a bootable unikernel with the following command :

```
$ rumprun-bake hw-generic rumprun-hello hello
```

## Compiling an OMP application for Rumprun

To compile an OpenMP application for Rumprun, you need to compile your own OpenMP library for Rumprun. Follow the following commands to compile OpenMP, and your OpenMP application :

```
$ git clone https://github.com/gcc-mirror/gcc
```

Be careful about the version of the `x86_64-rumprun-netbsd-gcc` compiler that you are using to compile. Check its number with the command :
```
x86_64-rumprun-netbsd-gcc --version
```
and then, checkout to the correct branch of the gcc's repo.

> For example, if your version of rumprun's gcc is `9.3.0`, then checkout to `releases/gcc-9`.

```
$ git checkout releases/gcc-X
$ cd ..
$ mkdir build-gcc include lib
$ cd build-gcc
$ ./../gcc/libgomp/configure --host=x86_64-rumprun-netbsd \
    --disable-multilib \
    --disable-shared
$ cp omp.h ../include/
$ cp .libs/libgomp.a ../lib/
```

You have compiled your OpenMP library for Rumprun !
To compile an OpenMP application for Rumprun, add the `include` and `lib` folder to your compilation command :

```
$ x86_64-rumprun-netbsd-gcc main-omp.c -o main -f openmp -I include/ -L lib/ -lpthread -lgomp
```

Don't forget to bake your executable with `rumprun-bake` !

# Running a Rumprun unikernel

Here are commands for quickly running your Rumprun program :

## Qemu

The following command runs a `rumprun-hello` program.
```
$ rumprun qemu -i -g curses rumprun-hello
```

## KVM

The following command runs a `rumprun-hello` program.
```
$ rumprun kvm -i -g '-nographic -vga none` rumprun-hello
```
