#!/bin/bash
#SBATCH --job-name=muon_airbench94
#SBATCH --output=logs/muon_airbench94_%j.out
#SBATCH --error=logs/muon_airbench94_%j.err
#SBATCH --time=00:30:00
#SBATCH --gpus=a100:1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G

# -------------------------------
# BASIC INFO
# -------------------------------
echo "[INFO] Starting SLURM job $SLURM_JOB_ID on node $(hostname)"
echo "[INFO] Current working dir: $PWD"

# -------------------------------
# LOAD USER CONFIG (.env)
# -------------------------------
if [ -f ".env" ]; then
    echo "[INFO] Loading environment variables from .env"
    set -a
    source .env
    set +a
else
    echo "[WARN] No .env file found. Using defaults."
fi

# Expected variables in .env (each user sets these):
# PROJECT_DIR=/cluster/project/cvg/students/<username>
# CONDA_ENV=muon
# CACHE_DIR=$PROJECT_DIR/.cache

# -------------------------------
# ENV SETUP
# -------------------------------
source "${PROJECT_DIR}/miniconda3/etc/profile.d/conda.sh"
conda activate "${CONDA_ENV:-muon}"

module purge
module load eth_proxy || true

nvidia-smi

# -------------------------------
# CACHE CONFIG (Torch, HuggingFace, CUDA)
# -------------------------------
CACHE_DIR=${CACHE_DIR:-"$PROJECT_DIR/.cache"}
export XDG_CACHE_HOME=$CACHE_DIR
export TORCH_HOME=$CACHE_DIR/torch
export TORCHINDUCTOR_CACHE_DIR=$CACHE_DIR/torch/inductor
export CUDA_CACHE_PATH=$CACHE_DIR/nv
export HF_HOME=$CACHE_DIR/huggingface
export TRANSFORMERS_CACHE=$HF_HOME
export HF_DATASETS_CACHE=$HF_HOME/datasets

mkdir -p "$TORCH_HOME" "$TORCHINDUCTOR_CACHE_DIR" "$CUDA_CACHE_PATH" "$HF_HOME/datasets"

echo "[INFO] Cache directories configured under $CACHE_DIR"

# -------------------------------
# RUN SCRIPT
# -------------------------------
echo "[INFO] Launching airbench94_muon.py ..."
python airbench94_muon.py

echo "[INFO] Job finished at $(date)"