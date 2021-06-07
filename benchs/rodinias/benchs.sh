#! /bin/bash

format_logs()
{
    for folder in $debian_output_dir $hermitux_output_diri $hermitcore_output_dir; do
        cd $folder/$cpu_folder
        for logfile in *.log; do
            time_file=$(basename -s .log $logfile).csv
            if [ ! -e $time_file ]; then
                cat $logfile | grep "Time Program" | awk '{print $4 ";"}' >> $time_file
            else
                echo -e "$folder/$cpu_folder/$time_file already exists.\
\nSkipping formatting."
            fi
        done
        cd $current_dir
        echo -e "Finished formatting files inside $folder."
    done
    echo -e "Formatting finished."
}

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
    ret=1
    while [ $ret != "0" ]; do
        $timeout \
        $hermitux_dir/hermitux-kernel/prefix/bin/proxy \
            $hermitux_dir/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
            hermitux-bin/$prog $args > tmp
        ret=$?
    done
    cat tmp >> $output_file
}

hermitcore_exec(){
    output_file=$1
    prog=$2
    shift
    shift
    args=$@
    export HERMIT_ISLE=uhyve
    export HERMIT_TUX=0
    export HERMIT_CPUS=$n_cpus
    export HERMIT_MEM=4G
    ret=1
    while [ $ret != "0" ]; do
        $timeout \
        $hermitcore_dir/bin/proxy hermitcore-bin/$prog $args > tmp
        ret=$?
    done
    cat tmp >> $output_file
}

repeat(){
    n_times=$1
    n_cpus=$2
    prog_name=$3
    shift
    shift
    shift
    args=$@
    
    if [ ! -e $debian_output_dir/$cpu_folder/$prog_name.log ]; then
        for ((i = 0; i < $n_times; i++)); do
            echo -n -e "\rdebian exec n° : $i"
            debian_exec $prog_name.log $prog_name $args
        done
        mv $prog_name.log $debian_output_dir/$cpu_folder/
    else
        echo -e -n "Debian log file already exists. Skipping execution."
    fi

    echo
    
    if [ ! -e $hermitux_output_dir/$cpu_folder/$prog_name.log ]; then
        for ((i = 0; i < $n_times; i++)); do
            echo -n -e "\rhermitux exec n° : $i"
            hermitux_exec $prog_name.log $prog_name $args
        done
        mv $prog_name.log $hermitux_output_dir/$cpu_folder/
    else
        echo -e "Hermitux log file already exists. Skipping execution."
    fi
    
    echo

    if [ $prog_name == "lavaMD" ] || [ $prog_name == "lud_omp" ]; then
        
        if [ ! -e $hermitcore_output_dir/$cpu_folder/$prog_name.log ]; then
            for ((i = 0; i < $n_times; i++)); do
                echo -n -e "\rhermitcore exec n° : $i"
                hermitcore_exec $prog_name.log $prog_name $args
            done
            mv $prog_name.log $hermitcore_output_dir/$cpu_folder/
        else
            echo -e "HermitCore log file already exists. Skipping execution."
        fi
    
    fi
}

hermitux_dir=/root/hermitux
hermitcore_dir=/opt/hermit
timeout="timeout -s SIGKILL --foreground 120"

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

if [ ! -d hermitcore-bin ]; then
    echo -e "HermitCore binaries not found."
    echo -e "Compiling rodinias."
    make hermitcore
fi

#disabling hyperthreading
echo off > /sys/devices/system/cpu/smt/control

current_dir=$(pwd)
debian_output_dir=$output_dir/debian
hermitux_output_dir=$output_dir/hermitux
hermitcore_output_dir=$output_dir/hermitcore

mkdir $debian_output_dir
mkdir $hermitux_output_dir
mkdir $hermitcore_output_dir

for cpu in $cpus_list; do
    
    echo -e "Runnning benchs for $cpu cores."
    cpu_folder=$cpu-cores
    mkdir $debian_output_dir/$cpu_folder
    mkdir $hermitux_output_dir/$cpu_folder
    mkdir $hermitcore_output_dir/$cpu_folder

    echo -e "Running bfs..."
    repeat $n $cpu bfs $cpu inputs/bfs/graph16M.txt

    echo -e "Running kmeans_openmp..."
    repeat $n $cpu kmeans_openmp -n $cpu -i inputs/kmeans/819200.txt
    
    echo -e "Running lavaMD..."
    repeat $n $cpu lavaMD -cores $cpu -boxes1d 15

    echo -e "Running lud_omp..."
    repeat $n $cpu lud_omp -n $cpu -s 8192
    
    format_logs
    echo -e "\n"
done
