#! /bin/bash

command_files_list=$1
n=$2
cpus_list=$3

time_file=times.csv

ln -s ../../tools/benchs.sh benchs.sh
ln -s ../../tools/timeout_run.sh timeout_run.sh

for command_file in $command_files_list; do
    command_file_name=$(basename $command_file)
    ./benchs.sh $command_file $n "$cpus_list"

    cd results-$command_file_name
    for folder in *; do
        cd ./$folder
        touch $time_file
        for logfile in *.log; do
            echo "$logfile;" >> $time_file
            cat $logfile | grep "Time Program" | awk '{print $4 ";"}' >> $time_file
            echo ";" >> $time_file
        done
        cd ..
    done
    cd ..
done

rm benchs.sh
rm timeout_run.sh
