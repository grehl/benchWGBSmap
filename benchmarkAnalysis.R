library(ggplot2)
library(grid)
library(gridExtra)
library(lubridate)
library(plyr)

#load data

bench_ara <- read.csv("/home/user/IANVS/benchmarkWGBS/results/ara/benchmarkCov5/combinedBenchmarkCov5.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")
bench_bra <- read.csv("/home/user/IANVS/benchmarkWGBS/results/bra/benchmarkCov5/combinedBenchmarkCov5.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")
bench_sol <- read.csv("/home/user/IANVS/benchmarkWGBS/results/sol/benchmarkCov5/combinedBenchmarkCov5.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")
bench_gly <- read.csv("/home/user/IANVS/benchmarkWGBS/results/gly/benchmarkCov5/combinedBenchmarkCov5.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")
bench_zea <- read.csv("/home/user/IANVS/benchmarkWGBS/results/zea/benchmarkCov5/combinedBenchmarkCov5.csv", header = TRUE, sep = "\t", quote = "\"", dec = ".")


##################################################################################
#reshape data
benchmarkData$RSS <- benchmarkData$RSS / 1000000
benchmarkData$elapsed <- period_to_seconds(hms(benchmarkData$elapsed))/3600
benchmarkData$cpu.sys <- benchmarkData$cpu.sys/3600
benchmarkData$.user <- benchmarkData$.user/3600
benchmarkData$run <- NULL
benchmarkData$cpuTime <- benchmarkData$cpu.sys + benchmarkData$.user

benchmarkData <- rename(benchmarkData, c("elapsed"="realTime"))

#average runs
sumBenchmark <- do.call(data.frame, aggregate(. ~ mapper, benchmarkData, function(x) c(m = mean(x), s = sd(x) )))

#memory plot
ggplot(sumBenchmark, aes(x=mapper, y=RSS.m)) + 
  geom_bar(stat="identity", fill="forestgreen", alpha=0.7, 
           position=position_dodge()) +
  geom_text(aes(label=round(RSS.m, digits = 2)), vjust=-1.3, color="black",
            position = position_dodge(0.9), size=3.5)+
  ylim(0,20) +
  labs(title="Memory benchmark on a 20x simulated Glycine max. dataset", x="mapper", y = "Maximum resident set size (RSS) in GB") +
  geom_errorbar(aes(ymin=RSS.m-RSS.s, ymax=RSS.m+RSS.s), width=.2,
                position=position_dodge(.9)) 
library(reshape)
#runtime plot
sumRuntimeMeanBenchmark <- sumBenchmark[c('realTime.m','cpuTime.m','mapper')]
sumRuntimeMeanBenchmark <- melt(sumRuntimeMeanBenchmark, id = c("mapper"))
sumRuntimeMeanBenchmark$variable <- revalue(sumRuntimeMeanBenchmark$variable, c("realTime.m"="realTime", "cpuTime.m"="cpuTime"))
sumRuntimeMeanBenchmark <- rename(sumRuntimeMeanBenchmark, c("value"="mean","variable"="measurement"))

sumRuntimeSdBenchmark <- sumBenchmark[c('realTime.s','cpuTime.s','mapper')]
sumRuntimeSdBenchmark <- melt(sumRuntimeSdBenchmark, id = c("mapper"))
sumRuntimeSdBenchmark <- rename(sumRuntimeSdBenchmark, c("value"="sd","variable"="measurement"))

sumRuntimeBenchmark <- cbind(sumRuntimeMeanBenchmark[c('mapper','measurement','mean')], sumRuntimeSdBenchmark[c('sd')])

ggplot(sumRuntimeBenchmark, aes(x=mapper, y=mean, fill=measurement)) + 
  geom_bar(stat="identity", alpha=0.7, 
           position=position_dodge()) + 
  scale_fill_manual(values = c("forestgreen","orange")) +
  geom_text(aes(label=round(mean, digits = 2)), vjust=-1.3, color="black",
            position = position_dodge(0.9), size=3.5)+
  labs(title="Runtime benchmark on a 20x simulated Glycine max. dataset", x="mapper", y = "runtime in hours") +
  ylim(0,80) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) 
