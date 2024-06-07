#!/bin/bash

results_dir=results_barriers_sn2
data_path=../data/barriers_sn2/data.csv
splits_path=../data/barriers_sn2/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--raytune-num-samples 100 \
--epochs 200 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout max_lr final_lr init_lr batch_size warmup_epochs \
--hpopt-save-dir $results_dir \
--reaction \
--keep-h 

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--epochs 200 \
--aggregation norm \
--reaction-columns AAM \
--keep-h \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics mae \
--config-path $results_dir/best_config.toml \
