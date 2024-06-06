#!/bin/bash

results_dir=results_hiv
data_path=../data/hiv/data.csv
splits_path \=../data/hiv/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t classification \
--data-path $data_path \
--splits-file $splits_path \
--raytune-num-samples 30 \
--epochs 50 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config-save-path $results_dir/config.json \
--hpopt-checkpoint-dir $results_dir \
--log-dir $results_dir 

#Training with optimized hyperparameters
chemprop train \
-t classification \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics prc \
--config-path $results_dir/config.json
