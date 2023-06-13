#!/usr/bin/env bash

checkpoint_urls=(
    "https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors" # SD 1.5 base checkpoint
    "https://civitai.com/api/download/models/94081" # Dreamshaper V6
    "https://civitai.com/api/download/models/86437" # AbsoluteReality v1
    "https://civitai.com/api/download/models/88418" # AbsoluteReality v1-INPAINTING 
    "https://civitai.com/api/download/models/84576" # Reliberate v1.0
    "https://huggingface.co/XpucT/Reliberate/resolve/main/Reliberate-inpainting.safetensors" # Reliberate v1.0-INPAINTING
    "https://civitai.com/api/download/models/15236" # Deliberate v2
)

lora_urls=(
    "https://civitai.com/api/download/models/78467" # 3D Rendering Style
    "https://civitai.com/api/download/models/87153" # More Details
    "https://civitai.com/api/download/models/63006" # LowRA
)

vae_urls=(
    "https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.ckpt"
)

embedding_urls=(
    "https://civitai.com/api/download/models/9208" # EasyNegative (negative embedding)
    "https://civitai.com/api/download/models/94057" # FastNegative + FastNegativeV2 (negative embeddings)
    "https://civitai.com/api/download/models/77169" # BadDream + UnrealisticDream (negative embeddings)
)

# Clone the repo
echo "Cloning the repo"
git clone -b "v1.3.0-RC" https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

# Download checkpoints
echo "###################################"
echo "##### Downloading checkpoints #####"
echo "###################################"
mkdir -p models/Stable-diffusion
pushd models/Stable-diffusion
for i in "${checkpoint_urls[@]}";
do
    echo "Downloading $i"
    wget --no-clobber --content-disposition "$i"
done
popd

# Download loras
echo "#############################"
echo "##### Downloading loras #####"
echo "#############################"
mkdir -p models/Lora
pushd models/Lora
# Loop over the array with wget to get loras
for i in "${lora_urls[@]}";
do
    echo "Downloading $i"
    wget --no-clobber --content-disposition "$i"
done
popd

# Download VAE
echo "###########################"
echo "##### Downloading VAE #####"
echo "###########################"
mkdir -p models/VAE
pushd models/VAE
for i in "${vae_urls[@]}";
do
    echo "Downloading $i"
    wget --no-clobber --content-disposition "$i"
done
popd

# Download TI Embeddings
echo "##################################"
echo "##### Downloading embeddings #####"
echo "##################################"
mkdir -p embeddings
pushd embeddings
for i in "${embedding_urls[@]}";
do
    echo "Downloading $i"
    wget --no-clobber --content-disposition "$i"
done
popd

python -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install wheel opencv-python-headless

export COMMANDLINE_ARGS="--share --xformers --listen --no-half --no-half-vae --precision=full$@"
export TORCH_COMMAND="pip install torch==2.0.0+cu117 torchvision==0.15.1+cu117 torchaudio==2.0.1 --index-url https://download.pytorch.org/whl/cu117"
bash ./webui.sh -f