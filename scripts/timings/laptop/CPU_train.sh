#!/bin/bash

save_dir=../results_timing/laptop_cpu
data_dir=../../../data/timing

mkdir -p $save_dir

chemprop -h # Load and cache all the python packages for correct timing of the actual chemprop train call

/usr/bin/time -v chemprop train \
--data-path $data_dir/qm9_1k.csv \
--splits-file $data_dir/1k_splits.json \
--save-dir $save_dir \
--depth 3 \
--message-hidden-dim 300 \
--ffn-num-layers 1 \
--ffn-hidden-dim 300 \
--num-workers 8 \
--batch-size 64 \
--accelerator cpu \
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
