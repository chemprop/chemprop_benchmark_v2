#!/bin/bash

#SBATCH -J 5k_data_predict
#SBATCH -o 5k_data_predict-%j.out
#SBATCH -t 01:00:00
#SBATCH --exclusive
#SBATCH -N 1
#SBATCH -p xeon-g6-volta

save_dir=../results_timing/qm9_5k
data_dir=../../../data/timing

mkdir $save_dir

chemprop -h # Load and cache all the python packages for correct timing of the actual chemprop train call

nvidia-smi \
--query-gpu=index,timestamp,name,pstate,memory.used,utilization.gpu,utilization.memory,power.draw,temperature.gpu \
--format=csv -l 10 > $save_dir/gpu_stats_predict.csv &
nvidia-smi --query-compute-apps=timestamp,pid,process_name,used_memory \
--format=csv -l 10 > $save_dir/process_stats_predict.csv &

/usr/bin/time -v chemprop predict \
-i $data_dir/qm9_5k.csv \
-o $save_dir/preds.csv \
--model-path $save_dir \
--num-workers 8 \
--batch-size 64 \
--accelerator gpu \
--devices 1