###################################################################

#ara

#reshape data
bench_ara$RSS <- bench_ara$RSS / 1000000
bench_ara$elapsed <- period_to_seconds(lubridate::hms(bench_ara$elapsed))/3600
bench_ara$cpu.sys <- bench_ara$cpu.sys/3600
bench_ara$.user <- bench_ara$.user/3600
bench_ara$run <- NULL
#bench_ara$cpuTime <- bench_ara$cpu.sys + bench_ara$.user
bench_ara$cpuTime <- bench_ara$.user

bench_ara <- rename(bench_ara, c("elapsed"="realTime"))
#average runs
sumBenchmark_ara <- do.call(data.frame, aggregate(. ~ mapper, bench_ara, function(x) c(m = mean(x), s = sd(x) )))

#memory plot
ggplot(sumBenchmark_ara, aes(x=mapper, y=RSS.m)) + 
  geom_bar(stat="identity", fill="forestgreen", alpha=0.7, 
           position=position_dodge()) +
  geom_text(aes(label=round(RSS.m, digits = 2)), vjust=-1.3, color="black",
            position = position_dodge(0.9), size=3.5)+
  ylim(0,20) +
  labs(title="Memory benchmark on a 5x simulated Arabidopsis thaliana dataset", x="mapper", y = "Maximum resident set size (RSS) in GB") +
  geom_errorbar(aes(ymin=RSS.m-RSS.s, ymax=RSS.m+RSS.s), width=.2,
                position=position_dodge(.9)) +
  theme_bw()

library(reshape)
#runtime plot
sumRuntimeMeanBenchmark_ara <- sumBenchmark_ara[c('realTime.m','cpuTime.m','mapper')]
sumRuntimeMeanBenchmark_ara <- melt(sumRuntimeMeanBenchmark_ara, id = c("mapper"))
sumRuntimeMeanBenchmark_ara$variable <- revalue(sumRuntimeMeanBenchmark_ara$variable, c("realTime.m"="realTime", "cpuTime.m"="cpuTime"))
sumRuntimeMeanBenchmark_ara <- rename(sumRuntimeMeanBenchmark_ara, c("value"="mean","variable"="measurement"))

sumRuntimeSdBenchmark_ara <- sumBenchmark_ara[c('realTime.s','cpuTime.s','mapper')]
sumRuntimeSdBenchmark_ara <- melt(sumRuntimeSdBenchmark_ara, id = c("mapper"))
sumRuntimeSdBenchmark_ara <- rename(sumRuntimeSdBenchmark_ara, c("value"="sd","variable"="measurement"))

sumRuntimeBenchmark_ara <- cbind(sumRuntimeMeanBenchmark_ara[c('mapper','measurement','mean')], sumRuntimeSdBenchmark_ara[c('sd')])

ggplot(sumRuntimeBenchmark_ara, aes(x=mapper, y=mean, fill=measurement)) + 
  geom_bar(stat="identity", alpha=0.7, 
           position=position_dodge()) + 
  scale_fill_manual(values = c("forestgreen","orange")) +
  geom_text(aes(label=round(mean, digits = 2)), vjust=-1.3, color="black",
            position = position_dodge(0.9), size=3.5)+
  labs(title="Runtime benchmark on a 5x simulated Arabidopsis thaliana dataset", x="mapper", y = "runtime in hours") +
  ylim(0,5) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) +
  theme_bw()

###################################################################

#bra

#reshape data
bench_bra$RSS <- bench_bra$RSS / 1000000
bench_bra$elapsed <- period_to_seconds(lubridate::hms(bench_bra$elapsed))/3600
bench_bra$cpu.sys <- bench_bra$cpu.sys/3600
bench_bra$.user <- bench_bra$.user/3600
bench_bra$run <- NULL
#bench_bra$cpuTime <- bench_bra$cpu.sys + bench_bra$.user
bench_bra$cpuTime <- bench_bra$.user

bench_bra <- rename(bench_bra, c("elapsed"="realTime"))

#average runs
sumBenchmark_bra <- do.call(data.frame, aggregate(. ~ mapper, bench_bra, function(x) c(m = mean(x), s = sd(x) )))

