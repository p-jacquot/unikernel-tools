#! /bin/bash

unikernel=$1
unikernel_dir=$2

prog=$3
args=
while [ -n "$4" ]; do
    args="$args $4"
done

case $unikernel in
    "hermitcore")
        $unikernel_dir/bin/proxy $prog $args
        ;;

    "hermitux")
        HERMIT_ISLE=uhyve HERMIT_TUX=1 \
            $unikernel_dir/hermitux-kernel/prefix/bin/proxy \
            $unikernel_dir/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
            $prog $args
        ;;

    "rumprun")
        $unikernel_dir/rumprun/rumprun/bin/rumprun kvm -i -g '-nographic -vga none' $prog $args
        ;;

    "./")
        ./$prog $args
        ;;

    *)
        echo "Unknown unikernel : $unikernel."
        echo "You can avoid using an unikernel by using the following command :"
        echo "$0 ./ . <program> [args]"
        ;;
esac

exit $?

