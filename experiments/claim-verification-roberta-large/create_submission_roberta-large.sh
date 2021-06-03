#!/bin/bash
#
# Copyright (c) 2021, Yamagishi Laboratory, National Institute of Informatics
# Authors: Canasai Kruengkrai (canasai@nii.ac.jp)
# All rights reserved.
#
# The submission file must be named 'predictions.jsonl' in the zip
# format. Using other names (e.g., 'shared_task_test.jsonl') causes
# the server's IOError and increases the submission count without
# getting any scoring output.

set -ex

pretrained='roberta-large'
max_len=128
out_dir="${pretrained}-${max_len}-out"
split='shared_task_test'

cd "${out_dir}" || exit
cp "${split}.jsonl" 'predictions.jsonl'
zip -m 'predictions.jsonl.zip' 'predictions.jsonl'
md5sum 'predictions.jsonl.zip'
