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
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout max_lr final_lr init_lr batch_size warmup_epochs \
--hpopt-save-dir $results_dir \

#Training with optimized hyperparameters
chemprop train \
-t spectral \
--data-path $data_path \
--splits-file $splits_path \
--epochs 200 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--config-path $results_dir/best_config.toml
