#!/bin/bash

#SBATCH -J large_size_model
#SBATCH -o large_size_model-%j.out
#SBATCH -t 02:00:00
#SBATCH --exclusive
#SBATCH -N 1
#SBATCH -p xeon-g6-volta

save_dir=../results_timing/large_size_model
data_dir=../../../data/timing

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
--depth 6 \
--message-hidden-dim 2400 \
--ffn-num-layers 3 \
--ffn-hidden-dim 2400 \
--num-workers 0 \
--batch-size 64 \
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
