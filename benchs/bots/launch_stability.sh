#! /bin/bash

mkdir results

./stability_bench.sh /root/bots/hermitux-default-bin 2 hermitux /root/hermitux 

mkdir results/hermitux-default
mv exec.* results/hermitux-default

./stability_bench.sh /root/bots/hermitux-omp-llvm-bin 2 hermitux /root/hermitux 

mkdir results/hermitux-omp-llvm
mv exec.* results/hermitux-omp-llvm

./stability_bench.sh /root/bots/hermitcore-bin 2 hermitcore /opt/hermit

mkdir results/hermitcore
mv exec.* results/hermitcore
