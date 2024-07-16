#!/bin/bash
#eSBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --cpus-per-task=1
#SBATCH -p workq

module load bioinfo/bedtools-2.27.1

cd /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Mellifera
for vcf1 in seqapipop870_jointgvcf_260123_*.filtered.Mellifera.vcf.gz; do
	gunzip $vcf1
	vcf=$(basename "$vcf1" .gz)
	scaffold=$(echo "$vcf" | sed 's/seqapipop870_jointgvcf_260123_//g' | sed 's/\.1\.filtered\.Mellifera\.vcf//g')
	bash script_compute_div_slidingwindows.sh $vcf /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Mellifera 100000 recontrseq_mellifera2_$scaffold
	gzip $vcf
done
