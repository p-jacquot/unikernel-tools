#! /bin/bash

# This script runs a single program several times, and redirects
# its output into a log file.

output_folder=outputs

unikernel=$1
unikernel_dir=$2

prog=$3
args=$4

n_times=1

if [ -n $5 ]; then
    n_times=$5
fi

if [ ! -e $output_folder ]; then
    mkdir $output_folder
fi;

prog_name=$(basename $prog)
output_file=$output_folder/$prog_name.log

echo "The following command wil be executed : $prog $args"

for ((i = 0; i < $n_times; i++)); do
   echo -e -n "\r\tRunning $prog - $i..."
   case $unikernel in
        "hermitcore")
            $unikernel_dir/bin/proxy $prog $args >> $output_file
            ;;

        "hermitux")
            HERMIT_ISLE=uhyve HERMIT_TUX=1 \
                $unikernel_dir/hermitux-kernel/prefix/bin/proxy \
                $unikernel_dir/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
                $prog $args >> $output_file
            ;;

        "./")
            ./$prog $args >> $output_file
            ;;

        *)
            echo "Unknown unikernel : $unikernel."
            echo "You can avoid using an unikernel by using the following command :"
            echo "$0 ./ . <programs>"
            exit
            ;;
    esac
done

echo
