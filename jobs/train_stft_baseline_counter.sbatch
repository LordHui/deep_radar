#!/usr/bin/env bash

#SBATCH --gres=gpu:1
#SBATCH --job-name=train-radar-counter-stft-gridsearch
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16GB
#SBATCH --time=7-0
#SBATCH --mail-type=ALL
#SBATCH --output="train-radar-counter-stft-gridsearch-%j.out"
#SBATCH --err="train-radar-counter-stft-gridsearch-%j.err"

source ~/.bashrc
cd `git rev-parse --show-toplevel`

module purge
module load cudnn/9.0v7.3.0.29
if [ $USER == "sk7898" ]; then
    source activate l3embedding-tf-12
else
    source activate l3embedding-new-cpu
fi

SRCDIR=.
WINDOW=256
BATCH_SIZE=64
DATA_DIR=$SCRATCH/pedbike/window_256
OUTPUT_DIR=$SCRATCH/radar_counting/models
DATA_TYPE='stft'
MODEL_TYPE='lstm_stft'
CV=3

python $SRCDIR/train_baseline_counter.py \
       -base $DATA_DIR \
       -datatype $DATA_TYPE \
       -cv $CV \
       -mt $MODEL_TYPE \
       -window $WINDOW \
       -outdir $OUTPUT_DIR \
       -tbs $BATCH_SIZE
