#!/bin/bash

#SBATCH --partition=workq
#SBATCH --job-name=launch_GONE
#SBATCH --output=./launch_GONE.out
#SBATCH --error=./launch_GONE.err
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=12G

t0=$(date "+%s")


list="all_clusters.list"

while read c
do
	cd $c
	sed "s/XX/$c/g" ../run_GONE.sh > run_GONE.sh
	sbatch run_GONE.sh
	cd ../
done < ${list}


t1=$(date "+%s")

echo "elapsed wall time is $((t1-t0))"
