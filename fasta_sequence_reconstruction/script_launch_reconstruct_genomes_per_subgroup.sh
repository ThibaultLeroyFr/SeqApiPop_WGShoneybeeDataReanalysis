#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH -p workq

cd /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/

# consider a population
currentpop=$(echo "Buckfast")


mkdir $currentpop
cd $currentpop
awk -v pop="$currentpop" '$1 == pop {print $2}' ../Admixture_K9_fromTableS7Wragg.filteringQvalue90pc.txt > sample_file."$currentpop".txt
cd ..

for file in seqapipop870_jointgvcf_*1.vcf.gz; do
	echo "#!/bin/bash" > script_reconstructseq_chromosome.tmp
	echo "#SBATCH --cpus-per-task=1"  >> script_reconstructseq_chromosome.tmp
	echo "#SBATCH --mem-per-cpu=100G" >> script_reconstructseq_chromosome.tmp
	echo "module load bioinfo/bcftools-1.9" >> script_reconstructseq_chromosome.tmp
	echo "module load system/Python-2.7.15" >> script_reconstructseq_chromosome.tmp
	echo "cd /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/" >> script_reconstructseq_chromosome.tmp
	echo "gunzip $file" >> script_reconstructseq_chromosome.tmp
	prefix=$(basename $file .vcf.gz)
	echo "cd $currentpop" >> script_reconstructseq_chromosome.tmp
	echo "bcftools view -S sample_file."$currentpop".txt ../"$prefix".vcf > "$prefix"."$currentpop".vcf"  >> script_reconstructseq_chromosome.tmp
	echo "gzip ../"$prefix".vcf" >> script_reconstructseq_chromosome.tmp
	echo "python2 ../VCF2Fasta_haploid_withquantiles.py -f "$prefix"."$currentpop".vcf -q 20 -m 3 -M 1000 -c ../summary_statistics_coverage_ind.txt" >> script_reconstructseq_chromosome.tmp
	echo "gzip "$prefix"."$currentpop".vcf" >> script_reconstructseq_chromosome.tmp
	sbatch script_reconstructseq_chromosome.tmp
	sleep 120
done

