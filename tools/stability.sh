#! /bin/bash

n_try=$1
time_limit=$2

unikernel=$3
unikernel_dir=$4

prog=$5
args=$6

datafile=exec.csv

if [ ! -e $datafile ]; then
    echo "unikernel;program;number of executions;fails;timeout kills;" > $datafile
fi

logfile=exec.log

echo -e "Redirecting program output to $logfile."

fail_count=$((0))
timeout_count=$((0))

for ((i = 0; i < $n_try; i++)); do
    echo -e -n "\r Execution n°$i... "
        ./timeout_run.sh $unikernel $unikernel_dir $time_limit $prog "$args" >> $logfile
    return_code=$?
    echo "=====================================================" >> $logfile

    case $return_code in 
        "0")
            # No problem, do not print anything.
            ;;
        "124" | "137")
            echo "Timeout !"
            timeout_count=$((timeout_count+1))
            ;;
        *)
            echo "Execution failed."
            fail_count=$((fail_count+1))
            ;;
    esac
done

echo "$unikernel;$prog;$n_try;$fail_count;$timeout_count;" >> $datafile
echo
