#! /bin/bash

cpu_list="2 4 8 16"

./stability_bench.sh stability-commands/serial-commands 1 50 120 hermitux /root/hermitux bots/bin-hermitux
./stability_bench.sh stability-commands/serial-commands 1 50 120 hermitcore /opt/hermit bots/bin-hermitcore

./stability_bench.sh stability-commands/omp-commands "$cpu" 50 50 hermitux /root/hermitux bots/bin-hermitux
./stability_bench.sh stability-commands/omp-commands "$cpu" 50 120 hermitcore /opt/hermit bots/bin-hermitcore
