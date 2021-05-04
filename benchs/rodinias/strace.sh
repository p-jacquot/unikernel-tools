#! /bin/bash

output_dir=$1
cpus_list=$2

if [ $# -lt 2 ]; then
    echo -e "Not enough arguments provided."
    echo -e "Command syntax : $0 <output_dir> <cpus_list>."
    exit 1
fi
 
strace_folder=$output_dir/strace-debian

#disabling hyperthreading
echo off > /sys/devices/system/cpu/smt/control

if [ ! -d inputs ]; then
    echo -e "Inputs folder does not exits."
    echo -e "Creating inputs."
    ./create_inputs.sh
fi

if [ ! -d debian-bin ]; then
   echo -e "Debian binaries not found."
   echo -e "Compiling rodinias."
   make debian
fi

if [ -d $strace_folder ]; then
    echo -e "$strace_folder already exists."
    echo -e "Please delete it manually to avoid making mistakes."
    exit 1
fi

for cpu in $cpus_list; do
    cpu_folder=$strace_folder/$cpu-cores
    mkdir $cpu_folder

    strace -c -o $cpu_folder/bfs debian-bin/bfs $cpu inputs/bfs/graph16M.txt
    strace -c -o $cpu_folder/kmeans_openmp debian-bin/kmeans_openmp -n $cpu -i inputs/kmeans/204800.txt
    strace -c -o $cpu_folder/lavaMD debian-bin/lavaMD -cores $cpu -boxes1d 10
    strace -c -o $cpu_folder/lud_omp -n $cpu -i inputs/lud/2048.dat
done
