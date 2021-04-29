#! /bin/bash

debian_exec(){
    output_file=$1
    prog=$2
    shift
    shift
    args=$@
    ./debian-bin/$prog $args >> $output_file
}

hermitux_exec(){
    output_file=$1
    prog=$2
    shift
    shift
    args=$@
    export HERMIT_ISLE=uhyve
    export HERMIT_TUX=1
    export HERMIT_CPUS=$n_cpus
    export HERMIT_MEM=4G
    $hermitux_dir/hermitux-kernel/prefix/bin/proxy \
        $hermitux_dir/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
        hermitux-bin/$prog $args >> $output_file
}

repeat(){
    n_times=$1
    n_cpus=$2
    prog_name=$3
    shift
    shift
    shift
    args=$@

    for ((i = 0; i < $n_times; i++)); do
        debian_exec $prog_name.log $prog_name $args
    done
    mv $prog_name.log $debian_output_dir/$cpu_folder/

    for ((i = 0; i < $n_times; i++)); do
        hermitux_exec $prog_name.log $prog_name $args
    done
    mv $prog_name.log $hermitux_output_dir/$cpu_folder/
}

hermitux_dir=/root/hermitux

if [ $# -lt 3 ]; then
    echo -e "Error : not enough arguments provided."
    echo -e "commands syntax : $0 <output_dir> <n_times> <cpus_list>"
    exit 1
fi


output_dir=$1
n=$2
cpus_list=$3

if [ ! -d inputs ]; then
    echo -e "Inputs folder does not exits."
    echo -e "Creating inputs."
    ./create_inputs.sh
fi

if [ ! -d $output_dir ]; then
    echo -e "Output directory does not exists."
    echo -e "Creating output directory."
    mkdir $output_dir
fi

debian_output_dir=$output_dir/debian
hermitux_output_dir=$output_dir/hermitux

mkdir $debian_output_dir
mkdir $hermitux_output_dir

for cpu in $cpus_list; do
    
    cpu_folder=$cpu-cores
    mkdir $debian_output_dir/$cpu_folder
    mkdir $hermitux_output_dir/$cpu_folder

    repeat $n $cpu bfs $cpu inputs/bfs/graph1MW_6.txt
    repeat $n $cpu kmeans_openmp -n $cpu -i inputs/kmeans/kdd_cup.txt
    repeat $n $cpu lavaMD -cores $cpu -boxes1d 10
    repeat $n $cpu lud_omp -n $cpu -i inputs/lud/512.dat

done
