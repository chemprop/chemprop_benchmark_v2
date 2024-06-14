#!/bin/bash

results_dir=results_barriers_e2
data_path=../data/barriers_e2/data.csv
splits_path=../data/barriers_e2/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
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
--hpopt-save-dir $results_dir \
--reaction-columns AAM \
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
--config-path $results_dir/best_config.toml
