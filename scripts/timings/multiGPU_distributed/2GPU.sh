#!/bin/bash 

#SBATCH --nodes=2             # This needs to match Trainer(num_nodes=...)
#SBATCH --ntasks-per-node=1   # This needs to match Trainer(devices=...)
#SBATCH -J distributed_2GPU
#SBATCH -o distributed_2GPU-%j.out
#SBATCH -t 01:00:00
#SBATCH --exclusive
#SBATCH -p xeon-g6-volta

save_dir=../results_timing/2GPU

mkdir -p $save_dir

chemprop -h # Load and cache all the python packages for correct timing of the actual chemprop train call

nvidia-smi \
--query-gpu=index,timestamp,name,pstate,memory.used,utilization.gpu,utilization.memory,power.draw,temperature.gpu \
--format=csv -l 10 > $save_dir/gpu_stats_train.csv &
nvidia-smi --query-compute-apps=timestamp,pid,process_name,used_memory \
--format=csv -l 10 > $save_dir/process_stats_train.csv &

srun /usr/bin/time -v python3 run_chemprop.py $save_dir 2