#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --cpus-per-task=2
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=30G
#SBATCH -p workq

# new version
module load bioinfo/Snakemake/7.20.0
module load devel/PyPy/3.10-v7.3.12
module load devel/python/Python-3.7.9
module load compilers/gcc/11.2.0
module load statistics/R/4.1.1
snakemake --snakefile /work/genphyse/cytogen/Thibault/Softwares/DILS-master_aout23/bin/Snakefile_2pop -p -j 2 --configfile /work/genphyse/cytogen/Thibault/SeqApiPop_demography/DILS3/Mellifera_Carnica_constantNe_noSFS_outgroupLaboriosa/Mellifera_Carnica_constantNe_noSFS_outgroupLaboriosa.yaml --cluster-config /work/genphyse/cytogen/Thibault/SeqApiPop_demography/DILS3/Mellifera_Carnica_constantNe_noSFS_outgroupLaboriosa/cluster.json --cluster "sbatch --nodes={cluster.node} --ntasks={cluster.n} --cpus-per-task={cluster.cpusPerTask} --time={cluster.time}"

# before
#module load bioinfo/snakemake-7.8.1
#module load system/pypy2.7-v7.3.12
#module load system/Python-2.7.15
#module load system/R-3.5.2
#module load system/R-4.1.2_gcc-9.3.0
#snakemake --snakefile /work/genphyse/cytogen/Thibault/Softwares/DILS-master/bin/Snakefile_2pop -p -j 2 --configfile /work/genphyse/cytogen/Thibault/SeqApiPop_demography/DILS3/Mellifera_Carnica_constantNe_noSFS_outgroupLaboriosa/Mellifera_Carnica_constantNe_noSFS_outgroupLaboriosa.yaml --cluster-config /work/genphyse/cytogen/Thibault/SeqApiPop_demography/DILS3/Mellifera_Carnica_constantNe_noSFS_outgroupLaboriosa/cluster.json --cluster "sbatch --nodes={cluster.node} --ntasks={cluster.n} --cpus-per-task={cluster.cpusPerTask} --time={cluster.time}"

