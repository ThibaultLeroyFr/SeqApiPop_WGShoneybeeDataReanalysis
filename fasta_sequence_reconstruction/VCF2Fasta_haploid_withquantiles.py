#! /usr/bin/env python
from __future__ import print_function
import sys
import numpy as np
import optparse

# USAGE: python2 VCF2Fasta_haploid_withquantiles.py -f seqapipop870_jointgvcf_250123_NC_001566.1.vcf -m 3 -M 1000 -c summary_statistics_coverage_ind.txt
# HERE this script no longer use the quality score . before -q 20 was used, but it was before requalibration, so it means that the values should be changed accordingly to the pipeline used. Now: GATK Pass tags are considered sufficient

# Function to find information in position in FORMAT field 
def findPosInFORMATStr(infoStr, str2ID):
	RETURNPOS = 0
	info = infoStr.split(":")
	for i in info:
		if i == str2ID:
			break
		RETURNPOS = RETURNPOS+1
	return(RETURNPOS)
	

parser = optparse.OptionParser()

parser.add_option('-m', '--min_cov',action="store", dest="minCoverageThreshold", type="int")
parser.add_option('-M', '--max_cov',action="store", dest="maxCoverageThreshold", type="int")
parser.add_option('-f', '--vcf_file',action="store", dest="namefp", type="string")
parser.add_option('-c', '--indcov_file',action="store", dest="namecov", type="string")

(options, args) = parser.parse_args()

minCoverageThreshold = int(options.minCoverageThreshold)
maxCoverageThreshold = int(options.maxCoverageThreshold)

namefile = str(options.namefp)
covfile = str(options.namecov)

fp = open(namefile)
indcov = open(covfile)

# create a dictionnary containing the coverage
mincov = {}
maxcov = {}
for line in indcov:
	line = line.rstrip()
	line = line.split('\t')
	individual = line[0]
	if individual != "ind": # exclude the header
		print(line)
		quanti5pc = int(line[2])
		quanti95pc = int(line[8])
		if quanti5pc >= minCoverageThreshold:
			mincov[individual] = quanti5pc
		else:
			mincov[individual] = minCoverageThreshold
		if quanti95pc <= maxCoverageThreshold:
			maxcov[individual] = quanti95pc
		else:
			mincov[individual] = minCoverageThreshold

print(mincov)
print(maxcov)

############## MAIN ############
nameSeq = []
nameInd = []
sequenceDNA = ""


seqName = ""
countSNP = 0
countSite = 0
NumberOfSeq = ""
sites = []

pos = 0
oldpos = 0 

