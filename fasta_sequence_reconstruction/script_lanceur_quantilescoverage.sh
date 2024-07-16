#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=80G
#SBATCH -p workq

module load system/Python-2.7.2
module load system/R-4.1.2_gcc-9.3.0

cd /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/
#bash script_VCF2Fasta_withoutcovqual.sh subsampling_3pm_position_coverage.withheader.vcf /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/ 20 3 1000 
bash script_VCF2Fasta_withoutcovqual_Rstatonly.sh subsampling_3pm_position_coverage.withheader.vcf /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/ 20 3 1000
