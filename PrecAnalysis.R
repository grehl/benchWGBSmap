library(ggplot2)
library(grid)
library(gridExtra)
library(wesanderson)
library(RColorBrewer)
library(dplyr)

#f1Scores <- read.csv("/run/user/1000/gvfs/sftp:host=ianvs.itz.uni-halle.de,user=user/scratch/user/user/benchmarkWGBS/results/f1ScoreCombined.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")

f1Scores_sol <- read.csv("/home/user/IANVS/benchmarkWGBS/results/sol/f1ScoreCombined.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")
f1Scores_sol$mismatches[f1Scores_sol$mapper=="bismarkbwt2"]<- "X"
f1Scores_sol$mismatches[f1Scores_sol$mapper=="bwameth"]<- "X"

f1Scores_ara <- read.csv("/home/user/IANVS/benchmarkWGBS/results/ara/f1ScoreCombined.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")
f1Scores_ara$mismatches[f1Scores_ara$mapper=="bwameth"]<- "X"
f1Scores_ara$mismatches[f1Scores_ara$mapper=="bismarkbwt2"]<- "X"

f1Scores_bra <- read.csv("/home/user/IANVS/benchmarkWGBS/results/bra/f1ScoreCombined.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")
f1Scores_bra$mismatches[f1Scores_bra$mapper=="bwameth"]<- "X"
f1Scores_bra$mismatches[f1Scores_bra$mapper=="bismarkbwt2"]<- "X"

f1Scores_zea <- read.csv("/home/user/IANVS/benchmarkWGBS/results/zea/f1ScoreCombined.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")
f1Scores_zea$mismatches[f1Scores_zea$mapper=="bwameth"]<- "X"
f1Scores_zea$mismatches[f1Scores_zea$mapper=="bismarkbwt2"]<- "X"

f1Scores_gly <- read.csv("/home/user/IANVS/benchmarkWGBS/results/f1ScoreCombined.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")
f1Scores_gly$mismatches[f1Scores_gly$mapper=="bwameth"]<- "X"
f1Scores_gly$mismatches[f1Scores_gly$mapper=="bismarkbwt2"]<- "X"
f1Scores_gly<-distinct(f1Scores_gly)




#########################
#solanum
mapperList <- unique(f1Scores_sol$mapper)
conversionRates <- sort(unique(f1Scores_sol$conversionRate), decreasing = FALSE)
errorRates <- sort(unique(f1Scores_sol$errorRate), decreasing = TRUE)
mismatches <- unique(f1Scores_sol$mismatches)
#calculate ratio for Cov20

#num reads

12123742
f1Scores_sol$matchedReads <- f1Scores_sol$matchedReads / 24247484

grid_arrange_shared_legend <- function(...) {
  plots <- list(...)
  g <- ggplotGrob(plots[[1]] + theme(legend.position="right"))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  grid.arrange(
    do.call(arrangeGrob, lapply(plots, function(x)
      x + theme(legend.position="none"))),
    legend,
    ncol = 2,
    widths=c(8,1))
    #heights = unit.c(unit(1, "npc") - lheight, lheight))
}

#plot Prec with all mappers
#pltList <- list()
#index <- 1 
#for (errorRate in errorRates){
#  for (conversionRate in conversionRates){
#    f1ScoresSubset <- f1Scores_sol[ which(f1Scores_sol$conversionRate==conversionRate & f1Scores_sol$errorRate==errorRate & f1Scores_sol$mapper != 'segemehl'),]
#    plt <- ggplot(data = f1ScoresSubset, aes(x=mismatches, y=macroF1Score)) + 
#      geom_point(aes(colour=mapper, size=mapper)) +
#      scale_size_manual (values= c(2.5,2,1.5,1,0.75,0.5))+
#      scale_color_manual(values = wes_palette(n=6, name="FantasticFox1", type = "continuous")) +
#      labs(y = "F1Score") +
#      ylim(0.75,1.0)
#    pltList[[index]] <- plt
#    index <- index + 1
#  } 
#}


pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_sol[ which(f1Scores_sol$conversionRate==conversionRate & f1Scores_sol$errorRate==errorRate & f1Scores_sol$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=macroAvgPrecision)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "macroAvgPrecision")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}

grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])


#f1Scores_sol$Accuracy <- f1Scores_sol$avgAccuracy * f1Scores_sol$matchedReads
#f1Scores_sol$f1Score<- f1Scores_sol$macroF1Score * f1Scores_sol$matchedReads

#plot acc vs. Prec
#ggplot(data = f1Scores_sol, aes(x=Accuracy, y= macroAvgPrecision)) + 
#  labs(title="Precision vs. Accuracy", x ="avgAccuracy", y = "macroAvgPrecision") +
#  geom_point(aes(colour=mapper), size = 2) + 
#  theme( plot.title = element_text(hjust = 0.5,size=14, face="bold"),
#         axis.title=element_text(size=14)) +
#  scale_colour_brewer(palette = "Paired") +
#  geom_abline(intercept = 0, slope = 1, size = 0.1) +
#  ylim(0,1) +
#  xlim(0,1) +
#  geom_line(aes(group=paste(mapper,errorRate), color=mapper)) +
#  theme_bw()
  

#plot mappedReads used to calc. Prec
pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_sol[ which(f1Scores_sol$conversionRate==conversionRate & f1Scores_sol$errorRate==errorRate & f1Scores_sol$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=matchedReads)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "uniqMapReads/\ntotalReads")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}



grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])

##################################################################################################
#zea

mapperList <- unique(f1Scores_zea$mapper)
conversionRates <- sort(unique(f1Scores_zea$conversionRate), decreasing = FALSE)
errorRates <- sort(unique(f1Scores_zea$errorRate), decreasing = TRUE)
mismatches <- unique(f1Scores_zea$mismatches)

#num reads

35072503
f1Scores_zea$matchedReads <- f1Scores_zea$matchedReads / 70145006

grid_arrange_shared_legend <- function(...) {
  plots <- list(...)
  g <- ggplotGrob(plots[[1]] + theme(legend.position="right"))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  grid.arrange(
    do.call(arrangeGrob, lapply(plots, function(x)
      x + theme(legend.position="none"))),
    legend,
    ncol = 2,
    widths=c(8,1))
  #heights = unit.c(unit(1, "npc") - lheight, lheight))
}

pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_zea[ which(f1Scores_zea$conversionRate==conversionRate & f1Scores_zea$errorRate==errorRate & f1Scores_zea$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=macroAvgPrecision)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "macroAvgPrecision")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}
grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])

#plot mappedReads used to calc. Prec
pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_zea[ which(f1Scores_zea$conversionRate==conversionRate & f1Scores_zea$errorRate==errorRate & f1Scores_zea$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=matchedReads)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "uniqMapReads/\ntotalReads")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}
grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])


##################################################################################################
#brassica

mapperList <- unique(f1Scores_bra$mapper)
conversionRates <- sort(unique(f1Scores_bra$conversionRate), decreasing = FALSE)
errorRates <- sort(unique(f1Scores_bra$errorRate), decreasing = TRUE)
mismatches <- unique(f1Scores_bra$mismatches)

#num reads

12305963
f1Scores_bra$matchedReads <- f1Scores_bra$matchedReads / 24611926

grid_arrange_shared_legend <- function(...) {
  plots <- list(...)
  g <- ggplotGrob(plots[[1]] + theme(legend.position="right"))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  grid.arrange(
    do.call(arrangeGrob, lapply(plots, function(x)
      x + theme(legend.position="none"))),
    legend,
    ncol = 2,
    widths=c(8,1))
  #heights = unit.c(unit(1, "npc") - lheight, lheight))
}

pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_bra[ which(f1Scores_bra$conversionRate==conversionRate & f1Scores_bra$errorRate==errorRate & f1Scores_bra$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=macroAvgPrecision)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "macroAvgPrecision")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}
grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])

#plot mappedReads used to calc. Prec
pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_bra[ which(f1Scores_bra$conversionRate==conversionRate & f1Scores_bra$errorRate==errorRate & f1Scores_bra$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=matchedReads)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "uniqMapReads/\ntotalReads")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}
grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])


