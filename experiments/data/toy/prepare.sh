#!/bin/bash
#
# Copyright (c) 2021, Yamagishi Laboratory, National Institute of Informatics
# Author: Canasai Kruengkrai (canasai@nii.ac.jp)
# All rights reserved.

set -ex

for fname in 'train.jsonl' 'shared_task_dev.jsonl'; do
  if [[ "${fname}" == 'train.jsonl' ]]; then
    num=1333
  else
    num=333
  fi

  cat /dev/null > "${fname}"
  for label in 'SUPPORTS' 'REFUTES' 'NOT ENOUGH INFO'; do
    grep "${label}" "../${fname}" | head -n "${num}" >> "${fname}"
  done
  wc -l "${fname}"
done

doc_dir='document-retrieval'
mkdir -p "${doc_dir}"
for fname in 'train.jsonl' 'shared_task_dev.jsonl'; do
  if [[ "${fname}" == 'train.jsonl' ]]; then
    num=1333
  else
    num=333
  fi

  cat /dev/null > "${doc_dir}/${fname}"
  for label in 'SUPPORTS' 'REFUTES' 'NOT ENOUGH INFO'; do
    grep "${label}" "../document-retrieval/${fname}" | head -n "${num}" >> "${doc_dir}/${fname}"
  done
  wc -l "${fname}"
done

if [[ ! -f 'corpus.jsonl' ]]; then
  ln -s '../corpus.jsonl' .
fi