#memory plot
ggplot(sumBenchmark_bra, aes(x=mapper, y=RSS.m)) + 
  geom_bar(stat="identity", fill="forestgreen", alpha=0.7, 
           position=position_dodge()) +
  geom_text(aes(label=round(RSS.m, digits = 2)), vjust = ifelse(sumBenchmark_bra$RSS.s > 0.2, -4.5, -1.3), color="black",
            position = position_dodge(.9), size=3.5)+
  ylim(0,20) +
  labs(title="Memory benchmark on a 5x simulated Brassica napus dataset", x="mapper", y = "Maximum resident set size (RSS) in GB") +
  geom_errorbar(aes(ymin=RSS.m-RSS.s, ymax=RSS.m+RSS.s), width=.2,
                position=position_dodge(.9)) +
  theme_bw()
library(reshape)
#runtime plot
sumRuntimeMeanBenchmark_bra <- sumBenchmark_bra[c('realTime.m','cpuTime.m','mapper')]
sumRuntimeMeanBenchmark_bra <- melt(sumRuntimeMeanBenchmark_bra, id = c("mapper"))
sumRuntimeMeanBenchmark_bra$variable <- revalue(sumRuntimeMeanBenchmark_bra$variable, c("realTime.m"="realTime", "cpuTime.m"="cpuTime"))
sumRuntimeMeanBenchmark_bra <- rename(sumRuntimeMeanBenchmark_bra, c("value"="mean","variable"="measurement"))

sumRuntimeSdBenchmark_bra <- sumBenchmark_bra[c('realTime.s','cpuTime.s','mapper')]
sumRuntimeSdBenchmark_bra <- melt(sumRuntimeSdBenchmark_bra, id = c("mapper"))
sumRuntimeSdBenchmark_bra <- rename(sumRuntimeSdBenchmark_bra, c("value"="sd","variable"="measurement"))

sumRuntimeBenchmark_bra <- cbind(sumRuntimeMeanBenchmark_bra[c('mapper','measurement','mean')], sumRuntimeSdBenchmark_bra[c('sd')])

ggplot(sumRuntimeBenchmark_bra, aes(x=mapper, y=mean, fill=measurement)) + 
  geom_bar(stat="identity", alpha=0.7, 
           position=position_dodge()) + 
  scale_fill_manual(values = c("forestgreen","orange")) +
  geom_text(aes(label=round(mean, digits = 2)), vjust=-1.3, color="black",
            position = position_dodge(0.9), size=3.5)+
  labs(title="Runtime benchmark on a 5x simulated Brassica napus dataset", x="mapper", y = "runtime in hours") +
  ylim(0,15) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) +
  theme_bw()

###################################################################

#sol

#reshape data
bench_sol$RSS <- bench_sol$RSS / 1000000
bench_sol$elapsed <- period_to_seconds(lubridate::hms(bench_sol$elapsed))/3600
bench_sol$cpu.sys <- bench_sol$cpu.sys/3600
bench_sol$.user <- bench_sol$.user/3600
bench_sol$run <- NULL
#bench_sol$cpuTime <- bench_sol$cpu.sys + bench_sol$.user
bench_sol$cpuTime <- bench_sol$.user

bench_sol <- rename(bench_sol, c("elapsed"="realTime"))

#average runs
sumBenchmark_sol <- do.call(data.frame, aggregate(. ~ mapper, bench_sol, function(x) c(m = mean(x), s = sd(x) )))

#memory plot
ggplot(sumBenchmark_sol, aes(x=mapper, y=RSS.m)) + 
  geom_bar(stat="identity", fill="forestgreen", alpha=0.7, 
           position=position_dodge()) +
  geom_text(aes(label=round(RSS.m, digits = 2)), vjust=ifelse(sumBenchmark_bra$RSS.s > 0.2, -4.5, -1.3), color="black",
            position = position_dodge(0.9), size=3.5)+
  ylim(0,20) +
  labs(title="Memory benchmark on a 5x simulated Solanum tuberosum dataset", x="mapper", y = "Maximum resident set size (RSS) in GB") +
  geom_errorbar(aes(ymin=RSS.m-RSS.s, ymax=RSS.m+RSS.s), width=.2,
                position=position_dodge(.9)) +
  theme_bw()
