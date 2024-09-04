#!/usr/bin/awk

# begin block
BEGIN {
OFS=" ";
fid=0;
}

# main block
FNR==1{fid++}
fid==1{ # chromosome_labels.tsv
chr[$1]=$2;
}

fid==2{ # .012.pos
print chr[$1], "variant_"NR, 0, $2;
}
