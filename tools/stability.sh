#! /bin/bash 

# This script execute given programs with selected unikernel.
# It count the number of time the execution of the program fails.

unikernel=$1
unikernel_dir=$2

commandfile=$3

n_execution=10
if [ -n "$4" ]; then
    n_execution=$4
fi

datafile=exec.csv
echo "unikernel;program;number of execution; number of fails;" > $datafile

logfile=exec.log


echo -e "Redirecting programs output to $logfile."

cat $commandfile | while read prog; do
    fail_count=$((0))
    for ((i = 0; i < $n_execution; i++)); do

        echo -e -n "\rExecuting $prog... $i"
        return_code=0

        case $unikernel in
            "hermitcore")
                $unikernel_dir/bin/proxy $prog > $logfile
                return_code=$?
                ;;

            "hermitux")
                HERMIT_ISLE=uhyve HERMIT_TUX=1 \
                    $unikernel_dir/hermitux-kernel/prefix/bin/proxy \
                    $unikernel_dir/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
                    $prog > $logfile
                return_code=$?
                ;;

            "./")
                ./$prog > $logfile
                return_code=$?
                ;;

            *)
                echo "Unknown unikernel : $unikernel."
                echo "You can avoid using an unikernel by using the following command :"
                echo "$0 ./ . <programs>"
                exit
                ;;
        esac

        if [ "$return_code" != "0" ]; then
            fail_count=$((fail_count+1))
        fi
    done
    echo    
    echo "$unikernel;$prog;$n_execution;$fail_count;" >> $datafile
done