library(reshape)
#runtime plot
sumRuntimeMeanBenchmark_sol <- sumBenchmark_sol[c('realTime.m','cpuTime.m','mapper')]
sumRuntimeMeanBenchmark_sol <- melt(sumRuntimeMeanBenchmark_sol, id = c("mapper"))
sumRuntimeMeanBenchmark_sol$variable <- revalue(sumRuntimeMeanBenchmark_sol$variable, c("realTime.m"="realTime", "cpuTime.m"="cpuTime"))
sumRuntimeMeanBenchmark_sol <- rename(sumRuntimeMeanBenchmark_sol, c("value"="mean","variable"="measurement"))

sumRuntimeSdBenchmark_sol <- sumBenchmark_sol[c('realTime.s','cpuTime.s','mapper')]
sumRuntimeSdBenchmark_sol <- melt(sumRuntimeSdBenchmark_sol, id = c("mapper"))
sumRuntimeSdBenchmark_sol <- rename(sumRuntimeSdBenchmark_sol, c("value"="sd","variable"="measurement"))

sumRuntimeBenchmark_sol <- cbind(sumRuntimeMeanBenchmark_sol[c('mapper','measurement','mean')], sumRuntimeSdBenchmark_sol[c('sd')])

ggplot(sumRuntimeBenchmark_sol, aes(x=mapper, y=mean, fill=measurement)) + 
  geom_bar(stat="identity", alpha=0.7, 
           position=position_dodge()) + 
  scale_fill_manual(values = c("forestgreen","orange")) +
  geom_text(aes(label=round(mean, digits = 2)), vjust=-1.3, color="black",
            position = position_dodge(0.9), size=3.5)+
  labs(title="Runtime benchmark on a 5x simulated Solanum tuberosum dataset", x="mapper", y = "runtime in hours") +
  ylim(0,12) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) +
  theme_bw()

###################################################################
#gly

#reshape data
bench_gly$RSS <- bench_gly$RSS / 1000000
bench_gly$elapsed <- period_to_seconds(lubridate::hms(bench_gly$elapsed))/3600
bench_gly$cpu.sys <- bench_gly$cpu.sys/3600
bench_gly$.user <- bench_gly$.user/3600
bench_gly$run <- NULL
#bench_gly$cpuTime <- bench_gly$cpu.sys + bench_gly$.user
bench_gly$cpuTime <- bench_gly$.user

bench_gly <- rename(bench_gly, c("elapsed"="realTime"))

#average runs
sumBenchmark_gly <- do.call(data.frame, aggregate(. ~ mapper, bench_gly, function(x) c(m = mean(x), s = sd(x) )))

#memory plot
ggplot(sumBenchmark_gly, aes(x=mapper, y=RSS.m)) + 
  geom_bar(stat="identity", fill="forestgreen", alpha=0.7, 
           position=position_dodge()) +
  geom_text(aes(label=round(RSS.m, digits = 2)), vjust=ifelse(sumBenchmark_bra$RSS.s > 0.2, -5.2, -1.3), color="black",
            position = position_dodge(0.9), size=3.5)+
  ylim(0,20) +
  labs(title="Memory benchmark on a 5x simulated Glycine max. dataset", x="mapper", y = "Maximum resident set size (RSS) in GB") +
  geom_errorbar(aes(ymin=RSS.m-RSS.s, ymax=RSS.m+RSS.s), width=.2,
                position=position_dodge(.9)) +
  theme_bw()
library(reshape)
#runtime plot
sumRuntimeMeanBenchmark_gly <- sumBenchmark_gly[c('realTime.m','cpuTime.m','mapper')]
sumRuntimeMeanBenchmark_gly <- melt(sumRuntimeMeanBenchmark_gly, id = c("mapper"))
sumRuntimeMeanBenchmark_gly$variable <- revalue(sumRuntimeMeanBenchmark_gly$variable, c("realTime.m"="realTime", "cpuTime.m"="cpuTime"))
sumRuntimeMeanBenchmark_gly <- rename(sumRuntimeMeanBenchmark_gly, c("value"="mean","variable"="measurement"))

