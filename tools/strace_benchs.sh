#! /bin/bash

command_file=$1
destination_folder=$2
ncpus=$3

location=$(dirname $0)

if (( $# < 3 )); then
    echo -e "Error : missing arguments."
    echo -e "Command syntax : $0 <command_file> <destination_folder> <number of cores>"
    echo -e "Aborting script."
    exit 1
fi

if [ ! -e $command_file ]; then
    echo -e "Error : $command_file file does not exists."
    echo -e "Aborting script."
    exit 1
else if [ ! -d $destination_folder ]; then
    echo -e "Error : $destination_folder does not exists, or is not a directory."
    echo -e "Aborting script."
    exit 1
fi
fi

# Turning of Hyperthreading.
echo off > /sys/devices/system/cpu/smt/control
for core in $ncpus; do

	cpu_folder=$destination_folder/$core-cores
	mkdir $cpu_folder
	export OMP_NUM_THREADS=$core

	cat $command_file | while read strace_args; do
        	echo "Issuing command ./strace_run.sh $cpu_folder $strace_args"
        	return_code=1
        	while [ $return_code != "0" ]; do
            		$location/strace_run.sh $cpu_folder $strace_args
            		return_code=$?
        	done
        	echo 
	done
done
