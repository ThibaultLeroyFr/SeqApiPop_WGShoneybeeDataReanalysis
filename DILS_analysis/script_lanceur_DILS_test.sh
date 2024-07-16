#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --cpus-per-task=4
#SBATCH --nodes=4
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=30G
#SBATCH -p workq

module load bioinfo/snakemake-7.8.1
module load system/pypy2.7-v7.3.12
module load system/Python-2.7.15
#module load system/R-3.5.2
module load system/R-4.1.2_gcc-9.3.0
#snakemake --snakefile /work/genphyse/cytogen/Thibault/Softwares/DILS-master/bin/Snakefile_2pop_ABCrf -p -j 4 --configfile /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Demo_DILS_tests/bidon.yaml --cluster-config /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Demo_DILS_tests/cluster_test.json --cluster "sbatch --nodes={cluster.node} --ntasks={cluster.n} --cpus-per-task={cluster.cpusPerTask} --time={cluster.time}"
snakemake --snakefile /work/genphyse/cytogen/Thibault/Softwares/DILS-master/bin/Snakefile_2pop -p -j 4 --configfile /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Demo_DILS_tests/bidon.yaml --cluster-config /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Demo_DILS_tests/cluster_test.json --cluster "sbatch --nodes={cluster.node} --ntasks={cluster.n} --cpus-per-task={cluster.cpusPerTask} --time={cluster.time}"


