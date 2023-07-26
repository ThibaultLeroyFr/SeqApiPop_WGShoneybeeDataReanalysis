#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=80G
#SBATCH -p workq
module load bioinfo/gatk-4.2.2.0

gatk --java-options "-Xmx80g" GenotypeGVCFs  \
        -R /home/vignal/save/Genomes/Abeille/HAv3_1_indexes/GCF_003254395.2_Amel_HAv3.1_genomic.fna \
        -V dorsata_multigvcf_260723_NC_001566.1.vcf.gz \
        --use-new-qual-calculator \
	--all-sites true \
        -O dorsata_jointgvcf_260723_NC_001566.1.vcf.gz


