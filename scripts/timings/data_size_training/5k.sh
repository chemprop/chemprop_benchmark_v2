#!/bin/bash

save_dir=../results_timing
data_dir=../../../data/timing

chemprop train \
--data-path $data_dir/qm9_5k.csv \
--splits-file $data_dir/5k_splits.json \
--save-dir $save_dir/qm9_5k \
--depth 4 \
--message-hidden-dim 1000 \
--ffn-num-layers 2 \
--ffn-hidden-dim 1000 \
--num-workers 8 \
--batch-size 64 \
--accelerator gpu \
--devices 1 \
--epochs 50 \
--activation RELU \
--dropout 0.0 \
--aggregation norm \
--ensemble-size 1 \
--task-type regression \
--warmup-epochs 2 \
--init-lr 0.0001 \
--max-lr 0.001 \
--final-lr 0.0001 \
--data-seed 0 \
--pytorch-seed 0 \
