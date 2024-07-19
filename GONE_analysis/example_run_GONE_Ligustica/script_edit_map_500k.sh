#!/bin/bash
#SBATCH -p workq
file=$(echo "seqapipop870_jointgvcf_260123_allnuclearchr.filtered.Ligustica.filteredkinship.biallelic.500kSNPs.withheader")
# remove the .1 for the name of the chromosome
sed 's/\.1//g' $file".map" > $file".map2"
# keep the initial file
mv $file".map" $file".mapzzz"
# edit the id of the chromosome
sed 's/NC_001566/0/g' $file".map2" | sed 's/NC_037638/1/g' | sed 's/NC_037639/2/g' | sed 's/NC_037640/3/g' |sed 's/NC_037641/4/g' |sed 's/NC_037642/5/g' |sed 's/NC_037643/6/g' |sed 's/NC_037644/7/g' |sed 's/NC_037645/8/g' |sed 's/NC_037646/9/g' |sed 's/NC_037647/10/g' |sed 's/NC_037648/11/g' |sed 's/NC_037649/12/g' |sed 's/NC_037650/13/g' |sed 's/NC_037651/14/g' |sed 's/NC_037652/15/g' | sed 's/NC_037653/16/g' > $file".map"

# remove the cerana_jointgvcf_allchr_PASSonly200k.withheader.map2 
rm $file".map2"

# parse the format of the file
# first keep the information of the latest position per chr
MAXCHR1=$(grep "^1	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR2=$(grep "^2	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR3=$(grep "^3	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR4=$(grep "^4	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR5=$(grep "^5	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR6=$(grep "^6	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR7=$(grep "^7	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR8=$(grep "^8	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR9=$(grep "^9	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR10=$(grep "^10	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR11=$(grep "^11	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR12=$(grep "^12	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR13=$(grep "^13	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR14=$(grep "^14	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR15=$(grep "^15	" $file".map" | tail -1 | awk -F " " '{print $4}')
MAXCHR16=$(grep "^16	" $file".map" | tail -1 | awk -F " " '{print $4}')

echo "maxchrs $MAXCHR1 $MAXCHR2 $MAXCHR3 ..."

# then edit position of each marker
SNPID=0
while read line; do
	currentchr=$(echo $line | awk '{print $1}')
        if [ "$currentchr" == "1" ]; then
		POSFINALE=$(echo $line | awk '{print $4}')
	elif [ "$currentchr" == "2" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1" | bc)
	elif [ "$currentchr" == "3" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2" | bc)
	elif [ "$currentchr" == "4" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3" | bc)
	elif [ "$currentchr" == "5" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4" | bc)
	elif [ "$currentchr" == "6" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5" | bc)
	elif [ "$currentchr" == "7" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6" | bc)
	elif [ "$currentchr" == "8" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6+$MAXCHR7" | bc)
	elif [ "$currentchr" == "9" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6+$MAXCHR7+$MAXCHR8" | bc)
	elif [ "$currentchr" == "10" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6+$MAXCHR7+$MAXCHR8+$MAXCHR9" | bc)
	elif [ "$currentchr" == "11" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6+$MAXCHR7+$MAXCHR8+$MAXCHR9+$MAXCHR10" | bc)
	elif [ "$currentchr" == "12" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6+$MAXCHR7+$MAXCHR8+$MAXCHR9+$MAXCHR10+$MAXCHR11" | bc)
	elif [ "$currentchr" == "13" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6+$MAXCHR7+$MAXCHR8+$MAXCHR9+$MAXCHR10+$MAXCHR11+$MAXCHR12" | bc)
	elif [ "$currentchr" == "14" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6+$MAXCHR7+$MAXCHR8+$MAXCHR9+$MAXCHR10+$MAXCHR11+$MAXCHR12+$MAXCHR13" | bc)
	elif [ "$currentchr" == "15" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6+$MAXCHR7+$MAXCHR8+$MAXCHR9+$MAXCHR10+$MAXCHR11+$MAXCHR12+$MAXCHR13+$MAXCHR14" | bc)
	elif [ "$currentchr" == "16" ]; then
		POS=$(echo $line | awk '{print $4}')
		POSFINALE=$(echo "$POS+$MAXCHR1+$MAXCHR2+$MAXCHR3+$MAXCHR4+$MAXCHR5+$MAXCHR6+$MAXCHR7+$MAXCHR8+$MAXCHR9+$MAXCHR10+$MAXCHR11+$MAXCHR12+$MAXCHR13+$MAXCHR14+$MAXCHR15" | bc)
	else
		POSFINALE=$(echo "MERDEEEEEEEEEEEEEEEE")
	fi
	SNPID=$(echo "$SNPID+1" | bc)
	#Mb=$(echo "scale=6; ($POS/1000000)" | bc)
	echo $line | awk -v var1="$SNPID" -v var2="$POSFINALE" '{print $1" SNP"var1" 0 "var2}' >> $file".map2"
done < $file".map"
mv $file".map2" $file".map"

# parse the ped file
INDID=0
while read line; do
	INDID=$(echo "$INDID+1" | bc)
	trueindID=$(echo $line | awk '{print $1"_"$2}')
	echo "$INDID $trueindID" >> $file.corresptableIND.txt
	echo $line | awk -v var1="$INDID" '{print "1 IND"var1" 0 0 1 -9"}' >> $file".ped.tmp1"
done < $file".ped"

awk '{$1="";$2="";$3="";$4="";$5="";$6=""; print $0}' $file.ped > $file".ped.tmp2"
grep -v "^$" $file".ped.tmp2" > $file".ped.tmp3"
paste $file".ped.tmp1" $file".ped.tmp3" | sed 's/\t/ /g' | sed 's/ \+/ /g' > $file".ped.tmp4"
mv  $file".ped.tmp4"  $file".ped"
