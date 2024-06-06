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
--search-parameter-keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config-save-path $results_dir/config.json \
--hpopt-checkpoint-dir $results_dir \
--log-dir $results_dir \
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
--aggregation norm \
--save-dir $results_dir \
--adding-h \
--is-atom-bond--targets \
--no-shared-atom-bond-ffn \
--no-adding-bond--types \
--ensemble-size 5 \
--metrics mae \
--show-individual-scores \
--config-path $results_dir/config.json
