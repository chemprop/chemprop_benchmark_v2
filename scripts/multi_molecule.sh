#!/bin/bash
#SBATCH -J multimolecule
#SBATCH -o multimolecule-%j.out
#SBATCH -t 3-00:00:00
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem=40gb
#SBATCH --gres=gpu:volta:1

source /etc/profile
module load anaconda/2023b
source activate chemprop-v2

results_dir=results_multi_molecule
data_path=../data/multi_molecule/data.csv
splits_path=../data/multi_molecule/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--raytune-num-samples 30 \
--epochs 50 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config-save-path $results_dir/config.json \
--hpopt-checkpoint-dir $results_dir \
--log-dir $results_dir \
--number-of-molecules 2

#Training with optimized hyperparameters
chemprop train \
-t regression \
-s smiles solvent \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics mae r2 \
#--config-path $results_dir/config.json
