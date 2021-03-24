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
    csvfile=$output_folder/$cpu-cores.csv
    logfile=$output_folder/$cpu-cores.log
    if [ ! -e $csvfile ] | [ ! -e $logfile ]; then
        cat $command_file | while read timeout_args; do
            ./stability.sh $n_try $timeout_args
        done
        mv exec.csv $csvfile
        mv exec.log $logfile
    else
        echo -e "$csvfile already exists."
        echo -e "Skipping stability tests for $cpu cores."
    fi

    echo -e "\n"
done

rm stability.sh
rm timeout_run.sh
