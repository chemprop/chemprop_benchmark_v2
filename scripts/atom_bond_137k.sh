#!/bin/bash

results_dir=results_atom_bond_137k
data_path=../data/atom_bond_137k/data.csv
splits_path=../data/atom_bond_137k/splits.json
train_constraints_path=../data/atom_bond_137k/train_constraints.csv
val_constraints_path=../data/atom_bond_137k/val_constraints.csv
test_constraints_path=../data/atom_bond_137k/test_constraints.csv

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--constraints-path $train_constraints_path \
--separate-val-constraints-path $val_constraints_path \
--separate-test-constraints-path $val_constraints_path \
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
--adding-h \
--is-atom-bond--targets \
--no-shared-atom-bond-ffn \
--no-adding-bond--types

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--constraints-path $train_constraints_path \
--separate-val-constraints-path $val_constraints_path \
--separate-test-constraints-path $test_constraints_path \
--epochs 50 \
--pytorch-seed 42 \
--aggregation norm \
--save-dir $results_dir \
--adding-h \
--is-atom-bond--targets \
--no-shared-atom-bond-ffn \
--no-adding-bond--types \
--ensemble-size 5 \
--metrics mae \
--config-path $results_dir/best_config.toml
