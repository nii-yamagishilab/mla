#!/bin/bash
#
# Copyright (c) 2021, Yamagishi Laboratory, National Institute of Informatics
# Author: Canasai Kruengkrai (canasai@nii.ac.jp)
# All rights reserved.

set -ex

wget 'https://s3-eu-west-1.amazonaws.com/fever.public/train.jsonl'
wget 'https://s3-eu-west-1.amazonaws.com/fever.public/shared_task_dev.jsonl'
wget 'https://s3-eu-west-1.amazonaws.com/fever.public/shared_task_test.jsonl'
wget 'https://s3-eu-west-1.amazonaws.com/fever.public/wiki_index/fever.db'

doc_dir='document-retrieval'
if [[ ! -d "${doc_dir}" ]]; then
  mkdir -p "${doc_dir}"
  wget 'https://public.ukp.informatik.tu-darmstadt.de/fever-2018-team-athene/document_retrieval_datasets.zip'
  unzip 'document_retrieval_datasets.zip'
  mv 'train.wiki7.jsonl' "${doc_dir}/train.jsonl"
  mv 'dev.wiki7.jsonl' "${doc_dir}/shared_task_dev.jsonl"
  mv 'test.wiki7.jsonl' "${doc_dir}/shared_task_test.jsonl"
fi

if [[ ! -f 'corpus.jsonl' ]]; then
  for split in 'train' 'shared_task_dev' 'shared_task_test'; do
    python '../../preprocess_corpus.py' \
      --db_file 'fever.db' \
      --in_file "${doc_dir}/${split}.jsonl" \
      --out_file "tmp_${split}.jsonl"
  done
  cat tmp_*.jsonl | sort | uniq > 'corpus.jsonl'
  rm -f tmp_*.jsonl
  wc -l 'corpus.jsonl'
fi

cd 'toy' || exit
sh 'prepare.sh'
