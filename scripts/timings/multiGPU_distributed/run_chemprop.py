import json
import pandas as pd
from pathlib import Path
import sys

from lightning import pytorch as pl
import torch

from chemprop import data, featurizers, models, nn
from chemprop.cli.utils import parse_indices

def main(save_dir, num_nodes):
    torch.manual_seed(0)

    model_output_dir = Path(save_dir) / "model_0"
    model_output_dir.mkdir(exist_ok=True, parents=True)

    data_dir = "../../../data/timing"
    data_path = data_dir + "/qm9_100k.csv"
    splits_file = data_dir + "/100k_splits.json"

    df_input = pd.read_csv(data_path)

    smis = df_input.loc[:, "smiles"].values
    ys = df_input.loc[:, ["gap"]].values

    all_data = [data.MoleculeDatapoint.from_smi(smi, y) for smi, y in zip(smis, ys)]

    mols = [d.mol for d in all_data]
    with open(splits_file, "rb") as json_file:
        split_idxss = json.load(json_file)
    train_indices = [parse_indices(d["train"]) for d in split_idxss][0]
    val_indices = [parse_indices(d["val"]) for d in split_idxss][0]
    test_indices = [parse_indices(d["test"]) for d in split_idxss][0]

    train_data, val_data, test_data = data.split_data_by_indices(
        all_data, train_indices, val_indices, test_indices
    )

    featurizer = featurizers.SimpleMoleculeMolGraphFeaturizer()

    train_dset = data.MoleculeDataset(train_data, featurizer)
    scaler = train_dset.normalize_targets()

    val_dset = data.MoleculeDataset(val_data, featurizer)
    val_dset.normalize_targets(scaler)

    train_dset.cache = True
    val_dset.cache = True

    test_dset = data.MoleculeDataset(test_data, featurizer)

    train_loader = data.build_dataloader(train_dset, seed=0)
    val_loader = data.build_dataloader(val_dset, shuffle=False)
    test_loader = data.build_dataloader(test_dset, shuffle=False)

    mp = nn.BondMessagePassing()
    agg = nn.NormAggregation()

    output_transform = nn.UnscaleTransform.from_standard_scaler(scaler)
    ffn = nn.RegressionFFN(output_transform=output_transform)

    mpnn = models.MPNN(mp, agg, ffn, batch_norm=False)

    trainer = pl.Trainer(
        logger=False,
        enable_checkpointing=False,
        enable_progress_bar=True,
        accelerator="gpu",
        devices=1,
        num_nodes=num_nodes,
        strategy="ddp",
        max_epochs=50,
        deterministic=True,
    )

    trainer.fit(mpnn, train_loader, val_loader)

    results = trainer.test(mpnn, test_loader)

if __name__ == "__main__":
    save_dir = sys.argv[1]
    num_nodes = int(sys.argv[2])
    main(save_dir, num_nodes)