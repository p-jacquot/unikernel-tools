#! /bin/bash

# Simple script for running bots benchs.

bots_location=$1

export OMP_NUM_THREADS=2
export HERMIT_CPUS=2

output_dir=all-output

mkdir $output_dir

echo -e "Running debian benchs...\n"
./run.sh ./ . $bots_location/debian_bin/fib.*.omp-tasks "" 50
./run.sh ./ . $bots_location/debian_bin/health.*.omp-tasks "-f $bots_location/inputs/health/medium.input" 50
./run.sh ./ . $bots_location/debian_bin/sparselu.*.for-omp-tasks "" 50
./run.sh ./ . $bots_location/debian_bin/strassen.*.omp-tasks "" 50
./run.sh ./ . $bots_location/debian_bin/fib.*.omp-tasks "" 50

mv outputs $output_dir/debian-omp-outputs

echo -e "Running hermitcore benchs...\n"
./run.sh hermitcore /opt/hermit $bots_location/hermitcore_bin/fib.*.omp-tasks "" 50
./run.sh hermitcore /opt/hermit $bots_location/hermitcore_bin/health.*.omp-tasks "-f $bots_location/inputs/health/medium.input" 50
./run.sh hermitcore /opt/hermit $bots_location/hermitcore_bin/sparselu.*.for-omp-tasks "" 50
./run.sh hermitcore /opt/hermit $bots_location/hermitcore_bin/strassen.*.omp-tasks "" 50
./run.sh hermitcore /opt/hermit $bots_location/hermitcore_bin/fib.*.omp-tasks "" 50

mv outputs $output_dir/hermitcore-omp-outputs

echo -e "Running hermitux benchs...\n"
./run.sh hermitux $HOME/hermitux $bots_location/hermitux_bin/fib.*.omp-tasks "" 50
./run.sh hermitux $HOME/hermitux $bots_location/hermitux_bin/health.*.omp-tasks "-f $bots_location/inputs/health/medium.input" 50
./run.sh hermitux $HOME/hermitux $bots_location/hermitux_bin/sparselu.*.for-omp-tasks "" 50
./run.sh hermitux $HOME/hermitux $bots_location/hermitux_bin/strassen.*.omp-tasks "" 50
./run.sh hermitux $HOME/hermitux $bots_location/hermitux_bin/fib.*.omp-tasks "" 50

mv outputs $output_dir/hermitux-omp-outputs

for benchs in $output_dir/*; do
    cd $benchs
    touch times.csv
    for file in *; do
        echo "$file;" >> times.csv
        cat $file | grep "Time Program" | awk '{print $4 ";"}' >> times.csv;
        echo >> times.csv
    done
    cd ../..
done

echo "Benchs finished !"
