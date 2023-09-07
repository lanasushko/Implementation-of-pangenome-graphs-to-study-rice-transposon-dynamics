setwd("~/2 CRAG arroz/rarefaction")
data=read.csv('rarefaction_SVs_jul13.csv', sep=';')
dataTIPs=read.csv('rarefaction_TIPs_jul13.csv', sep=';')

library(ggplot2)

ggplot(data, aes(x=genome_number, y=SVs_acu)) +
  geom_rect(aes(xmin = 0, xmax = 44, ymin = 0, ymax = 179555),fill = "#d6d6d6") +
  geom_rect(aes(xmin = 44, xmax =55, ymin = 0, ymax = 179555),fill = "#e8e8e8") +
  geom_rect(aes(xmin = 55, xmax =69, ymin = 0, ymax = 179555),fill = "#f5f7f6") +
  geom_line() + geom_point(aes(color=variety)) + theme_classic() + scale_x_continuous(breaks = seq(from = 0, to = 75 , by = 5)) +
  #theme(axis.text.x = element_text(colour = data$variety))
  scale_color_manual(values=c('#f69c33','#6c56a2','#78a643','#5da1d5','violet','brown','yellow')) +
  ylab('Number of SVs') + geom_text(aes(label=real_genome_number), nudge_x =-1, nudge_y =4000, check_overlap = T) +
  xlab('Number of genomes')

ggplot(dataTIPs, aes(x=genome_number, y=TIPs_acu)) +
  geom_rect(aes(xmin = 0, xmax = 37, ymin = 0, ymax = 40000),fill = "#d6d6d6") +
  geom_rect(aes(xmin = 37, xmax =50, ymin = 0, ymax = 40000),fill = "#e8e8e8") +
  geom_rect(aes(xmin = 50, xmax =68, ymin = 0, ymax = 40000),fill = "#f5f7f6") +
  geom_line() + geom_point(aes(color=variety)) + theme_classic() + scale_x_continuous(breaks = seq(from = 0, to = 75 , by = 5)) +
  #theme(axis.text.x = element_text(colour = data$variety))
  scale_color_manual(values=c('#f69c33','#6c56a2','#78a643','#5da1d5','violet','brown','yellow')) +
  ylab('Number of TIPs') + geom_text(aes(label=real_genome_number), nudge_x =-1, nudge_y =1000, check_overlap = T) +
  xlab('Number of genomes')
