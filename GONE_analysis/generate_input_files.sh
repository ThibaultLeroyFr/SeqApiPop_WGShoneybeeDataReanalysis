#!/bin/bash

#SBATCH --partition=workq
#SBATCH --job-name=XX_input_files
#SBATCH --output=./generate_input_files.out
#SBATCH --error=./generate_input_files.err
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=12G

t0=$(date "+%s")

module load bioinfo/VCFtools/0.1.16

# !! VERSION WITH GENETIC MAP !!

# Bgzipped VCF used as input (should contain all samples from all clusters)
vcfin="/work/genphyse/cytogen/Thibault/SeqApiPop_data/MetaGenotypesCalled870_raw_snps_allfilter.vcf.gz"
# Cluster (population) under consideration
pop="XX"
# List of samples retained for the cluster
list="../list_indiv/${pop}.list"
# Location of AWK's scripts
sdir="/work/user/pfaux/bees/SeqApiPop/GONE/"
# Location of genetic map (one header row; $1 = CHROM, $2 = POS-BP, $3 = RATE, $4 = POS-CM)
gmap="/work/user/pfaux/bees/genetic_map.tsv" 


# (1) Set up a VCF with qualification rules (cf. ./README)
vcftools --gzvcf $vcfin --keep $list --recode --stdout --remove-filtered-all --remove-indels --not-chr NC_001566 --not-chr NC_001566.1 --min-alleles 2 --max-alleles 2 --max-missing 0.9 | \
	vcftools --vcf - --mac 1 --recode --stdout | \
	grep -v "0\/1" | \
	bgzip -c > tmp.vcf.gz 
tabix -p vcf tmp.vcf.gz

# (2) Retain max. 500K variants of this VCF and output 012 files
zgrep "^#" tmp.vcf.gz > tmp.header
zgrep -v "^#" tmp.vcf.gz | shuf | head -500000 | sort -k1,1 -k2g,2 > tmp.selected
cat tmp.header tmp.selected | \
	vcftools --vcf - --012 --out $pop

# (3) Shuffle the drones and pair them
shuf ${pop}.012.indv | awk 'NR%2==1{first=$1} NR%2==0{print first"_"$1"\t"first"\t"$1}' > fake_queens.tsv

# (4) Create the PED/MAP files (using a dedicated AWK script and the chromosome labels file)
awk -f ${sdir}/generate_PED.awk -v pop=$pop ${pop}.012.indv ${pop}.012 fake_queens.tsv > ${pop}.ped
chrlabels="/work/user/pfaux/bees/SeqApiPop/ancestral_allele/chromosome_labels.tsv"
awk 'BEGIN{fid=0; OFS="\t"} FNR==1{fid++} fid==1{c[$1]=$2} fid==2{print c[$1], $2}' $chrlabels ${pop}.012.pos > tmp.coords
extend_genetic_map ${gmap} tmp.coords 16 
awk 'BEGIN{OFS="\t"} {print $1, "variant_"NR, $3, $2}' genetic_positions.txt > ${pop}.map

# (5) Clear temporary files
rm tmp.header tmp.selected tmp.vcf.gz* tmp.coords genetic_positions.txt

t1=$(date "+%s")

echo "elapsed wall time is $((t1-t0))"
