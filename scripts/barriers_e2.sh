#!/bin/bash

results_dir=results_barriers_e2
data_path=../data/barriers_e2/data.csv
splits_path=../data/barriers_e2/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path
--raytune-num-samples 100 \
--epochs 200 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers hidden_size ffn_hidden_size dropout max_lr final_lr init_lr batch_size warmup_epochs \
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
--epochs 200 \
--aggregation norm \
--save-dir $results_dir \
--reaction-columns AAM \
--keep-h \
--ensemble-size 5 \
--metrics mae \
--config-path $results_dir/config.json
