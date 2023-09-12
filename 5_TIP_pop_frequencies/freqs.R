setwd("~/2 CRAG arroz/pangenome description/freqs")

freqs=read.csv('png_75_freqs.csv', sep=';')
freqsnoflip=read.csv('png_75_freqs_delnoflip.csv', sep=';')

library(ggplot2)


freqs=freqs[!grepl("Centro/tandem", freqs$TE_type_std),]
freqs=freqs[!grepl("Satellite/rice", freqs$TE_type_std),]
freqs=freqs[!grepl("Evirus", freqs$TE_type_std),]
freqs=freqs[!grepl("unknown", freqs$TE_type_std),]
freqs=freqs[!grepl("None", freqs$TE_type_std),]
freqs=freqs[!grepl("SINE", freqs$TE_type_std),]
freqs=freqs[!grepl("LINE", freqs$TE_type_std),]
freqs=freqs[!grepl("Helitron", freqs$TE_type_std),]

freqs$TE_type_std=factor(freqs$TE_type_std, levels=c('TIR/auto','TIR/nona','MITE','Helitron','LTR/Copia','LTR/Gypsy','LTR/Other','LINE','SINE'))
freqs$TE_type_std=factor(freqs$TE_type_std, levels=c('TIR/auto','TIR/nona','MITE','Helitron','LTR/Copia','LTR/Gypsy','LINE','SINE'))


ggplot(freqsnoflip, aes(x=freq)) + geom_histogram() + facet_wrap(~SVTYPE, ncol=2, scales='free_y', drop=T, strip.position='top')+
  ylab('Number of SVs') + xlab('Frequency in the pangenome') + theme_bw()
ggplot(freqs, aes(x=freq, fill=TE_type_std)) + geom_histogram() + facet_wrap(~TE_type_std, nrow=4, scales='free_y', drop=T, strip.position='top', dir='v') +
  ylab('Number of TIPs') + xlab('Frequency in the pangenome') + theme_bw()
