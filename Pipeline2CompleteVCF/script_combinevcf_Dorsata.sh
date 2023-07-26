#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=80G
#SBATCH -p workq
module load bioinfo/gatk-4.2.2.0

gatk --java-options "-Xmx80G" CombineGVCFs \
    -L chr0 \
    -R /home/vignal/save/Genomes/Abeille/HAv3_1_indexes/GCF_003254395.2_Amel_HAv3.1_genomic.fna \
    --variant DoLa-D10_SRR23343482_Dorsata.g.vcf.gz \
    --variant DoLa-D18_SRR23343441_Dorsata.g.vcf.gz \
    --variant DoLa-D23_SRR23343474_Dorsata.g.vcf.gz \
    --variant DoLa-D3_SRR23343492_Dorsata.g.vcf.gz \
    --variant DoLa-HD14_SRR23343458_Dorsata.g.vcf.gz \
    --variant DoLa-HD22_SRR23343445_Dorsata.g.vcf.gz \
    --variant DoLa-HD28_SRR23343450_Dorsata.g.vcf.gz \
    --variant DoLa-HD8_SRR23343468_Dorsata.g.vcf.gz \
    --variant DoLa-D12_SRR23343440_Dorsata.g.vcf.gz \
    --variant DoLa-D20_SRR23343484_Dorsata.g.vcf.gz \
    --variant DoLa-D27_SRR23343479_Dorsata.g.vcf.gz \
    --variant DoLa-D4_SRR23343486_Dorsata.g.vcf.gz \
    --variant DoLa-HD18_SRR23343454_Dorsata.g.vcf.gz \
    --variant DoLa-HD25_SRR23343442_Dorsata.g.vcf.gz \
    --variant DoLa-HD2_SRR23343462_Dorsata.g.vcf.gz \
    --variant DoLa-D14_SRR23343438_Dorsata.g.vcf.gz \
    --variant DoLa-D21_SRR23343489_Dorsata.g.vcf.gz \
    --variant DoLa-D29_SRR23343477_Dorsata.g.vcf.gz \
    --variant DoLa-D7_SRR23343475_Dorsata.g.vcf.gz \
    --variant DoLa-HD191_SRR23343453_Dorsata.g.vcf.gz \
    --variant DoLa-HD26_SRR23343452_Dorsata.g.vcf.gz \
    --variant DoLa-HD4_SRR23343473_Dorsata.g.vcf.gz \
    --O /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Dorsata/dorsata_multigvcf_260723.vcf.gz
