#!/bin/bash 

#SBATCH --nodes=4             # This needs to match Trainer(num_nodes=...)
#SBATCH --ntasks-per-node=1   # This needs to match Trainer(devices=...)
#SBATCH -J distributed_1GPU
#SBATCH -o distributed_1GPU-%j.out
#SBATCH -t 3-00:00:00
#SBATCH --exclusive
#SBATCH -p xeon-g6-volta

srun python3 run_chemprop.py 4