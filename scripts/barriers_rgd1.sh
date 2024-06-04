#!/bin/bash

results_dir=results_barriers_rgd1
data_path=../data/barriers_rgd1/data.csv
splits_path=../data/barriers_rgd1/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path
--raytune-num-samples 30 \
--epochs 50 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config-save-path $results_dir/config.json \
--hpopt-checkpoint-dir $results_dir \
--log-dir $results_dir \
--reaction \
--keep-h 

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--aggregation norm \
--reaction-columns smiles \
--keep-h \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics mae \
--config-path $results_dir/config.json \
# --reaction \
# --keep-h \
