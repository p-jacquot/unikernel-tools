#! /bin/bash

bin_location=$1
n_cores=$2

unikernel=$3
unikernel_dir=$4

export HERMIT_CPUS=$n_cores
export OMP_NUM_THREADS=$n_cores

tools_location=../../tools

health_input=health-medium.input
cp $bin_location/../inputs/health/medium.input $health_input

if [ ! -e results ]; then
    mkdir results
fi

./$tools_location/stability.sh 50 1 $unikernel $unikernel_dir $bin_location/fib.clang-11.serial
./$tools_location/stability.sh 50 1 $unikernel $unikernel_dir $bin_location/fib.clang-11.omp-tasks
./$tools_location/stability.sh 50 1 $unikernel $unikernel_dir $bin_location/fib.clang-11.omp-tasks-tied
./$tools_location/stability.sh 50 1 $unikernel $unikernel_dir $bin_location/fib.clang-11.omp-tasks-if_clause
./$tools_location/stability.sh 50 1 $unikernel $unikernel_dir $bin_location/fib.clang-11.omp-tasks-if_clause-tied
./$tools_location/stability.sh 50 1 $unikernel $unikernel_dir $bin_location/fib.clang-11.omp-tasks-manual
./$tools_location/stability.sh 50 1 $unikernel $unikernel_dir $bin_location/fib.clang-11.omp-tasks-manual-tied

./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/health.clang-11.serial "-f $health_input"
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/health.clang-11.omp-tasks "-f $health_input"
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/health.clang-11.omp-tasks-tied "-f $health_input"
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/health.clang-11.omp-tasks-if_clause "-f $health_input"
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/health.clang-11.omp-tasks-if_clause-tied "-f $health_input"
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/health.clang-11.omp-tasks-manual "-f $health_input"
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/health.clang-11.omp-tasks-manual-tied "-f $health_input"

./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/sparselu.clang-11.serial
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/sparselu.clang-11.omp-tasks
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/sparselu.clang-11.omp-tasks-tied
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/sparselu.clang-11.omp-tasks-if_clause
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/sparselu.clang-11.omp-tasks-if_clause-tied
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/sparselu.clang-11.omp-tasks-manual
./$tools_location/stability.sh 50 15 $unikernel $unikernel_dir $bin_location/sparselu.clang-11.omp-tasks-manual-tied

./$tools_location/stability.sh 50 0.5 $unikernel $unikernel_dir $bin_location/strassen.clang-11.serial
./$tools_location/stability.sh 50 0.5 $unikernel $unikernel_dir $bin_location/strassen.clang-11.omp-tasks
./$tools_location/stability.sh 50 0.5 $unikernel $unikernel_dir $bin_location/strassen.clang-11.omp-tasks-tied
./$tools_location/stability.sh 50 0.5 $unikernel $unikernel_dir $bin_location/strassen.clang-11.omp-tasks-if_clause
./$tools_location/stability.sh 50 0.5 $unikernel $unikernel_dir $bin_location/strassen.clang-11.omp-tasks-if_clause-tied
./$tools_location/stability.sh 50 0.5 $unikernel $unikernel_dir $bin_location/strassen.clang-11.omp-tasks-manual
./$tools_location/stability.sh 50 0.5 $unikernel $unikernel_dir $bin_location/strassen.clang-11.omp-tasks-manual-tied

rm $health_input
