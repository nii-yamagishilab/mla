#!/bin/bash
#
# Copyright (c) 2021, Yamagishi Laboratory, National Institute of Informatics
# Authors: Canasai Kruengkrai (canasai@nii.ac.jp)
# All rights reserved.

wget --no-check-certificate \
  'https://cloud.tsinghua.edu.cn/d/1499a062447f4a3d8de7/files/?p=%2Ftrain.ensembles.s10.jsonl&dl=1' \
  -O 'train.jsonl'

wget --no-check-certificate \
  'https://cloud.tsinghua.edu.cn/d/1499a062447f4a3d8de7/files/?p=%2Fdev.ensembles.s10.jsonl&dl=1' \
  -O 'shared_task_dev.jsonl'
