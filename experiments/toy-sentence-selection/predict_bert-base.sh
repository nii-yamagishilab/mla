#!/bin/bash
#
# Copyright (c) 2021, Yamagishi Laboratory, National Institute of Informatics
# Authors: Canasai Kruengkrai (canasai@nii.ac.jp)
# All rights reserved.
#
#SBATCH --job-name=predict_bert-base
#SBATCH --out='predict_bert-base.log'
#SBATCH --time=00:10:00
#SBATCH --gres=gpu:tesla_a100:1

conda_setup="/home/smg/$(whoami)/miniconda3/etc/profile.d/conda.sh"
if [[ -f "${conda_setup}" ]]; then
  #shellcheck disable=SC1090
  . "${conda_setup}"
  conda activate mla
fi

set -ex

pretrained='bert-base-uncased'
max_len=128
model_dir="${pretrained}-${max_len}-mod"
out_dir="${pretrained}-${max_len}-out"

data_dir='../data/toy'

unset -v latest

for file in "${model_dir}/checkpoints"/*.ckpt; do
  [[ $file -nt $latest ]] && latest=$file
done

if [[ -z "${latest}" ]]; then
  echo "Cannot find any checkpoint in ${model_dir}"
  exit
fi

echo "Latest checkpoint is ${latest}"

mkdir -p "${out_dir}"

for split in 'train' 'shared_task_dev'; do
  if [[ -f "${out_dir}/${split}.jsonl" ]]; then
    echo "${out_dir}/${split}.jsonl exists!"
    continue
  fi

  python '../../preprocess_sentence_selection.py' \
    --corpus "${data_dir}/corpus.jsonl" \
    --in_file "${data_dir}/document-retrieval/${split}.jsonl" \
    --out_file "${out_dir}/${split}.tsv"

  python '../../predict.py' \
    --checkpoint_file "${latest}" \
    --in_file "${out_dir}/${split}.tsv" \
    --out_file "${out_dir}/${split}.out" \
    --batch_size 256 \
    --gpus 1

  python '../../postprocess_sentence_selection.py' \
    --in_file "${out_dir}/${split}.tsv" \
    --pred_sent_file "${out_dir}/${split}.out" \
    --pred_doc_file "${data_dir}/document-retrieval/${split}.jsonl" \
    --out_file "${out_dir}/${split}.jsonl" \
    --max_evidence_per_claim 5

  python '../../eval_sentence_selection.py' \
    --gold_file "${data_dir}/${split}.jsonl" \
    --pred_file "${out_dir}/${split}.jsonl" \
    --out_file "${out_dir}/eval.${split}.txt"
done
