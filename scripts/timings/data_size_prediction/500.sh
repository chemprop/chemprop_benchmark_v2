#!/bin/bash

save_dir=../results_timing
data_dir=../../../data/timing

chemprop predict \
--test-path $data_dir/qm9_500.csv \
--preds-path $save_dir/qm9_500/preds.csv \
--model-path $save_dir/qm9_500 \
--num-workers 8 \
--accelerator gpu \
--devices 1