sumRuntimeSdBenchmark_gly <- sumBenchmark_gly[c('realTime.s','cpuTime.s','mapper')]
sumRuntimeSdBenchmark_gly <- melt(sumRuntimeSdBenchmark_gly, id = c("mapper"))
sumRuntimeSdBenchmark_gly <- rename(sumRuntimeSdBenchmark_gly, c("value"="sd","variable"="measurement"))

sumRuntimeBenchmark_gly <- cbind(sumRuntimeMeanBenchmark_gly[c('mapper','measurement','mean')], sumRuntimeSdBenchmark_gly[c('sd')])

ggplot(sumRuntimeBenchmark_gly, aes(x=mapper, y=mean, fill=measurement)) + 
  geom_bar(stat="identity", alpha=0.7, 
           position=position_dodge()) + 
  scale_fill_manual(values = c("forestgreen","orange")) +
  geom_text(aes(label=round(mean, digits = 2)), vjust=-1.3, color="black",
            position = position_dodge(0.9), size=3.5)+
  labs(title="Runtime benchmark on a 5x simulated Glycine max. dataset", x="mapper", y = "runtime in hours") +
  ylim(0,20) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) +
  theme_bw()

###################################################################
#zea
bench_zea<-na.omit(bench_zea)
#reshape data
bench_zea$RSS <- bench_zea$RSS / 1000000
bench_zea$elapsed <- period_to_seconds(lubridate::hms(bench_zea$elapsed))/3600
bench_zea$cpu.sys <- bench_zea$cpu.sys/3600
bench_zea$.user <- bench_zea$.user/3600
bench_zea$run <- NULL
#bench_zea$cpuTime <- bench_zea$cpu.sys + bench_zea$.user
bench_zea$cpuTime <- bench_zea$.user
bench_zea <- rename(bench_zea, c("elapsed"="realTime"))

#average runs
sumBenchmark_zea <- do.call(data.frame, aggregate(. ~ mapper, bench_zea, function(x) c(m = mean(x), s = sd(x) )))

#memory plot
ggplot(sumBenchmark_zea, aes(x=mapper, y=RSS.m)) + 
  geom_bar(stat="identity", fill="forestgreen", alpha=0.7, 
           position=position_dodge()) +
  geom_text(aes(label=round(RSS.m, digits = 2)), vjust=ifelse(sumBenchmark_bra$RSS.s > 0.2, -6.2, -1.3), color="black",
            position = position_dodge(0.9), size=3.5)+
  ylim(0,40) +
  labs(title="Memory benchmark on a 5x simulated Zea mays dataset", x="mapper", y = "Maximum resident set size (RSS) in GB") +
  geom_errorbar(aes(ymin=RSS.m-RSS.s, ymax=RSS.m+RSS.s), width=.2,
                position=position_dodge(.9)) +
  theme_bw()

library(reshape)
#runtime plot
sumRuntimeMeanBenchmark_zea <- sumBenchmark_zea[c('realTime.m','cpuTime.m','mapper')]
sumRuntimeMeanBenchmark_zea <- melt(sumRuntimeMeanBenchmark_zea, id = c("mapper"))
sumRuntimeMeanBenchmark_zea$variable <- revalue(sumRuntimeMeanBenchmark_zea$variable, c("realTime.m"="realTime", "cpuTime.m"="cpuTime"))
sumRuntimeMeanBenchmark_zea <- rename(sumRuntimeMeanBenchmark_zea, c("value"="mean","variable"="measurement"))

sumRuntimeSdBenchmark_zea <- sumBenchmark_zea[c('realTime.s','cpuTime.s','mapper')]
sumRuntimeSdBenchmark_zea <- melt(sumRuntimeSdBenchmark_zea, id = c("mapper"))
sumRuntimeSdBenchmark_zea <- rename(sumRuntimeSdBenchmark_zea, c("value"="sd","variable"="measurement"))

