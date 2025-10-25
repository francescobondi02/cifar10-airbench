#!/bin/bash
#SBATCH --job-name=muon_airbench94
#SBATCH --output=logs/muon_airbench94_%j.out
#SBATCH --error=logs/muon_airbench94_%j.err
#SBATCH --time=00:30:00
#SBATCH --gpus=a100:1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G

# -------------------------------
# ENV SETUP
# -------------------------------
echo "[INFO] Starting SLURM job $SLURM_JOB_ID on node $(hostname)"

# Attiva Conda
source /cluster/project/cvg/students/fbondi/miniconda3/etc/profile.d/conda.sh
conda activate muon

module purge
module load eth_proxy || true

nvidia-smi

# -------------------------------
# HUGGINGFACE CACHE CONFIG
# -------------------------------
export HF_HOME=/cluster/project/cvg/students/fbondi/.cache/huggingface
export TRANSFORMERS_CACHE=$HF_HOME
export HF_DATASETS_CACHE=$HF_HOME/datasets

# -------------------------------
# RUN SCRIPT
# -------------------------------

python airbench94_muon.py

echo "[INFO] Job finished at $(date)"