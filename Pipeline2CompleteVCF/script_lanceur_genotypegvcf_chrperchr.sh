#!/bin/bash
#SBATCH -p workq

# TL - 250123
while read line; do 
	chr=$(echo $line | awk '{print $1}')
	newID=$( echo "dorsata_multigvcf_260723_""$chr"".vcf.gz")
	newoutput=$(echo "dorsata_jointgvcf_260723_""$chr"".vcf.gz")
	sed "s/dorsata_multigvcf_260723_NC_001566.1.vcf.gz/$newID/g" script_genotypeGVCFsHAV3_1.sh | sed "s/dorsata_jointgvcf_260723_NC_001566.1.vcf.gz/$newoutput/g" >  script_genotypeGVCFsHAV3_1.tmp
	job_ID=$(echo "$chr""_jointvcf")
	#head -20 script_genotypeGVCFsHAV3_1.tmp
	sbatch -J "$job_ID" script_genotypeGVCFsHAV3_1.tmp
	sleep 60
done < HAv3_1_Chromosomes.list
