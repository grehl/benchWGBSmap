


library(data.table)
#BiocManager::install("GenomicRanges")
library(GenomicRanges)
bismark_bwt2<-read.csv("/home/user/IANVS/Defiant/test/bismarkbwt2/control_vs_case_new_c10_CpN5_d1_p0.05_P10_q.tsv", skip = 1, header = F, sep = "\t" , dec = ".", quote="")
colnames(bismark_bwt2)[1] <- "chr"
colnames(bismark_bwt2)[2] <- "start"
colnames(bismark_bwt2)[3] <- "end"
bismark_bwt2_gr<-makeGRangesFromDataFrame(bismark_bwt2)
bismark_bwt1<-read.csv("/home/user/IANVS/Defiant/test/bismarkbwt1/control_vs_case_new_c10_CpN5_d1_p0.05_P10_q.tsv", skip = 1, header = F, sep = "\t" , dec = ".", quote="")
colnames(bismark_bwt1)[1] <- "chr"
colnames(bismark_bwt1)[2] <- "start"
colnames(bismark_bwt1)[3] <- "end"
bismark_bwt1_gr<-makeGRangesFromDataFrame(bismark_bwt1)
gem3<-read.csv("/home/user/IANVS/Defiant/test/gem3/control_vs_case_new_c10_CpN5_d1_p0.05_P10_q.tsv", skip = 1, header = F, sep = "\t" , dec = ".", quote="")
colnames(gem3)[1] <- "chr"
colnames(gem3)[2] <- "start"
colnames(gem3)[3] <- "end"
gem3_gr<-makeGRangesFromDataFrame(gem3)
bsmap<-read.csv("/home/user/IANVS/Defiant/test/bsmap/control_vs_case_new_c10_CpN5_d1_p0.05_P10_q.tsv", skip = 1, header = F, sep = "\t" , dec = ".", quote="")
colnames(bsmap)[1] <- "chr"
colnames(bsmap)[2] <- "start"
colnames(bsmap)[3] <- "end"
bsmap_gr<-makeGRangesFromDataFrame(bsmap)
bwameth<-read.csv("/home/user/IANVS/Defiant/test/bwameth/control_vs_case_new_c10_CpN5_d1_p0.05_P10_q.tsv", skip = 1, header = F, sep = "\t" , dec = ".", quote="")
colnames(bwameth)[1] <- "chr"
colnames(bwameth)[2] <- "start"
colnames(bwameth)[3] <- "end"
bwameth_gr<-makeGRangesFromDataFrame(bwameth)
gsnap<-read.csv("/home/user/IANVS/Defiant/test/gsnap/control_vs_case_new_c10_CpN5_d1_p0.05_P10_q.tsv", skip = 1, header = F, sep = "\t" , dec = ".", quote="")
colnames(gsnap)[1] <- "chr"
colnames(gsnap)[2] <- "start"
colnames(gsnap)[3] <- "end"
gsnap_gr<-makeGRangesFromDataFrame(gsnap)

lt2= list(gsnap = gsnap_gr,
          gem3 = gem3_gr,
          bismark_bwt1=bismark_bwt1_gr, bismark_bwt2=bismark_bwt2_gr,
          bwameth=bwameth_gr,bsmap=bsmap_gr)


df <- data.frame(matrix(ncol = length(names(lt2)), nrow = length(names(lt2))))
colnames(df) <- names(lt2)
rownames(df) <- names(lt2)

mapper<-list(names(lt2))
for( j in 1:6){
  for(i in 1:6 ){
    x<-GenomicRanges::findOverlaps(query = lt2[[j]], subject = lt2[[i]])
    df[j,i]<-length(unique(x@from))
  }
}
df
