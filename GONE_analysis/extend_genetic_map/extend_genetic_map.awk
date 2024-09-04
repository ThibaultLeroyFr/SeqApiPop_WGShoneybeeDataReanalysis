#!/usr/bin/awk

# A script to extend the genetic map to all desired genomic coordinates
# INPUTS:
#	#1: a genetic map, with one header row and chrom, bp-position and recomb rate in columns 1, 2 and 3
#	#2: a list of genomic coordinates for which we want to know the genetic positions
#

# begin block
BEGIN {
FS="\t";
OFS="\t";
fid=0;
chr=0;
flag_term=0;
padding=200000;
}

# main block
FNR==1{fid++}
fid==1 && FNR>1{ # original genetic map - one header row
if ($1!=chr) {
	# check if we first have to terminate a chromosome
	if (flag_term==1) {
		# then use r at step i-2 to predict the genetic position over "padding" distance
		for (i=bp+1; i<=bp+padding; i++) tcm[chr,i]=tcm[chr,i-1]+r1*1E-6
	}
	# then start counting for a new chromosome
	bp=$2
	r=$3
	r1=r
	chr=$1
	# first start counting from position 0 to position BP
	tcm[chr,0]=0
	for (i=1; i<=bp; i++) tcm[chr,i]=tcm[chr,i-1]+r*1E-6
	flag_term=1
} else {
	# then, as we already are in the chromosome (2nd recorded position on the genetic map),
	# count from BP+1 to current position
	for (i=bp+1; i<=$2; i++) tcm[chr,i]=tcm[chr,i-1]+r*1E-6
	# update bp and r
	bp=$2
	r1=r
	r=$3
}
}

fid==2 && flag_term==1 {
# first, terminate the last chromosome recorded
for (i=bp+1; i<=bp+padding; i++) tcm[chr,i]=tcm[chr,i-1]+r1*1E-6
flag_term==0
}

fid==2 { # list of requested genomic coordinates
print $1, $2, tcm[$1,$2]
}
