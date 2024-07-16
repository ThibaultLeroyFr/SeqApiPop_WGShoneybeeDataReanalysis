#!/bin/bash
#SBATCH -p workq
# TL - 200723
## This scripts generates the input files for DILS

## root to all data
rootdir=$(echo "/work/genphyse/cytogen/Thibault/SeqApiPop_completevcf")

## Define the focal species
Species1=$(echo "Mellifera") #e.g. Mellifera
Species2=$(echo "Ligustica") #e.g. Ligustica
Outgroup=$(echo "Laboriosa") #e.g. Cerana
nbloci=$(echo "200" | bc)
constant_or_variable_Ne_through_time=$(echo "constant") # constant: Ne constant after split or variable: to consider population growth / bottleneck
use_the_SFS=$(echo "yes") # yes/no

species1=$(echo "$Species1" | tr '[:upper:]' '[:lower:]')
species2=$(echo "$Species2" | tr '[:upper:]' '[:lower:]')
outgroup=$(echo "$Outgroup" | tr '[:upper:]' '[:lower:]')

## list sequences in bed.tmp files
# Sp1
rm $rootdir/"$Species1"_list_genomic_regions.txt
for i in $rootdir/$Species1/*.bed.tmp; do
	cd $i
	ls *.fasta | grep -v "$species1""2" | grep -v "clean" > list_tmp
#	head list_tmp
	while read line; do
		echo "$i/$line" >> $rootdir/"$Species1"_list_genomic_regions.txt
	done < list_tmp
	rm list_tmp
	cd ..
done

# Sp2
rm $rootdir/"$Species2"_list_genomic_regions.txt
for i in $rootdir/$Species2/*.bed.tmp; do
        cd $i
        ls *.fasta | grep -v "$species1""2" | grep -v "clean" > list_tmp
#        head list_tmp
	while read line; do
                echo "$i/$line" >> $rootdir/"$Species2"_list_genomic_regions.txt
        done < list_tmp
        rm list_tmp
        cd ..
done

# Outgroup
rm $rootdir/"$Outgroup"_list_genomic_regions.txt
for i in $rootdir/$Outgroup/*.bed.tmp; do
        cd $i
        ls *.fasta | grep -v "$outgroup""2" | grep -v "clean" > list_tmp
	while read line; do
                echo "$i/$line" >> $rootdir/"$Outgroup"_list_genomic_regions.txt
        done < list_tmp
        rm list_tmp
        cd ..
done

# randomly select n loci of the genome
shuf -n "$nbloci" $rootdir/"$Species1"_list_genomic_regions.txt > $rootdir/"$Species1"_list_genomic_regions.subset"$nbloci".txt
rm $rootdir/Loci_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt

#species1=$(echo "$Species1" | tr '[:upper:]' '[:lower:]')
#species2=$(echo "$Species2" | tr '[:upper:]' '[:lower:]')
#outgroup=$(echo "$Outgroup" | tr '[:upper:]' '[:lower:]')
while read line; do 
	firstcolumn=$(echo $line) # >> $rootdir/Sequences_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt
	seqsp2=$(echo "$line" | sed "s/$Species1/$Species2/g" | sed "s/$species1/$species2/g")
	seqoutgp=$(echo "$line" | sed "s/$Species1/$Outgroup/g" | sed "s/$species1/$outgroup/g")
	#echo $firstcolumn
	#echo $seqsp2
	secondcolumn=$(echo $seqsp2) #
	thirdcolumn=$(echo "$seqoutgp" | sed "s/\.bed\.tmp/\.1\.filtered\.vcf\.bed\.tmp/g" | sed "s/\.1\.filtered\.vcf\.1\.filtered\.vcf/\.1\.filtered\.vcf/g" | sed "s/recontrseq_"$outgroup"_NC_037638\.NC_/recontrseq_"$outgroup"_NC_037638\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037639\.NC_/recontrseq_"$outgroup"_NC_037639\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037640\.NC_/recontrseq_"$outgroup"_NC_037640\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037641\.NC_/recontrseq_"$outgroup"_NC_037641\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037642\.NC_/recontrseq_"$outgroup"_NC_037642\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037643\.NC_/recontrseq_"$outgroup"_NC_037643\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037644\.NC_/recontrseq_"$outgroup"_NC_037644\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037645\.NC_/recontrseq_"$outgroup"_NC_037645\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037646\.NC_/recontrseq_cerana_NC_037646\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037647\.NC_/recontrseq_"$outgroup"_NC_037647\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037648\.NC_/recontrseq_"$outgroup"_NC_037648\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037649\.NC_/recontrseq_"$outgroup"_NC_037649\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037650\.NC_/recontrseq_"$outgroup"_NC_037650\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037651\.NC_/recontrseq_"$outgroup"_NC_037651\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037652\.NC_/recontrseq_"$outgroup"_NC_037652\.1\.filtered\.vcf\.NC_/g" | sed "s/recontrseq_"$outgroup"_NC_037653\.NC_/recontrseq_"$outgroup"_NC_037653\.1\.filtered\.vcf\.NC_/g")
	echo "$firstcolumn	$secondcolumn	$thirdcolumn" >> $rootdir/Loci_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt
done < $rootdir/"$Species1"_list_genomic_regions.subset"$nbloci".txt

# Extract regions and generate the input files for sequences in DILS
rm $rootdir/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt # rm if exists
rm "$Species1"_list_individuals.tmp "$Species2"_list_individuals.tmp "$Outgroup"_list_individuals.tmp # rm if exists
while read line; do
	# Collect and format sequence data for species 1 for the current locus
	first_file=$(echo $line | awk '{print $1}')
	less $first_file > tmpsp1
	#echo "head tmpsp1 before"
	#head -1 tmpsp1
	#list to individuals to exclude in the dataset, see "SeqApiPop_excluded_individuals", if any (05/07/24):
	while read lineIDtoexclude; do
		IDtmpsp1=$(echo $lineIDtoexclude | awk '{print $2}')
		sed "/$IDtmpsp1./,+1 d" tmpsp1 > tmpsp1BIS
		mv tmpsp1BIS tmpsp1
	done < $rootdir/list_individuals_to_exclude_seqapipopdata_seeSeqApiPop_excluded_individuals.txt
	#echo "head tmpsp1 after"
	#head -1 tmpsp1
	locusID=$(echo "$first_file" | sed "s;$rootdir;;g" | sed 's/\.bed\.tmp/\t/g' | awk '{print $2}' | sed 's/recontrseq_//g' | sed "s/$Species1//g" | sed "s/$species1//g" | sed 's/_\+//g' | sed 's;/\+;;g' | sed 's/\.fasta//g' | sed 's/1\.filtered//g' | sed 's/\.vcf//g' | sed 's/\.\+/\./g' | awk -F "." '{print $2"_"$3":"$4"-"$5}')
	echo $first_file
	echo $locusID
	while read line2; do
		if [ "${line2:0:1}" = ">" ]; then
			individualID=$(echo "$line2" | sed 's/:/\t/g' | awk '{print $1}' | sed 's/>//g')
			echo "$individualID" >> "$Species1"_list_individuals.tmp
			echo ">$locusID|$Species1|$individualID|Allele1" >> $rootdir/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt #All are allele since the sequences come from haploid drones
		else
			echo "$line2" >> $rootdir/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt
		fi
	done < tmpsp1
	#Collect and format sequence data for outgroup for the current locus
        second_file=$(echo "$line" | awk '{print $2}')
        #list to individuals to exclude in the dataset, see "SeqApiPop_excluded_individuals", if any (05/07/24):
	less $second_file > tmpsp2
	#echo "head tmpsp2 before"
	#head -1 tmpsp2
	while read lineIDtoexclude; do
                ID2tmpsp2=$(echo $lineIDtoexclude | awk '{print $2}')
                sed "/$ID2tmpsp2./,+1 d" tmpsp2 > tmpsp2BIS
                mv tmpsp2BIS tmpsp2
        done < $rootdir/list_individuals_to_exclude_seqapipopdata_seeSeqApiPop_excluded_individuals.txt
        #echo "head tmpsp2 after"
	#head -1 tmpsp2
	while read line2; do
                if [ "${line2:0:1}" = ">" ]; then
                        individualID2=$(echo "$line2" | sed 's/:/\t/g' | awk '{print $1}' | sed 's/>//g')
                        echo "$individualID2" >> "$Species2"_list_individuals.tmp
                        echo ">$locusID|$Species2|$individualID2|Allele1" >> $rootdir/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt #All are allele since the sequences come from haploid drones
                else
                        echo "$line2" >> $rootdir/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt
                fi
	done < tmpsp2
	# Collect and format sequence data for species 2 for the current locus
	third_file=$(echo "$line" | awk '{print $3}')
	less $third_file > tmpoutgr
        while read line2; do
                if [ "${line2:0:1}" = ">" ]; then
           		individualIDOutgroup=$(echo "$line2" | sed 's/:/\t/g' | awk '{print $1}' | sed 's/>//g')
			individualallele=$(echo "$individualIDOutgroup" | awk '{print substr($0,length,1)}' | sed 's/ \+//g' | bc)
			#echo "$individualIDOutgroup	${individualallele:0:1}"
			if [ "$individualallele" -eq "1" ]; then
				individualIDOutgroup2=$(echo "$individualIDOutgroup" | sed 's/\.1//g')
				echo "$individualIDOutgroup2" >> "$Outgroup"_list_individuals.tmp
                        	echo ">$locusID|$Outgroup|$individualIDOutgroup2|Allele1" >> $rootdir/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt #All are allele since the sequences come from haploid drones
			elif [ "$individualallele" -eq "2" ]; then
				individualIDOutgroup2=$(echo "$individualIDOutgroup" | sed 's/\.2//g')
				echo "$individualIDOutgroup2" >> "$Outgroup"_list_individuals.tmp
				echo ">$locusID|$Outgroup|$individualIDOutgroup2|Allele2" >> $rootdir/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt #All are allele since the sequences come from haploid drones
			else
				echo "outgroup: not expected"
			fi
                else
                        echo "$line2" >> $rootdir/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt

                fi
        done < tmpoutgr

	rm tmpsp1 tmpsp2 tmpoutgr
done < $rootdir/Loci_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt
sort "$Species1"_list_individuals.tmp | uniq > "$Species1"_list_individuals.txt
sort "$Species2"_list_individuals.tmp | uniq > "$Species2"_list_individuals.txt
sort "$Outgroup"_list_individuals.tmp | uniq > "$Outgroup"_list_individuals.txt

# Generate the input files including the yaml file
new_rootdir=$(echo "/work/genphyse/cytogen/Thibault/SeqApiPop_demography/DILS3")
cd $new_rootdir
mkdir "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup"
cd "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup"
cp $rootdir/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt .
cp $rootdir/Loci_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt .
cp $rootdir/"$Species1"_list_individuals.txt
cp $rootdir/"$Species2"_list_individuals.txt
cp $rootdir/"$Outgroup"_list_individuals.txt

# generate the yaml file
echo "mail_address: thibault.leroy@inrae.fr" > "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "infile: $new_rootdir/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup"/Sequences_"$Species1"_"$Species2"_out"$Outgroup"_randomlyselected_"$nbloci"_genomic_regions.txt" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "region: coding" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "nspecies: 2" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "nameA: $Species1" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "nameB: $Species2" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "nameOutgroup: $Outgroup" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "lightMode: TRUE" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
if [ "$use_the_SFS" == "no" ]; then
	echo "No SFS used"
	echo "useSFS: 0" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
elif [ "$use_the_SFS" == "yes" ]; then
	echo "SFS used"
	echo "useSFS: 1" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
else
	echo "Please revise the script in order to indicate if the SFS should be used or not in the summary statistics!!!"
fi
echo "config_yaml: $new_rootdir/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup"/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "timeStamp: resDILS_""$Species1""_""$Species2""_""$constant_or_variable_Ne_through_time""Ne_""$use_the_SFS""SFS_outgroup""$Outgroup" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "population_growth: $constant_or_variable_Ne_through_time" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
if [ "$constant_or_variable_Ne_through_time" == "constant" ]; then
	echo "Mode used: constant Ne through time"
elif [ "$constant_or_variable_Ne_through_time" == "variable" ]; then
	echo "Tchanges min: 100" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
	echo "Tchanges max: 1000000" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
	echo "Mode used: variable Ne through time [by default priors: 100-1000000]"
fi
echo "modeBarrier: bimodal" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "max_N_tolerated: 0.5" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "Lmin: 1000" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "nMin: 12" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "mu: 0.0000000034" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml # the mutation rate by default is 0.00000002763, here adjusted for honeybee based on https://pubmed.ncbi.nlm.nih.gov/28007973/ & https://www.nature.com/articles/nature14649
echo "rho_over_theta: 0.5" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "N_min: 0" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "N_max: 500000" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "Tsplit_min: 0">> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "Tsplit_max: 2000000" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "M_min: 1" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml
echo "M_max: 40" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml

# cp the cluster_test.json in the directory
cp $rootdir/cluster_test.json .
mv cluster_test.json cluster.json

# cp script_lanceur_DILS.sh in the directory
cp $rootdir/script_lanceur_DILS.sh .
my_new_yaml_file=$(echo "$new_rootdir"/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup"/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup".yaml)
my_new_json_file=$(echo ""$new_rootdir"/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_outgroup"$Outgroup"/cluster.json")
sed "s;/work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Demo_DILS_tests/bidon.yaml;$my_new_yaml_file;g" script_lanceur_DILS.sh | sed "s;/work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Demo_DILS_tests/cluster_test.json;$my_new_json_file;g" > script_lanceur_DILS.tmp
mv script_lanceur_DILS.tmp script_lanceur_DILS.sh
