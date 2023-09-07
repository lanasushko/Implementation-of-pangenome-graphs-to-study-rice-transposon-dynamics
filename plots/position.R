setwd("~/2 CRAG arroz/pangenome description/position")
freqs=read.csv('png_75_freqs.csv', sep=';')

library(RColorBrewer)
library(ggplot2)
library(cowplot)
theme_set(theme_cowplot())
library(data.table)
library(plyr)
library(dplyr)
library(scales)
library(grid)
library(forcats)
library(ggbreak) 
library(ggpubr)


freqs=freqs[!grepl("Centro/tandem", freqs$TE_type_std),]
freqs=freqs[!grepl("Satellite/rice", freqs$TE_type_std),]
freqs=freqs[!grepl("Evirus", freqs$TE_type_std),]
freqs=freqs[!grepl("unknown", freqs$TE_type_std),]
freqs=freqs[!grepl("Helitron", freqs$TE_type_std),]
freqs=freqs[!grepl("LINE", freqs$TE_type_std),]
freqs=freqs[!grepl("SINE", freqs$TE_type_std),]
freqs=freqs[!grepl("LTR/Other", freqs$TE_type_std),]
freqs=freqs[!grepl("#N/D", freqs$TE_type_std),]
freqs=na.omit(freqs)

freqs$TE_type_std=sub("Centro/tandem", "Other", freqs$TE_type_std)
freqs$TE_type_std=sub("Satellite/rice", "Other", freqs$TE_type_std)
freqs$TE_type_std=sub("Evirus", "Other", freqs$TE_type_std)
freqs$TE_type_std=sub("unknown", "Other", freqs$TE_type_std)
freqs$TE_type_std=sub("TIR/nona", "TIR/non-autonomous", freqs$TE_type_std)
freqs$TE_type_std=sub("TIR/auto", "TIR/autonomous", freqs$TE_type_std)

freqs$TE_type_std=factor(freqs$TE_type_std, levels=c('TIR/auto','TIR/nona','MITE','Helitron','LTR/Copia','LTR/Gypsy','LTR/Other','LINE','SINE'))


ggplot(freqs, aes(x=pos))+ facet_wrap(~chr, ncol=2, drop=T, strip.position='right', dir='v') +
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('Number of variants') + scale_x_continuous(name='Position') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  guides(fill=guide_legend(title="TE type")) +
  theme(text = element_text(size = 20))

ggplot(freqs, aes(x=pos, group=TE_type_std, color=TE_type_std))+ facet_wrap(~chr, ncol=2, drop=T, strip.position='right', dir='v') +
  stat_density(geom="line", position="identity")+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('Number of variants') + scale_x_continuous(name='Position') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  guides(fill=guide_legend(title="TE type")) +
  theme(text = element_text(size = 20)) +
  geom_hline(yintercept = 0, color = "white")

#per chromosome TE content
ggplot(freqs, aes(x=chr, fill=TE_type_std)) +
  geom_bar(position="stack") + scale_x_discrete(labels=c(1,2,3,4,5,6,7,8,9,10,11,12)) +
  xlab('Chromosome') +ylab('Number of TIPs')





chr1=ggplot(freqs[freqs$chr=='Chr01',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('Number of variants') + xlab('Position') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 43270923) + geom_vline(xintercept = 16700000, linetype="dotted", linewidth=1) +
  theme(text = element_text(size = 20))
  
chr2=ggplot(freqs[freqs$chr=='Chr02',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 35937250) + geom_vline(xintercept = 13600000, linetype="dotted", linewidth=1) +
 theme(text = element_text(size = 20))

chr3=ggplot(freqs[freqs$chr=='Chr03',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 36413819) + geom_vline(xintercept = 19400000, linetype="dotted", linewidth=1) +
theme(text = element_text(size = 20))

chr4=ggplot(freqs[freqs$chr=='Chr04',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 35502694)+ geom_vline(xintercept = 9700000, linetype="dotted", linewidth=1) +
theme(text = element_text(size = 20))

chr5=ggplot(freqs[freqs$chr=='Chr05',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 29958434)+ geom_vline(xintercept = 12400000, linetype="dotted", linewidth=1) +
theme(text = element_text(size = 20))

chr6=ggplot(freqs[freqs$chr=='Chr06',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 31248787)+ geom_vline(xintercept = 15300000, linetype="dotted", linewidth=1) +
theme(text = element_text(size = 20))

chr7=ggplot(freqs[freqs$chr=='Chr07',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 29697621)+ geom_vline(xintercept = 12100000, linetype="dotted", linewidth=1) +
theme(text = element_text(size = 20))

chr8=ggplot(freqs[freqs$chr=='Chr08',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 28443022)+ geom_vline(xintercept = 12900000, linetype="dotted", linewidth=1) +
theme(text = element_text(size = 20))

chr9=ggplot(freqs[freqs$chr=='Chr09',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 23012720)+ geom_vline(xintercept = 2800000, linetype="dotted", linewidth=1) +
theme(text = element_text(size = 20))

chr10=ggplot(freqs[freqs$chr=='Chr10',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  labs(fill='Repeat class') + xlim(0, 23207287)+ geom_vline(xintercept = 8200000, linetype="dotted", linewidth=1) +
theme(text = element_text(size = 20))

chr11=ggplot(freqs[freqs$chr=='Chr11',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  guides(fill=guide_legend(title="TE type")) + xlim(0, 29021106)+ geom_vline(xintercept = 12000000, linetype="dotted", linewidth=1) +
  theme(text = element_text(size = 20))

chr12=ggplot(freqs[freqs$chr=='Chr12',], aes(x=pos, group=TE_type_std, color=TE_type_std))+ 
  geom_density()+
  #theme(strip.background = element_blank(),strip.text.x = element_blank(), strip.text.y=element_blank(),axis.text=element_text(size=10)) + 
  ylab('') + xlab('') + 
  scale_y_continuous( breaks=scales::pretty_breaks(2), limits=c(0,NA)) +
  guides(fill=guide_legend(title="TE type")) + xlim(0, 27531856)+ geom_vline(xintercept = 11900000, linetype="dotted", linewidth=1) +
  theme(text = element_text(size = 20))

ggarrange(chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12, common.legend=T, legend='right')