##################################################################################################
#arabidopsis

mapperList <- unique(f1Scores_ara$mapper)
conversionRates <- sort(unique(f1Scores_ara$conversionRate), decreasing = FALSE)
errorRates <- sort(unique(f1Scores_ara$errorRate), decreasing = TRUE)
mismatches <- unique(f1Scores_ara$mismatches)

#num reads

2261170
f1Scores_ara$matchedReads <- f1Scores_ara$matchedReads / 4522340

grid_arrange_shared_legend <- function(...) {
  plots <- list(...)
  g <- ggplotGrob(plots[[1]] + theme(legend.position="right"))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  grid.arrange(
    do.call(arrangeGrob, lapply(plots, function(x)
      x + theme(legend.position="none"))),
    legend,
    ncol = 2,
    widths=c(8,1))
  #heights = unit.c(unit(1, "npc") - lheight, lheight))
}

pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_ara[ which(f1Scores_ara$conversionRate==conversionRate & f1Scores_ara$errorRate==errorRate & f1Scores_ara$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=macroAvgPrecision)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "macroAvgPrecision")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}
grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])

#plot mappedReads used to calc. Prec
pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_ara[ which(f1Scores_ara$conversionRate==conversionRate & f1Scores_ara$errorRate==errorRate & f1Scores_ara$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=matchedReads)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "uniqMapReads/\ntotalReads")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}
grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])


##################################################################################################
#glycine

mapperList <- unique(f1Scores_gly$mapper)
conversionRates <- sort(unique(f1Scores_gly$conversionRate), decreasing = FALSE)
errorRates <- sort(unique(f1Scores_gly$errorRate), decreasing = TRUE)
mismatches <- unique(f1Scores_gly$mismatches)

#num reads
f1Scores_gly$matchedReads <- f1Scores_gly$matchedReads / 31845678

grid_arrange_shared_legend <- function(...) {
  plots <- list(...)
  g <- ggplotGrob(plots[[1]] + theme(legend.position="right"))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  grid.arrange(
    do.call(arrangeGrob, lapply(plots, function(x)
      x + theme(legend.position="none"))),
    legend,
    ncol = 2,
    widths=c(8,1))
  #heights = unit.c(unit(1, "npc") - lheight, lheight))
}

pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_gly[ which(f1Scores_gly$conversionRate==conversionRate & f1Scores_gly$errorRate==errorRate & f1Scores_gly$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=macroAvgPrecision)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "macroAvgPrecision")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}
grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])

#plot mappedReads used to calc. Prec
pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (conversionRate in conversionRates){
    f1ScoresSubset <- f1Scores_gly[ which(f1Scores_gly$conversionRate==conversionRate & f1Scores_gly$errorRate==errorRate & f1Scores_gly$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=mismatches, y=matchedReads)) + 
      geom_bar(position=position_dodge2(width = 0.9, preserve = "single"), stat="identity") +
      scale_fill_brewer(palette = "Paired") +
      theme_bw() +
      labs(y = "uniqMapReads/\ntotalReads")
    pltList[[index]] <- plt
    index <- index + 1
  } 
}
grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], 
                           pltList[[4]], pltList[[5]], pltList[[6]],
                           pltList[[7]], pltList[[8]], pltList[[9]],
                           pltList[[10]], pltList[[11]], pltList[[12]])

################################################################################
################################################################################
#total

f1Scores_ara$gnsize <-135670229
f1Scores_ara$genome <-"Arabidopsis thaliana"
f1Scores_bra$gnsize <-738357821
f1Scores_bra$genome <-"Brassica napus"
f1Scores_sol$gnsize <-727424546
f1Scores_sol$genome <-"Solanum tuberosum"
f1Scores_gly$gnsize <-955377461
f1Scores_gly$genome <-"Glycine max."
f1Scores_zea$gnsize <-2104350183
f1Scores_zea$genome <-"Zea mays"

