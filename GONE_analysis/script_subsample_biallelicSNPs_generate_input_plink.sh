#!/bin/bash
#SBATCH -p workq
module load bioinfo/Bcftools/1.9
module load bioinfo/PLINK/1.90b7

# print only sites that looks biallelic
awk -F "\t" '$5 != "." {print $0}' cerana_jointgvcf_allchr_PASSonly.vcf | awk '$4 == "A" || $4 == "C" || $4 == "G" || $4 == "T" {print $0}' | awk '$5 == "A" || $5 == "C" || $5 == "G" || $5 == "T" {print $0}' | grep -v "NC_001566" > cerana_jointgvcf_allchr_PASSonly.tmp
# add the header
cat cerana_jointgvcf_allchr_PASSonly.vcf.header cerana_jointgvcf_allchr_PASSonly.tmp > cerana_jointgvcf_allchr_PASSonly.tmp2
mv cerana_jointgvcf_allchr_PASSonly.tmp2 cerana_jointgvcf_allchr_PASSonly.tmp
# keep only two alleles and check again if there is no indel etc
bcftools view --max-alleles 2 --exclude-types indels cerana_jointgvcf_allchr_PASSonly.tmp > cerana_jointgvcf_allchr_PASSonly.biallelic.vcf
# subsample 5% of the sites ~500k SNPs
grep -v "#" cerana_jointgvcf_allchr_PASSonly.biallelic.vcf | awk 'BEGIN  {srand()} !/^$/  { if (rand() <= .05) print $0}' > cerana_jointgvcf_allchr_PASSonly.biallelic.500kSNPs.vcf
cat cerana_jointgvcf_allchr_PASSonly.vcf.header cerana_jointgvcf_allchr_PASSonly.biallelic.500kSNPs.vcf > cerana_jointgvcf_allchr_PASSonly.biallelic.500kSNPs.withheader.vcf

#Generate ped and map files
plink --vcf cerana_jointgvcf_allchr_PASSonly.biallelic.500kSNPs.withheader.vcf -recode --allow-extra-chr --out cerana_jointgvcf_allchr_PASSonly.biallelic.500kSNPs.withheader
