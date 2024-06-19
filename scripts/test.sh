#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_hiv
train_path=../data/hiv/train.csv
val_path=../data/hiv/val.csv
test_path=../data/hiv/test.csv

#Hyperparameter optimization
chemprop hpopt \
-t classification \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $val_path \
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
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $test_path \
--epochs 50 \
--pytorch-seed 42 \
--aggregation norm \
--config-path $results_dir/best_config.toml \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics prc

