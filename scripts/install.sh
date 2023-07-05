#!/bin/bash
source scripts/download.sh

# Prepare dirs
MODEL_DIR=models
LLAMA_DIR=$MODEL_DIR/llama
VICUNA_DIR=$MODEL_DIR/vicuna-7b-delta-v0
MINIGPT4_DIR=$MODEL_DIR/minigpt4
OUTPUT_DIR=$MODEL_DIR/output
mkdir -p $LLAMA_DIR
mkdir -p $OUTPUT_DIR

# Install dependencies
# pip install -r requirements.txt
# conda create -n vicuna python=3.10
# bash && conda init bash
# conda activate vicuna

# Download vicuna delta weights
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
apt-get install git-lfs
git lfs install
git -C $VICUA_DIR clone https://huggingface.co/lmsys/vicuna-7b-delta-v0

# Download the original llama model weights
# pip install pyllama
# python -m llama.download --model_size 7B --folder $LLAMA_DIR
download_all_urls $PWD/scripts/llama_urls.txt $LLAMA_DIR

# Generate vicuna weights
git submodule update --init
pip install -e FastChat
python -m fastchat.model.apply_delta --base $LLAMA_DIR  --target $OUTPUT_DIR  --delta $VICUA_DIR
