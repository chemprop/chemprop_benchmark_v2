#!/bin/bash

results_dir=results_qm9_gap
data_path=../data/qm9/data.csv
splits_path \=../data/qm9/splits.json

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
--target-columns gap

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics mae \
--show-individual-scores \
--target-columns gap \
--config-path $results_dir/config.json
