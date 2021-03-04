# HermitCore

HermitCore is a lightweight POSIX-like Unikernel developped for HPC applications.

In this readme, I summarise some informations I've gathered about this unikernel.
You can find more information at this link : [](https://github.com/hermitcore/libhermit).

# Installing HermitCore 

If you don't want to type the commands, the `install.sh` script will execute the following commands for you.

> You need to be root to install HermitCore !

## Required packages

First, be sure that your machine has KVM enabled. Without KVM, it wiil be impossible to run uhyve, HermitCore's hypervisor.

Then, install the following packages :

```
$ apt-get update
$ apt-get install git build-essential cmake nasm apt-transport-https wget libgmp-dev bsdmainutils libseccomp-dev python libelf-dev
```

## Installing HermitCore's toolchain

In order to build your unikernel application, HermitCore comes with its own toolchain.

You can install the toolchain with the following commands :

```
$ echo "deb [trusted=yes] https://dl.bintray.com/hermitcore/ubuntu bionic main" | tee -a /etc/apt/sources.list
$ apt-get update
$ apt-get install binutils-hermit newlib-hermit pte-hermit gcc-hermit libomp-hermit libhermit
```

Installing HermitCore this way will put the toolchain at `/opt/hermit/`. If you decide to compile it yourself, you will be able to choose where it will be installed.

> In this repo, we assume that the toolchain is located at `/opt/hermit`

# Compiling an application for HermitCore

Because we want to build a whole kernel, and not a single application, we need to build our application with HermitCore's toolchain.

> The tools we need to compile our application (e.g gcc for example) are located at `/opt/hermit/bin`

Let's say you have a simple Hello World program written in C. You need to compile it with HermitCore's gcc :

```
$ /opt/hermit/bin/x86_64-hermit-gcc -o hello hello.c
```

Once the program is compiled, you can run it with the proxy to make it boot as a kernel:

```
$ /opt/hermit/bin/proxy hello
```

Congratulation ! You've run a program with HermitCore !
