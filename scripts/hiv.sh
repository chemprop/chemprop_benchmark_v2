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
--raytune-temp-dir $RAY_TEMP_DIR \
--raytune-num-cpus 40 \
--raytune-num-gpus 2 \
--raytune-max-concurrent-trials 2 \
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout \
--hyperopt-random-state-seed 42 \
--hpopt-save-dir $results_dir

#Training with optimized hyperparameters
chemprop train \
-t classification \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--pytorch-seed 42 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics prc roc \
--config-path $results_dir/best_config.toml
