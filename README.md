# Chemprop v2 benchmarking scripts and data

This repository contains benchmarking scripts and data for Chemprop v2, a message passing neural network for molecular property prediction, as described in the paper [Chemprop v2: Modular, Fast, and User-Friendly](INSERT_PREPRINT_DOI). Please refer to the [Chemprop repository](https://github.com/chemprop/chemprop) for installation and usage instructions.

## Data

All datasets used in the study can be downloaded from [Zenodo](https://doi.org/10.5281/zenodo.8174267). You can either download and extract the file data.tar.gz yourself, or run

```
wget https://zenodo.org/records/10078142/files/data.tar.gz
tar -xzvf data.tar.gz
```

The data folder should be placed within the `chemprop_benchmark_v2` folder (i.e. where this README and the `scripts` folder are located).

## Benchmarks

The paper reports a large number of benchmarks that can be run individually by executing one of the shell scripts in the `scripts` folder. For example, to run the `barriers_e2` reaction benchmark, activate your Chemprop environment as described in the [Chemprop repository](https://github.com/chemprop/chemprop), and then run (after adapting the path to your Chemprop folder):

```
cd scripts
./barriers_e2.sh
```

This will run a hyperparameter search, as well as a training run on the best hyperparameters, and produce the `results_barriers_e2` folder with all the necessary information, including model checkpoints and test set predictions.

The following benchmarking systems were used in the paper:
 * `hiv` HIV replication inhibition from MoleculeNet and OGB with scaffold splits
 * `pcba_random` Biological activities from MoleculeNet with random splits
 * `pcba_random_nans` Biological activities from MoleculeNet with missing targets NOT set to zero (to be comparable to the OGB version) with random splits
 * `pcba_scaffold` Biological activities from MoleculeNet and OGB with scaffold splits
 * `qm9_multitask` DFT calculated properties from MoleculeNet and OGB, trained as a multi-task model
 * `qm9_u0` DFT calculated properties from MoleculeNet and OGB, trained as a single-task model on the target U0 only
 * `qm9_gap` DFT calculated properties from MoleculeNet and OGB, trained as a single-task model on the target gap only
 * `sampl` Water-octanol partition coefficients, used to predict molecules from the SAMPL6, 7 and 9 challenges
 * `barriers_e2` Reaction barrier heights of E2 reactions
 * `barriers_sn2` Reaction barrier heights of S<sub>N</sub>2 reactions
 * `barriers_cycloadd` Reaction barrier heights of cycloaddition reactions
 * `barriers_rdb7` Reaction barrier heights in the RDB7 dataset
 * `barriers_rgd1` Reaction barrier heights in the RGD1-CNHO dataset
 * `multi_molecule` UV/Vis peak absorption wavelengths in different solvents
 * `pcqm4mv2` HOMO-LUMO gaps of the PCQM4Mv2 dataset
 * `timing` Timing benchmark using subsets of the QM9 gap

The benchmarks were performed using [Chemprop v2.0.3](https://github.com/chemprop/chemprop/releases/tag/v2.0.3). To reproduce the exact environment used in this study, you can create a conda environment using the provided `environment.yml` file.
