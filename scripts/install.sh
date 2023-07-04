#!/bin/bash
source scripts/download.sh

# Get sub repos
# curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
# apt-get install git-lfs
# git lfs install
git submodule update --init

# Install dependencies
pip install -r requirements.txt
pip install -e FastChat

# Prepare dirs
MODEL_DIR=models
LLAMA_DIR=$MODEL_DIR/llama
VICUA_DIR=$MODEL_DIR/vicuna
MINIGPT4_DIR=$MODEL_DIR/minigpt4
OUTPUT_DIR=$MODEL_DIR/output
mkdir -p $LLAMA_DIR
mkdir -p $VICUA_DIR
mkdir -p $MINIGPT4_DIR
mkdir -p $OUTPUT_DIR

# Download the original llama model weights
download_all_urls scripts/llama_urls.txt $LLAMA_DIR

# Download the original vicuna model weights
download_all_urls scripts/vicuna_urls.txt $VICUA_DIR

# Generate vicuna weights
python -m fastchat.model.apply_delta --base $LLAMA_DIR  --target $OUTPUT_DIR  --delta $VICUA_DIR
