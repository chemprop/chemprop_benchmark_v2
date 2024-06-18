#!/bin/bash

results_dir=results_ir
data_path=../data/ir/data.csv
splits_path=../data/ir/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t spectra \
--data-path $data_path \
--splits-file $splits_path \
--raytune-num-samples 100 \
--epochs 200 \
--aggregation norm \
--raytune-temp-dir $RAY_TEMP_DIR \
--raytune-num-cpus 40 \
--raytune-num-gpus 2 \
--raytune-max-concurrent-trials 2 \
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout max_lr final_lr init_lr batch_size warmup_epochs \
--hyperopt-random-state-seed 42 \
--hpopt-save-dir $results_dir \

#Training with optimized hyperparameters
chemprop train \
-t spectral \
--data-path $data_path \
--splits-file $splits_path \
--epochs 200 \
--pytorch-seed 42 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--config-path $results_dir/best_config.toml
