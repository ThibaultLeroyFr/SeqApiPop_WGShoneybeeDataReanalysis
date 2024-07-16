# SeqApiPop_WGShoneybeeDataReanalysis
Reanalysis of the WGS bee (SeqApiPop data) to estimate nucleotide diversity, load and infer demography

# 1/ Generate a complete VCF (./Pipeline2CompleteVCF)
We used the g.vcf files generated by Wragg and collaborators (2022), for details regarding these previous steps (mapping, g.vcf, etc), see https://github.com/avignal5/SeqApiPop <br>
To speed up the combination, all scripts were run independently for each chromosome (see script_lanceur_combinevcf_chrperchr.sh, this script launches script_combinevcf_Dorsata.sh for each of the chromosomes, thanks to the information provided by on the file HAv3_1_Chromosomes.list). Note that the example provided is for an outgroup (Dorsata), but the same strategy was used for the focal species (SeqApiPop data, see also script_combinevcf_870SeqApiPop.sh) and the two other outgroups. <br><br>
Then, the jointgenotyping was perfomed using GenotypeGVCFs (GATK v.4.2.2.0) using the script script_lanceur_genotypegvcf_chrperchr.sh (see also script_genotypeGVCFsHAV3_1.sh). Note that we use here the "--all-sites true" mode, in order to generate a complete VCF (i.e. a VCF with both variant and non-variant positions). <br>

# 2/ Reconstruct fasta sequences from a complete vcf (./fasta_sequence_reconstruction)
Important note: To generate perfectly aligned fasta sequences, we considered the approach developped by Leroy et al. 2021 (Current Biology), adjusting for the level of ploidy (haploid for the A. mellifera samples, diploid for the other species). This step makes several assumptions. First, this approach ignores INDELs and SVs in order to keep the sequences perfectly aligned. So, the diversity that we report in our analysis corresponds to the diversity at SNPs. Second, the reconstructed sequences should not be considered as phased. Of course, given that the vast majority of our dataset corresponds to A. mellifera drones, these sequences are by definition phased. But it should be kept in mind that the sequences of the outgroup species are based on several workes and therefore, the reconstructed sequences should be considered as unphased. In our analysis, the analysis we performed are based on summary statistics that do not take linkage disequilibrium into account (e.g. DILS, nucleotide diversity, etc). So to be completely clear, the reconstructed sequences from diploid individuals SHOULD NOT BE USED as inputs for methods that require to know the haplotype phasing.<br><br>
At each position, the script will extend the sequence, by either adding a reference allele (non-polymorphic sites or SNPs with reference alleles), an alternate allele (SNPs with alternate alleles) or a missing information (N). To generate unbiased estimates of nucleotide diversity, it is indeed crucial to use information from invariant sites from the complete VCF, allowing to discriminate positions that are trully invariant from those that are just not covered (missing genotypes, e.g. for more information regarding this point, see the Pixy paper by Korunes & Samuk 2021 in Mol Ecol Res).<br>

To consider whether the position is sufficiently covered to be confident with the nucleotide to be added in the sequence, we first picked up 0.3% of all positions of the honeybee genome (~66k positions) to compute the quantiles of the coverage for each individual (see script_lanceur_quantilescoverage.sh). All positions that were not within the core of the distribution (excluding the bottom 5% and the top 5%) were hardmasked. A minimum coverage of 3 were required (it should be kept in mind that our dataset is almost exclusively based on haploid individuals). Then, we reconstructed the sequences using the python script "VCF2Fasta_haploid_withquantiles.py" (or its diploid equivalent "VCF2Fasta_diploid_withquantiles.py").<br>

# 3/ Generate 100kb blocks of sequences spanning the whole genome and compute summary statistics(./Sequence_Blocks_Nucleotide_Diversity)
From the chromosome-level sequences that we reconstructed, we then used bedtools (v.2-27.1) to generate block of sequences spanning the whole genome using bedtools getfasta, which were then used to subsequently generate the summary statistics of nucleotide diversity, Tajima's D etc using the software "seq_stat", see Leroy et al. 2021 Peer Community Journal. All these steps are listed in the script "script_compute_div_slidingwindows.sh", a script which is launched thanks to the "script_lanceur_div_slidingwindows.sh". For CDS regions, the approach is similar strategy (see script_sumstats_diversity_CDS.sh), but requires different softwares: the python script cutSeqGff.py instead of bedtools getfasta, a small program removeLastStopCodon and a dedicated software for the computation of the summary statistics "seq_stat_coding"), see also Leroy et al. 2021 Current Biology. 

# 4/ Perform demographic reconstruction with DILS (./DILS_analysis)
The demographic approach we used is based on DILS, that can take into account the impacts of heterogenous landscapes of Ne (background selection, sweeps) and migration rates (reproductive barriers). 
