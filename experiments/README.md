## Quickstart

### Step 1: Prepare the data

```bash
cd data
sh prepare.sh
cd ..
```

We first download the data from the FEVER shared task (https://fever.ai/resources.html) and the document retrieval results from  Hanselowski et al. (2018) (https://github.com/UKPLab/fever-2018-team-athene).

We then extract the relevant documents from `fever.db` and keep them in the JSON Lines file `corpus.jsonl` for faster pre-/post-processing. 
This step takes time but we do it only once.

After finishing data preparation, we should see something like:

```bash
wc -l data/*.jsonl
   57069 data/corpus.jsonl
   19998 data/shared_task_dev.jsonl
   19998 data/shared_task_test.jsonl
  145449 data/train.jsonl
  242514 total
```

### Step 2: Train a sentence selection model

We suggest to start experimenting with a smaller dataset `data/toy`.
Its workflow is similar to what we do with the whole dataset.

```bash
cd toy-sentence-selection
sh train_bert-base.sh
```

This step creates pre-processed files in `bert-base-uncased-128-inp`.
We can monitor the training progress using TensorBoard:

```
tensorboard --logdir bert-base-uncased-128-mod/lightning_logs
```

We only save a model checkpoint for the last epoch in `bert-base-uncased-128-mod/checkpoints`.

### Step 3: Extract evidence sentences

```bash
sh predict_bert-base.sh
```

This step generates the predicted evidence sentences for the training (`train.jsonl`) and dev (`shared_task_dev.jsonl`) sets in `bert-base-uncased-128-out`.
We do prediction on the training set because we propose to use a mixture of true and predicted evidence sentences for training a veracity prediction model.

We can check the evaluation results for the sentence selection step:

```bash
tail bert-base-uncased-128-out/eval.{train,shared_task_dev}.txt
==> bert-base-uncased-128-out/eval.train.txt <==
Evidence precision: 27.41
Evidence recall:    88.03
Evidence F1:        41.81

==> bert-base-uncased-128-out/eval.shared_task_dev.txt <==
Evidence precision: 25.26
Evidence recall:    91.14
Evidence F1:        39.56
```

### Step 4: Train a veracity prediction (claim verification) model

```bash
cd ../toy-claim-verification
sh train_bert-base.sh
```

### Step 5: Predict veracity relation labels

```bash
sh predict_bert-base.sh
```

Like `toy-sentence-selection`, we use the directory names `<MODEL NAME>-inp`, `<MODEL NAME>-mod`, and `<MODEL NAME>-out` for input, model, and output, respectively.

We save the output and its evaluation result in `shared_task_dev.jsonl` and `eval.shared_task_dev.txt`.
If everything works properly, we should see something like:

```bash
tail -n 5 bert-base-uncased-128-out/eval.shared_task_dev.txt
Evidence precision: 25.26
Evidence recall:    91.14
Evidence F1:        39.56
Label accuracy:     55.36
FEVER score:        51.95
```

## Reproducing the results from our paper

We can follow the above steps starting with `sentence-selection` followed by `claim-verification-<MODEL NAME>`.
Each directory contains the training and prediction scripts.

We also release the model checkpoints and their outputs at:

- https://doi.org/10.5281/zenodo.6344550

In the following, we show how to use the model checkpoint of `claim-verification-roberta-large`.

:warning: Make sure that we already prepared the data as done in [Step 1](#step-1-prepare-the-data) above.

First, we need to download the predicted evidence sentences for the training/dev/test sets:

```bash
cd mla/experiments/
wget https://zenodo.org/record/6344550/files/sentence-selection.tgz
tar xvf sentence-selection.tgz
cd sentence-selection
tar xvf bert-base-uncased-128-out.tgz
wc -l bert-base-uncased-128-out/*.jsonl
   19998 bert-base-uncased-128-out/shared_task_dev.jsonl
   19998 bert-base-uncased-128-out/shared_task_test.jsonl
  145449 bert-base-uncased-128-out/train.jsonl
  185445 total
cd ..
```

Then, we download the model checkpoint:

```bash
wget https://zenodo.org/record/6344550/files/claim-verification-roberta-large.tgz
tar xvf claim-verification-roberta-large.tgz
cd claim-verification-roberta-large
tar xvf roberta-large-128-mod.tgz
```

The epoch index starts from 0 not 1.
The checkpoint `roberta-large-128-mod/checkpoints/epoch=2.ckpt` indicates that we trained the model for 3 epochs.

Next, we do prediction on the dev set:

```bash
sh predict_roberta-large.sh
```

Finally, we should get the results in `roberta-large-128-out`:

```bash
tail -n 3 roberta-large-128-out/shared_task_dev.jsonl
{"id": 87517, "predicted_label": "SUPPORTS", "predicted_evidence": [["Cyclades", 0], ["Greece", 6], ["Greece", 7], ["Cyclades", 1], ["Greece", 0]]}
{"id": 111816, "predicted_label": "NOT ENOUGH INFO", "predicted_evidence": [["Theresa_May", 6], ["Theresa_May", 8], ["Theresa_May", 0], ["Theresa_May", 1], ["Theresa_May", 12]]}
{"id": 81957, "predicted_label": "REFUTES", "predicted_evidence": [["Trouble_with_the_Curve", 0], ["Trouble_with_the_Curve", 1], ["Trouble_with_the_Curve", 2], ["Trouble_with_the_Curve", 6], ["Trouble_with_the_Curve", 5]]}

tail -n 5 roberta-large-128-out/eval.shared_task_dev.txt
Evidence precision: 25.63
Evidence recall:    88.64
Evidence F1:        39.76
Label accuracy:     79.31
FEVER score:        75.96
```

We also provide the scripts `predict_roberta-large_test.sh` and `create_submission_roberta-large.sh` to generate a submission to the FEVER challenge (https://competitions.codalab.org/competitions/18814).
Please use our results as a reference only and create a new submission using your model.
