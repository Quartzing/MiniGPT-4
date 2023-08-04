#!/bin/bash
# Source the download script which is likely responsible for downloading files from URLs
source scripts/download.sh

# Prepare dirs
# Set the base directory for the models
MODEL_DIR=models
# Set the directory for the llama model weights
LLAMA_DIR=$MODEL_DIR/llama
# Set the directory for the vicuna delta weights
VICUNA_DIR=$MODEL_DIR/vicuna-7b-delta-v0
# Set the directory for the MiniGPT-4 model weights
MINIGPT4_DIR=$MODEL_DIR/minigpt4
# Set the directory for the output model weights
OUTPUT_DIR=$MODEL_DIR/output
# Create the directories if they do not already exist
mkdir -p $LLAMA_DIR
if [ ! -d "$OUTPUT_DIR" ]; then
  echo -e "\033[1m\033[33mWARNING: The directory $OUTPUT_DIR does not exist. Creating now...\033[0m"
  mkdir -p $OUTPUT_DIR
fi

# Download the original llama model weights
download_all_urls $PWD/scripts/llama_urls.txt $LLAMA_DIR

# Download the vicuna delta weights
download_all_urls $PWD/scripts/vicuna_urls.txt $VICUNA_DIR

# Generate vicuna weights
# Update the git submodules
git submodule update --init
# Install the FastChat package
pip install -e FastChat
# Apply the vicuna delta weights to the llama model weights and save the result to the output directory
python -m fastchat.model.apply_delta --base-model-path $LLAMA_DIR  --target-model-path $OUTPUT_DIR  --delta-path $VICUNA_DIR
