#!/bin/bash

results_dir=results_barriers_cycloadd
data_path=../data/barriers_cycloadd/data.csv
splits_path=../data/barriers_cycloadd/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--num-workers 20 \
--raytune-num-samples 100 \
--epochs 200 \
--aggregation norm \
--no-batch-norm \
--raytune-temp-dir $RAY_TEMP_DIR \
--raytune-num-cpus 40 \
--raytune-num-gpus 2 \
--raytune-max-concurrent-trials 2 \
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout max_lr final_lr init_lr batch_size warmup_epochs \
--hyperopt-random-state-seed 42 \
--hpopt-save-dir $results_dir \
--keep-h \
--reaction-columns rxn_smiles \
--target-columns G_act

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--num-workers 20 \
--epochs 200 \
--pytorch-seed 42 \
--aggregation norm \
--no-batch-norm \
--save-dir $results_dir \
--keep-h \
--ensemble-size 5 \
--metrics mae \
--reaction-columns rxn_smiles \
--target-columns G_act \
--config-path $results_dir/best_config.toml