f1Score_total<-rbind(f1Scores_ara,f1Scores_bra,f1Scores_sol,f1Scores_gly,f1Scores_zea)
f1Score_total<- f1Score_total[f1Score_total$conversionRate==100& f1Score_total$mapper != 'segemehl',]

ggplot(f1Score_total, aes(x=matchedReads, y=macroAvgPrecision))+ 
  geom_point(aes(colour=mapper,size=genome))+
  scale_size_manual (values= c(0.5,1,2,3,4))+
  geom_line(aes(group=paste(mismatches,mapper,errorRate), color=mapper)) +
  scale_colour_brewer(palette = "YlGnBu")
#######################################
genomes<- sort(unique(f1Score_total$genome))

  grid_arrange_shared_legend <- function(...) {
    plots <- list(...)
    g <- ggplotGrob(plots[[1]] + theme(legend.position="right"))$grobs
    legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
    lheight <- sum(legend$height)
    lay <- rbind(c(1,2,3,4,5,6),
                 c(7,7,7,7,7,8),
                 c(7,7,7,7,7,8),
                 c(7,7,7,7,7,8),
                 c(7,7,7,7,7,8),
                 c(7,7,7,7,7,8),
                 c(7,7,7,7,7,8),
                 c(7,7,7,7,7,8),
                 c(7,7,7,7,7,8),
                 c(7,7,7,7,7,8))
    ara <- textGrob("Arabidopsis thaliana", gp=gpar(fontsize=15, fontface=3L, fontfamily="Times New Roman"))
    bra<- textGrob("Brassica napus", gp=gpar(fontsize=15, fontface=3L, fontfamily="Times New Roman"))
    gly<- textGrob("Solanum tuberosum", gp=gpar(fontsize=15, fontface=3L, fontfamily="Times New Roman"))
    sol<- textGrob("Glycine max", gp=gpar(fontsize=15, fontface=3L, fontfamily="Times New Roman"))
    zea<- textGrob("Zea mays", gp=gpar(fontsize=15, fontface=3L, fontfamily="Times New Roman"))
    na <- textGrob(" ", gp=gpar(fontsize=15, fontface=3L, fontfamily="Times New Roman"))
    grid.arrange(ara,bra,gly,sol,zea,na,
      do.call(arrangeGrob,args=list( grobs=lapply(plots, function(x)
        x + theme(legend.position="none")), nrow = 4, ncol = 5)),
      legend,
      layout_matrix = lay,
      top = textGrob("Quality Benchmark with various genomes", gp=gpar(fontsize=20, fontface=2,fontfamily="Times New Roman"))
    ) 
  }
  
  
pltList <- list()
index <- 1 
for (errorRate in errorRates){
  for (genome in genomes){
    f1ScoresSubset <- f1Score_total[ which(f1Score_total$genome==genome & f1Score_total$errorRate==errorRate & f1Score_total$mapper != 'segemehl'),]
    plt <- ggplot(data = f1ScoresSubset, aes(fill=mapper, x=matchedReads, y=macroAvgPrecision)) + 
      geom_point(aes(colour=mapper, size=mismatches, shape=mapper))+
      scale_size_manual (values= c(0.5,1.5,3,4,3))+
      scale_shape_manual(values=c(1,2,1,1,2,1,1)) +
      scale_colour_brewer(palette = "Paired") +
      geom_line(aes(group=mapper, color=mapper)) +
      ylim(0.5,1.01) + 
      xlim(0,1.01) +
      labs(y = "macroAvgPrecision", x= "unique reads (relative)") +
      theme_bw()
    pltList[[index]] <- plt
    index <- index + 1
  } 
}

grid_arrange_shared_legend(pltList[[1]], pltList[[2]], pltList[[3]], pltList[[4]], pltList[[5]],
                           pltList[[6]], pltList[[7]], pltList[[8]], pltList[[9]], pltList[[10]],
                           pltList[[11]], pltList[[12]], pltList[[13]], pltList[[14]], pltList[[15]],
                           pltList[[16]], pltList[[17]], pltList[[18]], pltList[[19]], pltList[[20]])

