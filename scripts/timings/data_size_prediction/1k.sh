#!/bin/bash

save_dir=../results_timing
data_dir=../../../data/timing

chemprop predict \
--test-path $data_dir/qm9_1k.csv \
--preds-path $save_dir/qm9_1k/preds.csv \
--model-path $save_dir/qm9_1k \
--num-workers 8 \
--batch-size 64 \
--accelerator gpu \
--devices 1