sumRuntimeBenchmark_zea <- cbind(sumRuntimeMeanBenchmark_zea[c('mapper','measurement','mean')], sumRuntimeSdBenchmark_zea[c('sd')])

ggplot(sumRuntimeBenchmark_zea, aes(x=mapper, y=mean, fill=measurement)) + 
  geom_bar(stat="identity", alpha=0.7, 
           position=position_dodge()) + 
  scale_fill_manual(values = c("forestgreen","orange")) +
  geom_text(aes(label=round(mean, digits = 2)), vjust=-1.3, color="black",
            position = position_dodge(0.9), size=3.5)+
  labs(title="Runtime benchmark on a 5x simulated Zea mays dataset", x="mapper", y = "runtime in hours") +
  ylim(0,90) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) +
  theme_bw()
##########################################################
##########################################################
##################################################################
library(RColorBrewer)
library(wesanderson)

#total
bench_ara$gnsize<-135670229
bench_ara$genome<-"Arabidopsis thaliana"
bench_bra$gnsize<-738357821
bench_bra$genome<- "Brassica napus"
bench_sol$gnsize<-727424546
bench_sol$genome <- "Solanum tuberosum"
bench_gly$gnsize<-955377461
bench_gly$genome <- "Glycine max."
bench_zea$gnsize<-2104350183
bench_zea$genome <- "Zea mays"

bench_total<-rbind(bench_ara,bench_bra,bench_sol,bench_gly,bench_zea)

sumbench_total <- do.call(data.frame, aggregate(. ~ mapper+gnsize+genome, bench_total, function(x) c(m = mean(x), s = sd(x) )))
ggplot(sumbench_total, aes(x=gnsize, y=RSS.m)) + 
  geom_point(aes(colour=mapper, size=genome ,shape=genome)) +
  scale_size_manual(values= c(2,2,2,2,2,2,2,2))+
  scale_shape_manual(values=c(16:19,15)) +
  scale_colour_brewer(palette = "Paired") +
  geom_line(aes(x=gnsize, y=RSS.m, group=mapper, color=mapper))+
  labs(title="Memory consumption benchmark on multiple genomes", x="Reference Genome Size in bp", y = "Maximum resident set size (RSS) in GB")+
  ylim(0,40) + 
  xlim(0,2204350183) +
  theme_bw()+
  labs(shape="Reference genome", colour="Mapper")+
  guides(size = FALSE)


##########################################################
##########################################################
sumRuntimeBenchmark_ara$gnsize<-135670229
sumRuntimeBenchmark_ara$genome <-"Arabidopsis thaliana"
sumRuntimeBenchmark_bra$gnsize<-738357821
sumRuntimeBenchmark_bra$genome <-"Brassica napus"
sumRuntimeBenchmark_sol$gnsize<-727424546
sumRuntimeBenchmark_sol$genome <-"Solanum tuberosum"
sumRuntimeBenchmark_gly$gnsize<-955377461
sumRuntimeBenchmark_gly$genome <-"Glycine max."
sumRuntimeBenchmark_zea$gnsize<-2104350183
sumRuntimeBenchmark_zea$genome <-"Zea mays"

sumRuntimeBenchmark_total<- rbind(sumRuntimeBenchmark_ara,sumRuntimeBenchmark_bra,sumRuntimeBenchmark_sol,sumRuntimeBenchmark_gly,sumRuntimeBenchmark_zea)
sumRuntimeBenchmark_total<- sumRuntimeBenchmark_total[sumRuntimeBenchmark_total$measurement==c("cpuTime"),]

ggplot(sumRuntimeBenchmark_total, aes(x=gnsize, y=mean)) + 
  geom_point(aes(colour=mapper, size=mapper,shape=genome)) +
  scale_size_manual (values= c(2,2,2,2,2,2,2,2))+
  scale_shape_manual(values=c(16:19,15)) +
  scale_colour_brewer(palette = "Paired") +
  geom_line(aes(group=paste(measurement,mapper), color=mapper)) +
  labs(title="User Time benchmark on multiple genomes", x="Reference Genome Size in bp", y = "User Time in hours (h)")+
  ylim(0,80) + 
  xlim(0,2204350183)+
  theme_bw()
  
  



