#! /bin/bash

command_file_lists=$1
cpus_list=$2
n_try=$3

if (( $# < 3)); then
    echo -e "Missing arguments."
    echo -e "Command syntax : $0 <command_files_list> <cpus_list> <number of try>"
    echo -e "Aborting script."
    exit 1
fi

ln -s ../../tools/stability.sh stability.sh
ln -s ../../tools/timeout_run.sh timeout_run.sh


for command_file in $command_file_lists; do

    if [ ! -e $command_file ]; then
        echo -e "$command_file file does not exists."
        echo -e "Skipping this part."
    else
        echo -e "Executing commands from : $command_file\n\n"
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
    fi
    echo -e "\n\n"
done

rm stability.sh
rm timeout_run.sh
