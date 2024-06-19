#!/bin/bash
#SBATCH -J pcqm4mv2
#SBATCH -o pcqm4mv2-%j.out
#SBATCH -t 4-00:00:00
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem=100gb
#SBATCH --gres=gpu:volta:1

source /etc/profile
module load anaconda/2023b
source activate chemprop-v2-bench

results_dir=results_pcqm4mv2
data_path=../data/pcqm4mv2/data.csv
splits_path=../data/pcqm4mv2/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--num-workers 20 \
--raytune-num-samples 30 \
--epochs 50 \
--aggregation norm \
--raytune-temp-dir $RAY_TEMP_DIR \
--raytune-num-cpus 40 \
--raytune-num-gpus 2 \
--raytune-max-concurrent-trials 2 \
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout \
--hyperopt-random-state-seed 42 \
--hpopt-save-dir $results_dir

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--num-workers 20 \
--epochs 50 \
--pytorch-seed 42 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics mae r2 \
--config-path $results_dir/best_config.toml
