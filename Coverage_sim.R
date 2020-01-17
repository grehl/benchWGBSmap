



library(grid)

library(ggplot2)
#7 mapper
#4 mismatches
#4 error rates

#/scratch/user/user/benchmarkWGBS/data/ara/mappedCov5BsReads/$Mapper/$Mismatches/$samplename/raw_data_qualimapReport/coverage_across_reference.txt
header = c("position","coverage","stder", "mapper", "error")

samp1<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bismark/mm_0/simulatedConvRate100ErrRate0mm_0bismark/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp1$mapper<- "bismark"
samp1$error<-"0"
samp2<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bismark/mm_0/simulatedConvRate100ErrRate1mm_0bismark/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp2$mapper<- "bismark"
samp2$error<-"1"
samp3<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/gsnap/mm_0/simulatedConvRate100ErrRate0mm_0gsnap/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp3$mapper <- "gsnap"
samp3$error<-"0"
samp4<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/gsnap/mm_0/simulatedConvRate100ErrRate1mm_0gsnap/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp4$mapper <- "gsnap"
samp4$error<-"1"
samp5<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/gem3/mm_0/simulatedConvRate100ErrRate0mm_0gem3/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp5$mapper <- "gem3" 
samp5$error <- "0"
samp6<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/gem3/mm_0/simulatedConvRate100ErrRate1mm_0gem3/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp6$mapper <- "gem3" 
samp6$error <- "1"
samp7<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bwameth/mm_0/simulatedConvRate100ErrRate0mm_0bwameth/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp7$mapper <- "bwameth" 
samp7$error <- "0"
samp8<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bwameth/mm_0/simulatedConvRate100ErrRate1mm_0bwameth/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp8$mapper <- "bwameth" 
samp8$error <- "1"
samp9<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bsseeker2/mm_0/simulatedConvRate100ErrRate0mm_0bsseeker2/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp9$mapper <- "bsseeker2" 
samp9$error <- "0"
samp10<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bsseeker2/mm_0/simulatedConvRate100ErrRate1mm_0bsseeker2/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp10$mapper <- "bsseeker2" 
samp10$error <- "1"

