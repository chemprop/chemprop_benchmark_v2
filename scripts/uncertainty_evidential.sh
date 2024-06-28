#!/bin/bash

results_dir=results_uncertainty_evidential
data_path=../data/uncertainty/data.csv
splits_path=../data/uncertainty/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--num-workers 20 \
--raytune-num-samples 30 \
--epochs 50 \
--aggregation norm \
--no-batch-norm \
--raytune-temp-dir $RAY_TEMP_DIR \
--raytune-num-cpus 40 \
--raytune-num-gpus 2 \
--raytune-max-concurrent-trials 2 \
--search-parameter-keywords depth ffn_num_layers message_hidden_dim ffn_hidden_dim dropout \
--hyperopt-random-state-seed 42 \
--hpopt-save-dir $results_dir \
--loss-function evidential

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--num-workers 20 \
--epochs 50 \
--pytorch-seed 42 \
--aggregation norm \
--no-batch-norm \
--save-dir $results_dir \
--loss-function evidential \
--config-path $results_dir/best_config.toml

#Predict, analyze uncertainty
chemprop predict \
--preds-path $results_dir/test_preds_unc_evidential.csv \
--checkpoint-dir $results_dir \
--uncertainty-method evidential_total \
--calibration-method zscaling \
--regression-calibrator-metric stdev \
--calibration-interval-percentile 95 \
--evaluation-methods nll spearman ence miscalibration_area \
--evaluation-scores-path $results_dir/unc_eval_scores_evidential.csv		

cat $results_dir/unc_eval_scores_evidential.csv
