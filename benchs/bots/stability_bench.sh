#! /bin/bash

command_file=$1
cpus_list=$2
n_try=$3

ln -s ../../tools/stability.sh stability.sh
ln -s ../../tools/timeout_run.sh timeout_run.sh

command_file_name=$(basename $command_file)
output_folder=$command_file_name-stability-results

if [ ! -e $output_folder ]; then
    mkdir $output_folder
fi

for cpu in $cpus_list; do
    echo -e "Doing stability tests for $cpu cores.\n===="
    export HERMIT_CPUS=$cpu
    export OMP_NUM_THREADS=$cpu
    csvfilename=$cpu-cores-$command_file_name.csv
    logfilename=$cpu-cores-$command_file_name.log
    cat $command_file | while read timeout_args; do
        ./stability.sh $n_try $timeout_args
    done
    mv exec.csv $output_folder/$csvfilename
    mv exec.log $output_folder/$logfilename
done

rm stability.sh
rm timeout_run.sh
