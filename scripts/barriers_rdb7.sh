#!/bin/bash

results_dir=results_barriers_rdb7
data_path=../data/barriers_rdb7/data.csv
splits_path=../data/barriers_rdb7/splits.json

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
--reaction \
--keep-h 

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--aggregation norm \
--save-dir $results_dir \
--reaction-columns smiles \
--keep-h \
--ensemble-size 5 \
--metrics mae \
--config-path $results_dir/best_config.toml \
# --reaction \
# --keep-h
