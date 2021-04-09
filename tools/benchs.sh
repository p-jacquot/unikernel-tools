#! /bin/bash

command_file=$1
destination_folder=$2
n=$3
cores_list=$4

location=$(dirname $0)

if [ -z "$command_file" ] | [ -z "$destination_folder" ] | [ -z "$n" ] | [ -z "$cores_list" ]; then
    echo -e "Error : Missing argument."
    echo -e "Command syntax : $0 <command_file> <destination_folder> <number of measures> <cores_list>"
    echo -e "Aborting script."
    exit 1
else if [ ! -e $command_file ]; then
    echo -e "Error : $command_file file does not exists."
    echo -e "Aborting script."
    exit 1
else if [ ! -d $destination_folder ]; then
    echo -e "Error : $destination_folder folder does not exists, or is not a directory."
    echo -e "Aborting script."
    exit 1
fi
fi
fi

command_file_name=$(basename $command_file)
output_folder=$destination_folder/results-$command_file_name
tmp_file=tmp

if [ -e $output_folder ]; then
    echo -e "$output_folder folder already exists."
    echo -e "Benchs will be resumed."
else
    mkdir $output_folder
fi

for cores in $cores_list; do
    export HERMIT_CPUS=$cores
    export OMP_NUM_THREADS=$cores
    echo -e "Running benchs for $cores cores.\n===="

    core_folder=$output_folder/$cores-cores
    if [ -e $core_folder ]; then
        echo -e "$core_folder already exists."
        echo -e "Benchs that have already been done will be skipped.\n"
    else
        mkdir $core_folder
    fi
    
    cat $command_file | while read timeout_args; do
        prog_name=$(echo $timeout_args | awk '{print $4}')
        prog_name=$(basename $prog_name)
        output_file=$core_folder/$prog_name.log
        tmp_output_file=$output_file.tmp
        if [ -e $output_file ]; then
            echo -e "$output_file already exist. Experience has already been done."
            echo -e "Skipping execution of : $timeout_args"
            echo -e "--"
        else
            echo -e "Issuing command : ./timeout_run.sh $timeout_args"
            echo -e "Redirecting outputs to $output_file."
            for((i = 0; i < $n; i++)); do
                echo -e -n "\r\tCurrent iteration : $i"
                return_code=1
                while [ $return_code != "0" ]; do
                    $location/timeout_run.sh $timeout_args > $tmp_file
                    return_code=$?
                done
                cat $tmp_file >> $tmp_output_file
            done
            mv $tmp_output_file $output_file
            echo -e "\n--"
        fi
    done
    echo "===="
done

if [ -e $tmp_file ]; then
    rm $tmp_file
fi
