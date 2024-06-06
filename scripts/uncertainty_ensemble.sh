#!/bin/bash

results_dir=results_uncertainty_ensemble
data_path=../data/uncertainty/data.csv
splits_path=../data/uncertainty/splits.json

#Hyperparameter optimization
chemprop hpopt \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--raytune-num-samples 30 \
--epochs 50 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config-save-path $results_dir/config.json \
--hpopt-checkpoint-dir $results_dir \
--log-dir $results_dir

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--config-path $results_dir/config.json

#Predict, analyze uncertainty
chemprop predict \
--preds-path $results_dir/test_preds_unc_ensemble.csv \
--checkpoint-dir $results_dir \
--uncertainty-method ensemble \
--calibration-method zscaling \
--regression-calibrator-metric stdev \
--calibration-interval-percentile 95 \
--evaluation-methods nll spearman ence miscalibration_area \
--evaluation-scores-path $results_dir/unc_eval_scores_ensemble.csv		

cat $results_dir/unc_eval_scores_ensemble.csv
