#! /bin/bash

command_file=$1
cpus_list=$2
n_try=$3
time_limit=$4
unikernel=$5
unikernel_dir=$6
bin_location=$7

ln -s ../../tools/stability.sh stability.sh
ln -s ../../tools/timeout_run.sh timeout_run.sh

output_folder=$unikernel-stability-results
command_file_name=$(basename $command_file)

if [ ! -e $output_folder ]; then
    mkdir $output_folder
fi

mv $bin_location bots/bin

for cpu in $cpus_list; do
    echo -e "Doing stability tests for $cpu cores.\n===="
    export HERMIT_CPUS=$cpu
    export OMP_NUM_THREADS=$cpu
    csvfilename=$cpu-cores-$command_file_name.csv
    logfilename=$cpu-cores-$command_file_name.log
    cat $command_file | while read program; do
        ./stability.sh $n_try $time_limit $unikernel $unikernel_dir $program
    done
    mv exec.csv $output_folder/$csvfilename
    mv exec.log $output_folder/$logfilename
done

mv bots/bin $bin_location

rm stability.sh
rm timeout_run.sh
