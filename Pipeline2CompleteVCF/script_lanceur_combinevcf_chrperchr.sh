#!/bin/bash
#SBATCH -p workq


# TL - 250123 #Modified 260723
while read line; do 
	chr=$(echo $line | awk '{print $1}')
	sed "s/chr0/$chr/g" script_combinevcf_Dorsata.sh | sed "s/multigvcf_260723/multigvcf_260723_$chr/g" >  script_combinevcf_Dorsata.sh.tmp
	job_ID=$(echo "$chr""_combinegvcf")
	sbatch -J "$job_ID" script_combinevcf_Dorsata.sh.tmp
	sleep 60
done <  HAv3_1_Chromosomes.list  #prealablement: HAv3_1_Chromosomes.list
