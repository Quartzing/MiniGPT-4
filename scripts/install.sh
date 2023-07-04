#!/bin/bash
# Get sub repos
git lfs install
git submodule update --init

# Install dependencies
pip install -r requirements.txt
# pip install -e FastChat

# Prepare dirs
MODEL_DIR=models
LLAMA_DIR=$MODEL_DIR/llama
VICUA_DIR=$MODEL_DIR/vicuna
MINIGPT4_DIR=$MODEL_DIR/minigpt4
mkdir -p $LLAMA_DIR
mkdir -p $VICUA_DIR
mkdir -p $MINIGPT4_DIR

# Download the original llama model
readarray -t URL_LIST < scripts/llama_urls.txt

function download_url() {
    local source_url=$1
    local target_dir=$2
    local target_path=$target_dir/${source_url##*/}

    echo downloading $source_url to $target_path...

    if [ -f $target_path ]; then
        echo $target_path
        echo $target_path already exits, skipping...
        return
    fi

    wget $source_url -P $target_dir/
}

for url in ${URL_LIST[@]}
do
    download_url $url $LLAMA_DIR
done

# Download MiniGPT4 weights
echo Downloading MiniGPT4 weights...
download_url https://drive.google.com/file/d/1RY9jV0dyqLX-o38LrumkKRh6Jtaop58R/view?usp=sharing

# Generate vicuna weights
python -m fastchat.model.apply_delta --base $LLAMA_DIR  --target $VICUA_DIR  --delta vicuna-7b-delta-v0/
