#!/bin/bash

results_dir=results_qm9_gap
data_path=../data/qm9/data.csv
splits_path=../data/qm9/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--raytune-num-samples 30 \
--epochs 50 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout \
--hpopt-save-dir $results_dir \
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
--target-columns gap \
--config-path $results_dir/best_config.toml
