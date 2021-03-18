#! /bin/bash

command_file=$1
n=$2
cores_list=$3

command_file_name=$(basename $command_file)
output_folder=results-$command_file_name
tmp_file=tmp

if [ -e $output_folder ]; then
    echo -e "Warning : $output_folder folder already exists."
    echo -e "Please remove it manually to avoid making mistakes."
    echo -e "Aborting script."
    exit 1
fi

mkdir $output_folder

for cores in $cores_list; do
    export HERMIT_CPUS=$cores
    export OMP_NUM_THREADS=$cores
    echo -e "Running benchs for $cores cores.\n===="
    mkdir $output_folder/$cores-cores
    cat $command_file | while read timeout_args; do
        prog_name=$(echo $timeout_args | awk '{print $4}')
        prog_name=$(basename $prog_name)
        output_file=$output_folder/$cores-cores/$prog_name.log
        touch $output_file
        echo -e "Issuing command : ./timeout_run.sh $timeout_args"
        echo -e "Redirecting outputs to $output_file."
        for((i = 0; i < $n; i++)); do
            echo -e -n "\r\tCurrent iteration : $i"
            return_code=1
            while [ $return_code != "0" ]; do
                ./timeout_run.sh $timeout_args > $tmp_file
                return_code=$?
            done
            cat $tmp_file >> $output_file
        done
        echo -e "\n--"
    done
    echo "===="
done

rm $tmp_file
