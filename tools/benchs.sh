#! /bin/bash

check_args()
{
if (( $# < 4 )); then
    echo -e "Error : missing arguments."
    echo -e "Command syntax : \
$0 <command_files_list> <destination_folder> <number of measures> <cores_list>"
    echo -e "Aborting script."
    exit 1
fi 
}

# function call : exec_command timeout_args
# function call : exec_command unikernel unikernel_dir time_limit prog prog_args
exec_command()
{
    prog_name=$4
    prog_name=$(basename $prog_name)
    output_file=$core_folder/$prog_name.log
    tmp_file=tmp
    tmp_output_file=tmp-output
    
    if [ -e $output_file ]; then
        echo -e "$output_file already exists. Exeperience has already been done.\
\nSkipping execution of : $timeout_args\
\n--"
    else
        echo -e "Issuing command : ./timeout_run.sh $@\
                \nOutputs will be placed at $output_file."
        for((i = 0; i < $n; i++)); do
            echo -e -n "\r\tCurrent iteration : $i"
            return_code=1
            while [ $return_code != "0" ]; do
                $location/timeout_run.sh $@ > $tmp_file
                return_code=$?
                echo -e -n "!"
            done
            cat $tmp_file >> $tmp_output_file
        done
        mv $tmp_output_file $output_file
    fi
    echo -e "\n--"
}

format_logs()
{
    cd $core_folder
    for logfile in *.log; do
        time_file=$(basename -s .log $logfile).csv
        if [ ! -e $time_file ]; then
            cat $logfile | grep "Time Program" | awk '{print $4 ";"}' >> $time_file
        else
            echo -e "$output_folder/$folder/$time_file already exists.\
\nSkipping formatting."
        fi
    done
    cd $current_dir
    echo -e "Time files formatting finished.\n\n"
}

# function call : exec_command_file command_file
exec_command_file()
{
    file=$1
    command_file_name=$(basename $file)
    output_folder=$destination_folder/results-$command_file_name
    tmp_file=tmp

    echo -e "Executiing commands from $file :\n\n"
    
    if [ -e $output_folder ]; then
        echo -e "$output_folder folder already exists.\
\nBenchs will be resumed."
    else
        mkdir $output_folder
    fi

    for cores in $cpus_list; do
        export HERMIT_CPUS=$cores
        export OMP_NUM_THREADS=$cores
        echo -e "Running commands for $cores cores.\n===="
        core_folder=$output_folder/$cores-cores

        if  [ -e $core_folder ]; then
            echo -e "$core_folder already exists.\
\nBenchs that have already been executed will be skipped."
        else
            mkdir $core_folder
        fi

        cat $file | while read timeout_args; do
            #echo -e "exec $timeout_args"
            exec_command $timeout_args
        done
        format_logs
        echo "===="
    done
}



check_args $@

command_files_list=$1
destination_folder=$2
n=$3
cpus_list=$4

current_dir=$(pwd)
location=$(dirname $0)

# Turning of hyperthreading.
echo off > /sys/devices/system/cpu/smt/control

for command_file in $command_files_list; do
    command_file_name=$(basename $command_file)
    echo -e "Executing commands from $command_file :\n\n"
    
    # TODO : Implement the following function 
    exec_command_file $command_file $destination_folder $n "$cpus_lists"
done
