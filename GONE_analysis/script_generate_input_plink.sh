#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH -p workq

module load bioinfo/VCFtools/0.1.16
vcftools --vcf cerana_jointgvcf_allchr_PASSonly.vcf --out cerana_jointgvcf_allchr_PASSonly --plink
