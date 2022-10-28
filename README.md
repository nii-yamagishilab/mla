# MLA

This is an implementation of our paper: [A Multi-Level Attention Model for Evidence-Based Fact Checking](https://aclanthology.org/2021.findings-acl.217/).
If you find our code and/or models useful, please cite:

```bash
@inproceedings{kruengkrai-etal-2021-multi,
    title = "A Multi-Level Attention Model for Evidence-Based Fact Checking",
    author = "Kruengkrai, Canasai and Yamagishi, Junichi and Wang, Xin",
    booktitle = "Findings of the Association for Computational Linguistics: ACL-IJCNLP 2021",
    year = "2021",
    publisher = "Association for Computational Linguistics",
    url = "https://aclanthology.org/2021.findings-acl.217",
    doi = "10.18653/v1/2021.findings-acl.217",
    pages = "2447--2460",
}
```

## Setup

The code requires:
- Python 3.7
- PyTorch 1.8.0
- PyTorch Lightning 1.2.8
- Huggingface transformers 4.3.3

We recommend to create a new environment for experiments using conda:

```bash
conda create -n mla python=3.7
conda activate mla
```

Then, install `mla` from the repository:

```bash
git clone https://github.com/nii-yamagishilab/mla
cd mla
pip install -r requirements.txt
```

To ensure that PyTorch is installed and CUDA works properly, run:

```bash
python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
```

We should see:

```bash
1.8.0+cu111
True
```

:warning: We use PyTorch 1.8.0 with CUDA 11.0. You may need another CUDA version suitable for your environment.

## Experiments

See [experiments](experiments).

## Acknowledgments

This work is supported by JST CREST Grants (JPMJCR18A6 and JPMJCR20D3) and MEXT KAKENHI Grants (21H04906), Japan.

## Licence

BSD 3-Clause License

Copyright (c) 2021, Yamagishi Laboratory, National Institute of Informatics All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

 * Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
