#! /bin/bash

stability()
{
    unikernel=$1
    unikernel_dir=$2
    cpu=$3
    output_folder=$4
    bin_folder=$unikernel-bin

    $stability_script $n_try $unikernel $unikernel_dir 200 $bin_folder/bfs $cpu inputs/bfs/graph16M.txt
    $stability_script $n_try $unikernel $unikernel_dir 200 $bin_folder/kmeans_openmp -n $cpu -i inputs/kmeans/819200.txt
    $stability_script $n_try $unikernel $unikernel_dir 200 $bin_folder/lavaMD -cores $cpu -boxes1d 15
    $stability_script $n_try $unikernel $unikernel_dir 200 $bin_folder/lud_omp -n $cpu -s 8192
    mv exec.csv $output_folder/$cpu-cores.csv
    mv exec.log $output_folder/$cpu-cores.log
}


output_dir=$1
n_try=$2
stability_script=../../tools/stability.sh

cpu_list="1 2 4 8 16"

hermitux_dir=/home/pierre/unikernels/hermitux
hermitcore_dir=/opt/hermit

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

if [ ! -d hermitux-bin ]; then
	echo -e "Hermitux binaries not found."
	echo -e "Compiling rodinias."
	make hermitux
fi

echo off > /sys/devices/system/cpu/smt/control

debian_output_dir=$output_dir/debian
hermitux_output_dir=$output_dir/hermitux
hermitcore_output_dir=$output_dir/hermitcore

mkdir -p $debian_output_dir
mkdir -p $hermitux_output_dir
mkdir -p $hermitcore_output_dir

for cores in $cpu_list; do
    echo -e "Running stability tests for $cores cores."

    echo -e "Running debian tests."
    stability ./ . $cores $debian_output_dir

    export HERMIT_CPUS=$cores
    export OMP_NUM_THREADS=$cores
    
    echo -e "Running hermitux tests."
    stability hermitux $hermitux_dir $cores $hermitux_output_dir

    #echo -e "Running hermitcore tests."
    #stability hermitcore $hermitcore_dir $cores $hermitcore_output_dir

    echo -e "\n"
done