samp11<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bismarkbwt2/mm_0/simulatedConvRate100ErrRate0mm_0bismarkbwt2/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp11$mapper <- "bismarkbwt2" 
samp11$error <- "0"
samp12<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bismarkbwt2/mm_0/simulatedConvRate100ErrRate1mm_0bismarkbwt2/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp12$mapper <- "bismarkbwt2" 
samp12$error <- "1"
samp13<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bsmap/mm_0/simulatedConvRate100ErrRate0mm_0bsmap/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp13$mapper <- "bsmap" 
samp13$error <- "0"
samp14<-read.csv("/home/user/IANVS/benchmarkWGBS/data/ara/mappedCov5BsReads/bsmap/mm_0/simulatedConvRate100ErrRate1mm_0bsmap/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp14$mapper <- "bsmap" 
samp14$error <- "1"


samp_combined<-rbind(samp1,samp2,samp3,samp4,samp5,samp6,samp7,samp8,samp9,samp10,samp11,samp12,samp13,samp14)
colnames(samp_combined)<- header

ggplot(samp_combined, aes(x=position)) +
  geom_line(aes(y=coverage,group = paste(mapper,error), color=mapper)) +
  theme_bw() +
  ylim(0,12) +
  scale_colour_brewer(palette = "Paired")+
  facet_grid(error~.) +
  labs(title="Coverage distribution over the genome of Arabidopsis thaliana", x= "Position in the Arabidopsis thaliana reference genome (TAIR10)")

chrom<-c(30427671,
         50125960,
         73585790,
         92170846,
         119146348)


centrostart<-c(11982161,
               31633155,
               60456609,
               75094024,
               101836570)
centroend<-c(17514465,
             37311154,
             66594657,
             79585756,
             108561769)
centro<- c(11982161,
           31633155,
           60456609,
           75094024,
           101836570,
           17514465,
           37311154,
           66594657,
           79585756,
           108561769)
chrtext<- c("chr1","chr2","chr3","chr4","chr5")
chrpos<- c(0.104937225807054,
           0.3563753730101,
           0.455168410624507,
           0.7006880778855562,
           0.786725771677242)

grob <- grobTree(textGrob(chrtext, x=chrpos,  y=0.7, hjust=0,
                          gp=gpar(col="black", fontsize=8, fontface="bold")))
samp_combined$error<-as.factor(samp_combined$error)

rns <- levels(samp_combined$error)[c(2,1)]  ; samp_combined$error <- factor(samp_combined$error, levels = rns)

ggplot(samp_combined, aes(x=position, y=coverage)) +
  #  geom_point(aes(y=coverage,x=position, color=mapper, shape=error),size=1) +
  geom_rect(data=data.frame(xmin =centrostart,
                            xmax =centroend,
                            ymin = -Inf,
                            ymax = Inf),
            aes(x = NULL,y = NULL,xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),    
            fill = "grey", alpha = 0.5) +
  geom_line(aes(y=coverage,group = paste(mapper,error), color=mapper, x=position)) +
  theme_bw() +
  ylim(0,10) +
  scale_colour_brewer(palette = "Paired")+
  facet_grid(error~.,labeller = label_both, switch = "y") +
  geom_vline(xintercept = chrom, color = "black", size=0.5) +
  annotation_custom(grob) +
  labs(title="Coverage distribution over the genome of Arabidopsis thaliana", x= "Position in the Arabidopsis thaliana reference genome (TAIR10)") +
  geom_vline(xintercept = centro, color = "grey", size=0.5)


################################
# gly

samp1<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bismark/mm_0/simulatedConvRate100ErrRate0mm_0bismark/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp1$mapper<- "bismark"
samp1$error<-"0"
samp2<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bismark/mm_0/simulatedConvRate100ErrRate1mm_0bismark/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp2$mapper<- "bismark"
samp2$error<-"1"
samp3<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/gsnap/mm_0/simulatedConvRate100ErrRate0mm_0gsnap/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp3$mapper <- "gsnap"
samp3$error<-"0"
samp4<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/gsnap/mm_0/simulatedConvRate100ErrRate1mm_0gsnap/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp4$mapper <- "gsnap"
samp4$error<-"1"
samp5<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/gem3/mm_0/simulatedConvRate100ErrRate0mm_0gem3/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp5$mapper <- "gem3" 
samp5$error <- "0"
samp6<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/gem3/mm_0/simulatedConvRate100ErrRate1mm_0gem3/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp6$mapper <- "gem3" 
samp6$error <- "1"
samp7<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bwameth/mm_0/simulatedConvRate100ErrRate0mm_0bwameth/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp7$mapper <- "bwameth" 
samp7$error <- "0"
samp8<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bwameth/mm_0/simulatedConvRate100ErrRate1mm_0bwameth/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp8$mapper <- "bwameth" 
samp8$error <- "1"
samp9<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bsseeker2/mm_0/simulatedConvRate100ErrRate0mm_0bsseeker2/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp9$mapper <- "bsseeker2" 
samp9$error <- "0"
samp10<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bsseeker2/mm_0/simulatedConvRate100ErrRate1mm_0bsseeker2/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp10$mapper <- "bsseeker2" 
samp10$error <- "1"

samp11<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bismarkbwt2/mm_0/simulatedConvRate100ErrRate0mm_0bismarkbwt2/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp11$mapper <- "bismarkbwt2" 
samp11$error <- "0"
samp12<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bismarkbwt2/mm_0/simulatedConvRate100ErrRate1mm_0bismarkbwt2/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp12$mapper <- "bismarkbwt2" 
samp12$error <- "1"
samp13<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bsmap/mm_0/simulatedConvRate100ErrRate0mm_0bsmap/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp13$mapper <- "bsmap" 
samp13$error <- "0"
samp14<-read.csv("/home/user/IANVS/benchmarkWGBS/data/mappedCov5BsReads/bsmap/mm_0/simulatedConvRate100ErrRate1mm_0bsmap/raw_data_qualimapReport/coverage_across_reference.txt", skip = 1, header = F, sep = "" , dec = ".", quote="")
samp14$mapper <- "bsmap" 
samp14$error <- "1"


samp_combined<-rbind(samp1,samp2,samp3,samp4,samp5,samp6,samp7,samp8,samp9,samp10,samp11,samp12,samp13,samp14)
colnames(samp_combined)<- header
chrom<-c(56831395,
         105408900,
         151188334,
         203577182,
         245811680,
         297227843,
         341858046,
         389695068,
         439884351,
         491451249,
         526218116,
         566309430,
         612183592,
         661225784,
         712982127,
         750869141,
         792510219,
         850528961,
         901275465,
         949176042)


centro<-c(12000000,	32000000,
          72831395,	82331395,
          85831395,	95831395,
          114408900,	120908900,
          166688334,	185188334,
          213577182,	229577182,
          262811680,	283311680,
          363858046,	381858046,
          400695068,	415695068,
          451884351,	468884351,
          510451249,	518451249,
          551218116,	560218116,
          622183592,	655183592,
          720982127,	727982127,
          877528961,	884528961,
          911275465,	917275465)
centrostart<-c(12000000,72831395,85831395,114408900,166688334,213577182,262811680,363858046,400695068,
               451884351,510451249,551218116,622183592,720982127,877528961,911275465)
centroend<-c(32000000,82331395,95831395,120908900,185188334,229577182,283311680,381858046,415695068,
             468884351,518451249,560218116,655183592,727982127,884528961,917275465)
chrtext<- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","scaffolds")
chrpos<- c(0.064937225807054,
           0.115463753730101,
           0.155168410624507,
           0.2006880778855562,
           0.246725771677242,
           0.286058380622296,
           0.33665298149192,
           0.3805362188692917,
           0.420999767320297,
           0.470602142695043,
           0.51080410782218,
           0.54505513654821052,
           0.5850797918327568,
           0.6250797259756373,
           0.673895173388711,
           0.721116844097504,
           0.753010069632584,
           0.8008139321536,
           0.852802698595715,
           0.894767285055431,
           0.95
)

grob <- grobTree(textGrob(chrtext, x=chrpos,  y=0.7, hjust=0,
                          gp=gpar(col="black", fontsize=8, fontface="bold")))
samp_combined$error<-as.factor(samp_combined$error)

rns <- levels(samp_combined$error)[c(2,1)]  ; samp_combined$error <- factor(samp_combined$error, levels = rns)

ggplot(samp_combined, aes(x=position, y=coverage)) +
  #  geom_point(aes(y=coverage,x=position, color=mapper, shape=error),size=1) +
  geom_rect(data=data.frame(xmin =centrostart,
                            xmax =centroend,
                            ymin = -Inf,
                            ymax = Inf),
            aes(x = NULL,y = NULL,xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),    
            fill = "grey", alpha = 0.5) +
  geom_line(aes(y=coverage,group = paste(mapper,error), color=mapper, x=position)) +
  theme_bw() +
  ylim(0,10) +
  scale_colour_brewer(palette = "Paired")+
  facet_grid(error~.,labeller = label_both, switch = "y") +
  geom_vline(xintercept = chrom, color = "black", size=0.5) +
  geom_vline(xintercept = centro, color = "grey", size=0.5) +
  annotation_custom(grob)+
  labs(title="Coverage distribution over the genome of Glycine max.", x= "Position in the Glycine max. reference genome (Williams82_v2.1.43)")




dat<-data.frame(xmin =centrostart,
                xmax =centroend,
                ymin = -Inf,
                ymax = Inf)

data.frame(xmin = min(as.integer(position)) - 0.5,
           xmax = max(as.integer(position)) + 0.5,
           ymin = -Inf,
           ymax =  Inf)

