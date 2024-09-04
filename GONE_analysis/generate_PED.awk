#!/usr/bin/awk

# "pop" passed as argument

# begin block
BEGIN {
FS="\t";
OFS=" ";
fid=0;
gB["0_0"]="A A";
gB["0_2"]="A T";
gB["0_-1"]="0 0";
gB["2_0"]="T A";
gB["2_2"]="T T";
gB["2_-1"]="0 0";
gB["-1_0"]="0 0";
gB["-1_2"]="0 0";
gB["-1_-1"]="0 0";
}

# main block
FNR==1{fid++}

fid==1{ # .012.indv
hid[NR]=$1;
hnr[$1]=NR;
}

fid==2{ # .012 (= genotype file)
for (i=2; i<=NF; i++) g[hid[FNR],i]=$i;
m=NF;
}

fid==3{ # fake_queens.tsv > output the PED file
printf "%s %s 0 0 1 -9", pop, $1;
for (i=2; i<=m; i++) {
	gA=g[$2,i]"_"g[$3,i];
	printf " %s", gB[gA];
}
printf "\n";
}
