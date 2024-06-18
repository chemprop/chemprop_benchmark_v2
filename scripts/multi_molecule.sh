#!/bin/bash
#SBATCH -J multi_molecule
#SBATCH -o multi_molecule-%j.out
#SBATCH -t 3-00:00:00
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem=40gb
#SBATCH --gres=gpu:volta:1

source /etc/profile
module load anaconda/2023b
source activate chemprop-v2-bench

results_dir=results_multi_molecule
data_path=../data/multi_molecule/data.csv
splits_path=../data/multi_molecule/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
-s smiles solvent \
--data-path $data_path \
--splits-file $splits_path \
--raytune-num-samples 30 \
--epochs 50 \
--aggregation norm \
--raytune-temp-dir $RAY_TEMP_DIR \
--raytune-num-cpus 40 \
--raytune-num-gpus 2 \
--raytune-max-concurrent-trials 2 \
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout \
--hyperopt-random-state-seed 42 \
--hpopt-save-dir $results_dir \

#Training with optimized hyperparameters
chemprop train \
-t regression \
-s smiles solvent \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--pytorch-seed 42 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics mae r2 \
--config-path $results_dir/best_config.toml
