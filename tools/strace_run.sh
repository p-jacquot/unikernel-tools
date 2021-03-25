#! /bin/bash

destination_folder=$1

unikernel=$2
unikernel_dir=$3

time_limit=$4

prog=$5
args=

while [ -n "$6" ]; do
    args="$args $6"
    shift
done

prog_name=$(basename $prog)
output_file=$destination_folder/$prog_name.trace
timeout="timeout -s SIGKILL --foreground $time_limit"
strace="strace -c -o $output_file"

if [ -e $output_file ]; then
    echo -e "$output_file already exists."
    echo -e "Skipping this execution."
    exit 0
fi

return_code=0

case $unikernel in
    "hermitcore")
        $timeout $strace $unikernel_dir/bin/proxy $prog $args
        return_code=$?
        ;;

    "hermitux")
        HERMIT_ISLE=uhyve HERMIT_TUX=1 \
            HERMIT_SECCOMP=0 HERMIT_DEBUG=0 HERMIT_MEM=4G \
            $timeout $strace \
            $unikernel_dir/hermitux-kernel/prefix/bin/proxy \
            $unikernel_dir/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
            $prog $args
        return_code=$?
        ;;

    "rumprun")
        $timeout $strace \
            $unikernel_dir/rumprun/rumprun/bin/rumprun kvm -i -g '-nographic -vga none' $prog $args
        return_code=$?
        ;;

    "./")
        $timeout $strace ./$prog $args
        return_code=$?
        ;;

    *)
        echo "Unknown unikernel : $unikernel."
        echo "You can avoid using an unikernel by using the following command :"
        echo "$0 ./ . <program> [args]"
        exit 1
        ;;
esac

if [ $return_code != "0" ];then
    error_output=$output_file.error
    echo -e "An error occured while running the executable."
    echo -e "Traces will be moved to an error file : $error_output"
    cat $output_file >> $error_output
    rm $output_file
fi

exit $?

