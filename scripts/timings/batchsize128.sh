#!/bin/bash

#SBATCH -J batchsize128
#SBATCH -o batchsize128-%j.out
#SBATCH -t 01:00:00
#SBATCH --exclusive
#SBATCH -N 1
#SBATCH -p xeon-g6-volta

save_dir=results_timing/batchsize128
data_dir=../../data/timing

mkdir -p $save_dir

chemprop -h # Load and cache all the python packages for correct timing of the actual chemprop train call

nvidia-smi \
--query-gpu=index,timestamp,name,pstate,memory.used,utilization.gpu,utilization.memory,power.draw,temperature.gpu \
--format=csv -l 10 > $save_dir/gpu_stats_train.csv &
nvidia-smi --query-compute-apps=timestamp,pid,process_name,used_memory \
--format=csv -l 10 > $save_dir/process_stats_train.csv &

/usr/bin/time -v chemprop train \
--data-path $data_dir/qm9_100k.csv \
--splits-file $data_dir/100k_splits.json \
--save-dir $save_dir \
--depth 3 \
--message-hidden-dim 300 \
--ffn-num-layers 1 \
--ffn-hidden-dim 300 \
--num-workers 0 \
--batch-size 128 \
--accelerator gpu \
--devices 1 \
--epochs 50 \
--activation RELU \
--dropout 0.0 \
--aggregation norm \
--ensemble-size 1 \
--task-type regression \
--warmup-epochs 2 \
--init-lr 0.0001 \
--max-lr 0.001 \
--final-lr 0.0001 \
--data-seed 0 \
--pytorch-seed 0 \
--no-batch-norm