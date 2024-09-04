#!/bin/bash

#SBATCH --partition=workq
#SBATCH --job-name=extend_genetic_map
#SBATCH --output=./extend_genetic_map.out
#SBATCH --error=./extend_genetic_map.err
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=12G

t0=$(date "+%s")


# # for the sake of checking, I merge the positions of the original map with requested positions
# cp CHROM_POS_v1.tsv coordinates.tsv
# sed 1d ../../genetic_map.tsv | cut -f-2 >> coordinates.tsv
memusg extend_genetic_map ../../genetic_map.tsv CHROM_POS_v1.tsv 16
cleanspace genetic_positions.txt
mv genetic_positions.txt SeqApiPop_genetic_map.tsv


t1=$(date "+%s")

echo "elapsed wall time is $((t1-t0))"
