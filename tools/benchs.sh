#! /bin/bash

command_file=$1
n=$2
cores_list=$3

command_file_name=$(basename $command_file)
output_folder=results-$command_file_name
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
                    ./timeout_run.sh $timeout_args > $tmp_file
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
