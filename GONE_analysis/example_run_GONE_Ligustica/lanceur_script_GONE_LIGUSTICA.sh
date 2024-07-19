#!/bin/bash
#SBATCH -p workq
#SBATCH -t 02-00:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds". 
#SBATCH --mem-per-cpu=80G

#Load modules
module load bioinfo/GONE/134996d

# GONE all chr
/work/genphyse/cytogen/Thibault/SeqApiPop_demography/GONE/Ouessant/script_GONE.sh seqapipop870_jointgvcf_260123_allnuclearchr.filtered.Ligustica.filteredkinship.biallelic.500kSNPs.withheader 

# THIS ONE works for chr1!
#/work/genphyse/cytogen/Thibault/SeqApiPop_demography/GONE/Cerana2/script_GONE.sh cerana_jointgvcf_allchr_PASSonly.biallelic.500kSNPs.withheader.chr1


#/work/genphyse/cytogen/Thibault/SeqApiPop_demography/GONE/Cerana2/script_GONE.sh cerana_jointgvcf_allchr_PASSonly200k.withheader
#/work/genphyse/cytogen/Thibault/SeqApiPop_demography/GONE/Cerana2/script_GONE.sh cerana_jointgvcf_allchr_PASSonly
