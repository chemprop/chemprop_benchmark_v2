#!/bin/bash

results_dir=results_sampl
results_dir2=results_sampl_production
data_path=../data/logP/data.csv
splits_path=../data/logP/splits.json
path=../data/logP/logP_without_overlap.csv

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

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $data_path \
--splits-file $splits_path \
--epochs 50 \
--aggregation norm \
--save-dir $results_dir \
--ensemble-size 5 \
--metrics mae \
--config-path $results_dir/best_config.toml

#Train production model
chemprop train \
-t regression \
--data-path $path \
--splits-file $splits_path \
--separate-val-path $path \
--separate-test-path $path \
--epochs 40 \
--aggregation norm \
--save-dir $results_dir2 \
--ensemble-size 5 \
--config-path $results_dir/best_config.toml

#Predict on Sample 6
chemprop predict \
--test-path "../data/logP/sampl6_experimental.csv" \
--preds-path $results_dir2/pred_SAMPL6.csv \
--checkpoint-dir $results_dir2 \
--smiles-column "Isomeric SMILES"

echo SAMPL6  >> $results_dir2/sampl.csv
python -c 'import pandas as pd; from sklearn import metrics; print("rmse", metrics.mean_squared_error(pd.read_csv("results_sampl_production/pred_SAMPL6.csv")["logP"],pd.read_csv("../data/logP/sampl6_experimental.csv")["logP mean"],squared=False))' >> $results_dir2/sampl.csv

#Predict on Sample 7
chemprop predict \
--test-path "../data/logP/sampl7_experimental.csv" \
--preds-path $results_dir2/pred_SAMPL7.csv \
--checkpoint-dir $results_dir2 \
--smiles-column "Isomeric SMILES"

echo SAMPL7 >> $results_dir2/sampl.csv
python -c 'import pandas as pd; from sklearn import metrics; print("rmse", metrics.mean_squared_error(pd.read_csv("results_sampl_production/pred_SAMPL7.csv")["logP"],pd.read_csv("../data/logP/sampl7_experimental.csv")["logP mean"],squared=False))' >> $results_dir2/sampl.csv

#Predict on Sample 9
chemprop predict \
--test-path "../data/logP/sampl9_experimental.csv" \
--preds-path $results_dir2/pred_SAMPL9.csv \
--checkpoint-dir $results_dir2 \
--smiles-column smiles

echo SAMPL9 >> $results_dir2/sampl.csv
python -c 'import pandas as pd; from sklearn import metrics; print("rmse", metrics.mean_squared_error(pd.read_csv("results_sampl_production/pred_SAMPL9.csv")["logP"],pd.read_csv("../data/logP/sampl9_experimental.csv")["new_logPexp_reviewed"],squared=False))' >> $results_dir2/sampl.csv

echo "Saved results to" $results_dir2"/sampl.csv"
cat  >> $results_dir2/sampl.csv
