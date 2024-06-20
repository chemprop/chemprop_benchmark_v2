#!/bin/bash

save_dir=../results_timing
data_dir=../../../data/timing

chemprop predict \
--test-path $data_dir/qm9_40k.csv \
--preds-path $save_dir/qm9_40k/preds.csv \
--model-path $save_dir/qm9_40k \
--num-workers 8 \
--accelerator gpu \
--devices 1

