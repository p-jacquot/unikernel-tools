#! /bin/bash

unikernel=$1
unikernel_dir=$2

time_limit=$3

prog=$4
args=

while [ -n "$5" ]; do
    args="$args $5"
    shift
done

timeout="timeout -s SIGKILL --foreground $time_limit"

case $unikernel in
    "hermitcore")
        HERMIT_MEM=4G \
            $timeout $unikernel_dir/bin/proxy $prog $args
        ;;

    "hermitux")
        HERMIT_ISLE=uhyve HERMIT_TUX=1 \
            HERMIT_SECCOMP=0 HERMIT_DEBUG=0 HERMIT_MEM=4G \
            $timeout \
            $unikernel_dir/hermitux-kernel/prefix/bin/proxy \
            $unikernel_dir/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
            $prog $args
        ;;

    "rumprun")
        $timeout \
            $unikernel_dir/rumprun/rumprun/bin/rumprun kvm -i -g '-nographic -vga none' $prog $args
        ;;

    "./")
        $timeout ./$prog $args
        ;;

    *)
        echo "Unknown unikernel : $unikernel."
        echo "You can avoid using an unikernel by using the following command :"
        echo "$0 ./ . <program> [args]"
        ;;
esac

exit $?

