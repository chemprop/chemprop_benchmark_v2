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
--search-parameter-keywords depth ffn_num_layers hidden_size ffn_hidden_size dropout max_lr final_lr init_lr batch_size warmup_epochs \
--config-save-path $results_dir/config.json \
--hpopt-checkpoint-dir $results_dir \
--log-dir $results_dir 

#Training with optimized hyperparameters
chemprop train \
-t spectral \
--data-path $data_path \
--splits-file $splits_path \
--epochs 200 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--config-path $results_dir/config.json
