#!/bin/bash

#SBATCH --partition=workq
#SBATCH --open-mode=truncated
#SBATCH --job-name=XX_run_GONE
#SBATCH --output=./run_GONE.out
#SBATCH --error=./run_GONE.err
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
#SBATCH --mem=20G

t0=$(date "+%s")

# Name (code) of the population to run - $pop.ped and $pop.map should exist
pop="XX"

# Load GONE's module
module load bioinfo/GONE/134996d

# Next lines are taken from script_GONE.sh
FILE=$pop  ### Data file name for files .ped and .map

### Take input parameters from file INPUT_PARAMETERS_FILE
source /work/user/pfaux/bees/SeqApiPop/GONE/INPUT_PARAMETERS_FILE # Standard input parameters file (i.e. with dist = 1 and 25 cM/Mb)

###################### FILES NEEDED ########################

### data.ped
### data.map

### EXECUTABLES FILES NEEDED IN DIRECTORY PROGRAMMES:

### MANAGE_CHROMOSOMES2
### LD_SNP_REAL3
### SUMM_REP_CHROM3
### GONE (needs gcc/7.2.0)
### GONEaverages
### GONEparallel.sh

################### Remove previous output files ##################
if [ -f "OUTPUT_$FILE" ] ; then rm OUTPUT_$FILE; fi
if [ -f "Ne_$FILE" ] ; then rm Ne_$FILE; fi

################### Create temporary directory ##################
if [ -d "TEMPORARY_FILES" ] ; then rm -r TEMPORARY_FILES; fi
mkdir TEMPORARY_FILES

################### Obtain sample size, number of chromosomes, number of SNPs ##################
cp $FILE.map data.map
cp $FILE.ped data.ped

tr '\t' ' ' < data.map > KK1
cut -d ' ' -f1 < KK1 > KK2
grep -w "" -c data.ped > NIND
tail -n 1 data.map | tr '\t' ' ' | cut -d ' ' -f1 > NCHR
SAM=$(grep -w "" -c $FILE.ped)
NCHR=$(tail -n 1 data.map | tr '\t' ' ' | cut -d ' ' -f1)

for((i=1;i<=$NCHR;i++))
do
	grep -wc "$i" < KK2 > NCHR$i
done

if [ -f "SNP_CHROM" ] ; then rm SNP_CHROM; fi

for((i=1;i<=$NCHR;i++))
do
cat NCHR$i >> SNP_CHROM
done

rm KK*

################### Divide ped and map files into chromosomes ##################

echo "DIVIDE .ped AND .map FILES IN CHROMOSOMES"
echo "DIVIDE .ped AND .map FILES IN CHROMOSOMES" > timefile

num=$RANDOM
echo "$num" > seedfile

/usr/local/bioinfo/src/GONE/GONE-134996d/Linux/PROGRAMMES/MANAGE_CHROMOSOMES2>>out<<@
-99
$maxNSNP
@

rm NCHR*
rm NIND
rm SNP_CHROM
###mv checkfile TEMPORARY_FILES/

################### LOOP CHROMOSOMES ##################
### Analysis of linkage disequilibrium in windows of genetic
### distances between pairs of SNPs for each chromosome

if [ $maxNCHROM != -99 ] ; then NCHR=$maxNCHROM; fi

echo "RUNNING ANALYSIS OF CHROMOSOMES ..."
echo "RUNNING ANALYSIS OF CHROMOSOMES" >> timefile

options_for_LD="$SAM $MAF $PHASE $NGEN $NBIN $ZERO $DIST $cMMb"

if [ $threads -eq -99 ] ; then threads=$(getconf _NPROCESSORS_ONLN); fi

START=$(date +%s)

cp chromosome* TEMPORARY_FILES/

###### LD_SNP_REAL3 #######

### Obtains values of c, d2, etc. for pairs of SNPs in bins for each chromosome
for ((n=1; n<=$NCHR; n++)); do echo $n; done | xargs -I % -P $threads bash -c "/usr/local/bioinfo/src/GONE/GONE-134996d/Linux/PROGRAMMES/LD_SNP_REAL3 % $options_for_LD"

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "CHROMOSOME ANALYSES took $DIFF seconds"
echo "CHROMOSOME ANALYSES took $DIFF seconds" >> timefile

######################## SUMM_REP_CHROM3 #########################
### Combination of all data gathered from chromosomes into a single output file

### Adds results from all chromosomes

for ((n=1; n<=$NCHR; n++))
do
cat outfileLD$n >> CHROM
echo "CHROMOSOME $n" >> OUTPUT
sed '2,3d' outfileLD$n > temp
mv temp outfileLD$n
cat parameters$n >> OUTPUT
done

mv outfileLD* TEMPORARY_FILES/
rm parameters*

/usr/local/bioinfo/src/GONE/GONE-134996d/Linux/PROGRAMMES/SUMM_REP_CHROM3>>out<<@
$NGEN	NGEN
$NBIN	NBIN
$NCHR	NCHR
@

mv chrom* TEMPORARY_FILES/

echo "TOTAL NUMBER OF SNPs" >> OUTPUT_$FILE
cat nsnp >> OUTPUT_$FILE
echo -e "\n" >> OUTPUT_$FILE
echo "HARDY-WEINBERG DEVIATION" >> OUTPUT_$FILE
cat outfileHWD >> OUTPUT_$FILE
echo -e "\n" >> OUTPUT_$FILE
cat OUTPUT >> OUTPUT_$FILE
echo -e "\n" >> OUTPUT_$FILE
echo "INPUT FOR GONE" >> OUTPUT_$FILE
echo -e "\n" >> OUTPUT_$FILE
cat outfileLD >> OUTPUT_$FILE

rm nsnp
rm OUTPUT
rm CHROM

############################# GONE.cpp ##########################
### Obtain estimates of temporal Ne from GONE

echo "Running GONE"
echo "Running GONE" >> timefile
START=$(date +%s)

/usr/local/bioinfo/src/GONE/GONE-134996d/Linux/PROGRAMMES/GONEparallel.sh -hc $hc outfileLD $REPS

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "GONE run took $DIFF seconds"
echo "GONE run took $DIFF seconds" >> timefile

echo "END OF ANALYSES"
echo "END OF ANALYSES" >> timefile

mv outfileLD_Ne_estimates Output_Ne_$FILE
mv outfileLD_d2_sample Output_d2_$FILE
rm outfileLD
rm data.ped
rm data.map
rm out
mv outfileLD_TEMP TEMPORARY_FILES/


t1=$(date "+%s")

echo "elapsed wall time is $((t1-t0))"