for line in fp:
	line = line.rstrip()
	
	# count number of individuals and store names in array
	if line[0:6] == "#CHROM" and len(nameInd) == 0:
		arrline = line.split()
		
		for i in arrline[9:]:
			indseq1 = i
			nameSeq.append(indseq1)
			nameInd.append(i)
		NumberOfSeq = len(nameSeq)
                print("There is "+str(NumberOfSeq)+" individuals")			
	if line[0] != "#":
		arrline = line.split()
		chromosome = arrline[0]
		pos = int(arrline[1])
		REF = str(arrline[3])
		ALT = str(arrline[4])
		site = []

		if (pos % 50000) == 0:
			print("Positions "+str(pos)+" of "+chromosome)

		
		if chromosome != seqName and seqName != "": # print seq when new chromosome found
			print("Print  " + seqName)
			fasta = open(seqName+".fst", "w")
			sites = np.ravel(sites)
			sequenceDNA = np.reshape(sites, newshape=(len(sites)/NumberOfSeq, NumberOfSeq))
			for i, seqName in enumerate(nameSeq):
					print(">"+seqName, file=fasta)
					print(''.join(map(str, sequenceDNA[1:,i])), file=fasta)
					
			seqName = chromosome
			sites = []
			
		if seqName == "":
			seqName = chromosome
		
		
		### MODIF PROPOSER PAR EMERIC START###############################
		## This was at the end before
		if oldpos+1 < pos: # if current site is not exactly one position after oldpos site put "N"
			numberSite = int(pos-oldpos)
			for j in range(1,numberSite):
				site = []
				for i in range(0, len(nameSeq)):
					site.append("N")
				#sequenceDNA = np.vstack((sequenceDNA, site))
                                sites.append(site)
                        site = []
		### MODIF PROPOSER PAR EMERIC STOP###############################
		
		
		if len(REF) > 1 or len(ALT) > 1 or ALT == "*" :  # exlcude indels
			for i in range(0, len(nameSeq)):
				site.append("N")
				
		else:

			covPos = findPosInFORMATStr(arrline[8], "DP") # find coverage position in INFO field

			if ALT == ".": # if no ALT allele ( = monorphic site)	
				if arrline[6] == "LowQual" : # exclude LowQual for HaplotypeCaller and GenotypeGVCFs SNP
					for i in range(0, len(nameSeq)):
						site.append("N")
				else:
					for i in range(0, len(nameInd)):
						ind = arrline[i+9]
						arrInd = ind.split(":")
						#print(str(len(arrInd)) + " " + str(covPos))
						if len(arrInd) < int(covPos+1): # if individual doesn't have DP field
							#print("here")
							site.append("N")
						else:
							cov = arrInd[covPos]
							if cov == ".":
								site.append("N")
								continue
							cov = int(cov)
							#print(cov,",",mincov[nameInd[i]],",",maxcov[nameInd[i]])
							if cov >= mincov[nameInd[i]] and cov <= maxcov[nameInd[i]]:
								site.append(REF)
							else:
								site.append("N")
						
			else:
				if ("0/1" or "0|1") not in line and str(arrline[6]) == "PASS": # keep only PASS tags mask hz sites in at least 1 individual (quite conservative but probably relevant)
					#print("Kept non-hz position "+arrline[0]+" "+arrline[1])
					#print("PASS  " + line)qqs
					gtPos = findPosInFORMATStr(arrline[8], "GT") #FORMAT=<ID=AD,Number=R,Type=Integer,Description="Allelic depths for the ref and alt alleles in the order listed">
					adPos = findPosInFORMATStr(arrline[8], "AD") #FORMAT=<ID=AD,Number=R,Type=Integer,Description="Allelic depths for the ref and alt alleles in the order listed">
					covPos = findPosInFORMATStr(arrline[8], "DP") #FORMAT=<ID=FT,Number=.,Type=String,Description="Genotype-level filter">
					for i in range(0, len(nameInd)):
						ind = arrline[i+9]
						arrInd = ind.split(":")
						if len(arrInd) < int(covPos+1): # if individual doesn't have DP field
							#print("here")
							#print("no cov")
							site.append("N")
						else:
							cov = arrInd[covPos]
							if cov == "." or cov == "0":
								#print("cov == .")
								site.append("N")
								continue
							cov = int(cov)
							#print(cov,",",mincov[nameInd[i]],",",maxcov[nameInd[i]])
							if cov >= mincov[nameInd[i]] and cov <= maxcov[nameInd[i]]:
								if arrInd[gtPos] == "0/0" or arrInd[gtPos] == "0|0":
									#print(pos,"-",nameInd[i],"- kept adding a REF=",REF)
									site.append(REF)
									continue
								elif arrInd[gtPos] == "1/1" or arrInd[gtPos] == "1|1":
									#print(pos,"-",nameInd[i],"- kept adding a ALT=",ALT)
									site.append(ALT)
									continue
								else: #normally impossible because hz sites are excluded
									site.append("N")
									#print(pos,"-",nameInd[i],"- UNEXPECTED")
									continue
							else:
								#print(pos,"-",nameInd[i],"- cov not in range")
								site.append("N")
								continue
				else:
					#print(pos,"-contains a 0/1 or not a keep")
					#print("masked hz SNP position "+arrline[0]+" "+arrline[1])
					for i in range(0, len(nameSeq)):
						site.append("N")
						continue
						
		


                sites.append(site)
                
                ## Test if the site added are of correct length
                #sit = np.ravel(sites)
                #if not (float(len(sit))/float(NumberOfSeq)).is_integer()  :
                #        print(chromosome)
                #        print("Site "+str(len(site)))
                #        print("Sites "+str(len(sit)))
                #        print(str(pos))
                #        sys.exit("NOOOO :-)")

                
		oldpos = pos
		
		

print("Print  " + seqName)
fasta = open(seqName+".fst", "w")
sites = np.ravel(sites)
sequenceDNA = np.reshape(sites, newshape=(len(sites)/NumberOfSeq, NumberOfSeq))
for i, seqName in enumerate(nameSeq):
		print(">"+seqName, file=fasta)
		print(''.join(map(str, sequenceDNA[1:,i])), file=fasta)


#print "Number of SNP "+str(count)

fp.close()
