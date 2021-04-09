#! /bin/bash

command_files_list=$1
destination_folder=$2
n=$3
cpus_list=$4

current_dir=$(pwd)

if (( $# < 4 )); then
    echo -e "Error : missing arguments."
    echo -e "Command syntax : $0 <command_files_list> <destination_folder> <number of measures> <cores_list>"
    echo -e "Aborting script."
    exit 1
fi 


time_file=times.csv
location=$(dirname $0)

# Turning of Hyperthreading.
echo off > /sys/devices/system/cpu/smt/control

for command_file in $command_files_list; do
    command_file_name=$(basename $command_file)
    echo -e "Executing commands from $command_file :\n\n"
    $location/benchs.sh $command_file $destination_folder $n "$cpus_list"

    results_folder=$destination_folder/results-$command_file_name
    if [ ! -e $results_folder ]; then
        echo -e "Error : expected to find $results_folder, but the directory does not exist."
        echo -e "Skipping formatting of thoses results."
    else
        cd $results_folder
        for folder in *; do
            if [ ! -e $folder/$time_file ]; then
                cd ./$folder
                touch $time_file
                for logfile in *.log; do
                    echo "$logfile;" >> $time_file
                    cat $logfile | grep "Time Program" | awk '{print $4 ";"}' >> $time_file
                    echo ";" >> $time_file
                done
                cd ..
            else
                echo -e "File $folder/$time_file already exists."
                echo -e "Skipping formatting."
            fi
        done
        cd $current_dir
    fi
    echo -e "\n"
done

