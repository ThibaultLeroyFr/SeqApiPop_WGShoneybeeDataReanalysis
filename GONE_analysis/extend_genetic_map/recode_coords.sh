#!/bin/bash

#SBATCH --partition=workq
#SBATCH --job-name=recode_coords
#SBATCH --output=./recode_coords.out
#SBATCH --error=./recode_coords.err
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=12G

t0=$(date "+%s")

labs="../ancestral_allele/chromosome_labels.tsv"

awk -f recode_coords.awk $labs CHROM_POS_v0.tsv > CHROM_POS_v1.tsv

t1=$(date "+%s")

echo "elapsed wall time is $((t1-t0))"
