#!/bin/bash

save_dir=../results_timing/laptop_cpu
data_dir=../../../data/timing

mkdir -p $save_dir

chemprop -h # Load and cache all the python packages for correct timing of the actual chemprop train call

/usr/bin/time -v chemprop predict \
-i $data_dir/qm9_100k.csv \
-o $save_dir/preds.csv \
--model-path $save_dir \
--num-workers 0 \
--batch-size 64 \
--accelerator cpu

