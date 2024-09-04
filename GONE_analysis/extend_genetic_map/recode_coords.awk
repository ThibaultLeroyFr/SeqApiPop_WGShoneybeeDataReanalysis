#!/usr/bin/awk

# begin block
BEGIN {
FS="\t";
OFS="\t";
fid=0;
}

# main block
FNR==1{fid++}
fid==1{chr[$1]=$2}
fid==2 && chr[$1]!=17{print chr[$1],$2} 
