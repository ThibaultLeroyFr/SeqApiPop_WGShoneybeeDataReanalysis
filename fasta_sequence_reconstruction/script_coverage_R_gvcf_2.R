# TL - 060218

# Ce script permet de verifier la qualité des sites sur les variants appelés chez Colivacea

library("ggplot2")
library("grid")
library("gridExtra")
setwd("/work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/")
covqual11pc=read.table("subsampling_3pm_position_coverage.withheader.vcf.qualsummary", header=TRUE)
covqualind=read.table("subsampling_3pm_position_coverage.withheader.vcf.qualsummary.ind.clean", header=FALSE) # contains only numeric values

###### COVERAGE PER IND
png(file="subsampling_3pm_position_coverage.withheader_distributionscoverage.png",width=1000,height=1000)
ggplot(covqualind, aes(V4, colour=V1)) + 
    geom_density() + xlab("Coverage (DP) per individual")+
      xlim(0,200)+
      theme_bw()+
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
      theme(legend.position = "none", axis.line = element_line(colour = 'black', size = 1.25), axis.ticks = element_line(colour = 'black', size = 1.25), 
        axis.text.x = element_text(colour="black",size=12,angle=0,hjust=1,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="black",size=12,angle=0,hjust=.5,vjust=.5,face="plain"),  
        axis.title.x = element_text(colour="black",size=14,angle=0,hjust=.5,vjust=.2,face="italic"),
        axis.title.y = element_text(colour="black",size=14,angle=90,hjust=.5,vjust=.5,face="italic"))
    #scale_fill_manual(values = c('#999999','#E69F00'))

dev.off()

png(file="subsampling_3pm_position_coverage.withheader_distributionscoverage_DP70.png",width=1000,height=1000)
ggplot(covqualind, aes(V4, colour=V1)) +
    geom_density() + xlab("Coverage (DP) per individual")+
      ylim(0,0.5)+
      xlim(0,70)+
      theme_bw()+
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
      theme(legend.position = "none", axis.line = element_line(colour = 'black', size = 1.25), axis.ticks = element_line(colour = 'black', size = 1.25),
        axis.text.x = element_text(colour="black",size=12,angle=0,hjust=1,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="black",size=12,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.title.x = element_text(colour="black",size=14,angle=0,hjust=.5,vjust=.2,face="italic"),
        axis.title.y = element_text(colour="black",size=14,angle=90,hjust=.5,vjust=.5,face="italic"))
    #scale_fill_manual(values = c('#999999','#E69F00'))

dev.off()


png(file="subsampling_3pm_position_coverage.withheader_distributionscoverage_DP70_smoothspan1.png",width=1000,height=1000)
ggplot(covqualind, aes(V4, colour=V1)) +
    geom_density(adjust=1) + xlab("Coverage (DP) per individual")+
      ylim(0,0.5)+
      xlim(0,70)+
      theme_bw()+
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
      theme(legend.position = "none", axis.line = element_line(colour = 'black', size = 1.25), axis.ticks = element_line(colour = 'black', size = 1.25),
        axis.text.x = element_text(colour="black",size=12,angle=0,hjust=1,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="black",size=12,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.title.x = element_text(colour="black",size=14,angle=0,hjust=.5,vjust=.2,face="italic"),
        axis.title.y = element_text(colour="black",size=14,angle=90,hjust=.5,vjust=.5,face="italic"))
    #scale_fill_manual(values = c('#999999','#E69F00'))

dev.off()


png(file="subsampling_3pm_position_coverage.withheader_distributionscoverage_DP70_smooth2.png",width=1000,height=1000)
ggplot(covqualind, aes(V4, colour=V1)) +
    geom_density(adjust=2) + xlab("Coverage (DP) per individual")+
      ylim(0,0.5)+
      xlim(0,70)+
      theme_bw()+
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
      theme(legend.position = "none", axis.line = element_line(colour = 'black', size = 1.25), axis.ticks = element_line(colour = 'black', size = 1.25),
        axis.text.x = element_text(colour="black",size=12,angle=0,hjust=1,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="black",size=12,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.title.x = element_text(colour="black",size=14,angle=0,hjust=.5,vjust=.2,face="italic"),
        axis.title.y = element_text(colour="black",size=14,angle=90,hjust=.5,vjust=.5,face="italic"))
    #scale_fill_manual(values = c('#999999','#E69F00'))

dev.off()




png(file="subsampling_3pm_position_coverage.withheader_distributionscoverage_DP70_smooth5.png",width=1000,height=1000)
ggplot(covqualind, aes(V4, colour=V1)) +
    geom_density(adjust=5) + xlab("Coverage (DP) per individual")+
      ylim(0,0.5)+
      xlim(0,70)+
      theme_bw()+
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
      theme(legend.position = "none", axis.line = element_line(colour = 'black', size = 1.25), axis.ticks = element_line(colour = 'black', size = 1.25),
        axis.text.x = element_text(colour="black",size=12,angle=0,hjust=1,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="black",size=12,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.title.x = element_text(colour="black",size=14,angle=0,hjust=.5,vjust=.2,face="italic"),
        axis.title.y = element_text(colour="black",size=14,angle=90,hjust=.5,vjust=.5,face="italic"))
    #scale_fill_manual(values = c('#999999','#E69F00'))

dev.off()

png(file="subsampling_3pm_position_coverage.withheader_distributionscoverage_DP70_smoothspan0p0005.png",width=1000,height=1000)
ggplot(covqualind, aes(V4, colour=V1)) +
    geom_density(adjust=0.0005) + xlab("Coverage (DP) per individual")+
      ylim(0,0.5)+
      xlim(0,70)+
      theme_bw()+
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
      theme(legend.position = "none", axis.line = element_line(colour = 'black', size = 1.25), axis.ticks = element_line(colour = 'black', size = 1.25),
        axis.text.x = element_text(colour="black",size=12,angle=0,hjust=1,vjust=.5,face="plain"),
        axis.text.y = element_text(colour="black",size=12,angle=0,hjust=.5,vjust=.5,face="plain"),
        axis.title.x = element_text(colour="black",size=14,angle=0,hjust=.5,vjust=.2,face="italic"),
        axis.title.y = element_text(colour="black",size=14,angle=90,hjust=.5,vjust=.5,face="italic"))
    #scale_fill_manual(values = c('#999999','#E69F00'))

dev.off()



#summary(lm(formula=covqual$QUAL ~ covqual$QD))
#summary(lm(formula=covqual$QD ~ I(covqual$QUAL/covqual$DP)))


quantiles_99 <- function(x) {
  r <- quantile(x, probs=c(0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99))
  names(r) <- c("0.01", "0.05", "0.1","0.25", "median", "0.75", "0.9","0.95","0.99")
  r
}

zind <- aggregate(V4 ~ V1, covqualind, function(x) c(quant = round(quantiles_99(x),0)))

zind <- as.data.frame(zind)
write.table(zind, file = "summary_statistics_coverage_ind.tmp", sep= "\t",quote=FALSE,row.names=FALSE,col.names=FALSE)

zfinal <- read.table(file = "summary_statistics_coverage_ind.tmp",sep="\t")
#colnames(zfinal) <- c("ind","quanti1pc","quanti5pc","quanti10pc","quartile25","median","quartile75pc","quantile90","quantile95","quantile99")
#write.table(zfinal, file = "summary_statistics_coverage_ind.txt", sep= "\t",quote=FALSE,row.names=FALSE,col.names=TRUE)

