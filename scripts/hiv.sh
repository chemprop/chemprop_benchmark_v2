#!/bin/bash

results_dir=results_hiv
data_path=../data/hiv/data.csv
splits_path=../data/hiv/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t classification \
--data-path $data_path \
--splits-file $splits_path \
--raytune-num-samples 30 \
--epochs 50 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout \
--hpopt-save-dir $results_dir \

#Training with optimized hyperparameters
chemprop train \
-t classification \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics prc roc \
--config-path $results_dir/best_config.toml
