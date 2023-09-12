setwd("~/2 CRAG arroz/variant effects")

var_rate=read.csv('snpeff_stats_variationrate.csv', sep=',')
SV_eff_imp=read.csv('snpeff_stats_SVs_effectsbyimpact.csv', sep=',')
TIP_eff_imp=read.csv('snpeff_stats_TIPs_effectsbyimpact.csv', sep=',')
effect_type=read.csv('snpeff_stats_effectstype.csv', sep=',')
effect_region=read.csv('snpeff_stats_effectregion.csv', sep=',')



library(ggplot2)
library(dplyr)
library(ggpubr)
library(ggrepel)

## change and rate
rate=function(x) 1/x
var_rate$Change_rate=as.numeric(lapply(var_rate$Change_rate, rate))

var=ggplot() +
  geom_col(data=var_rate,aes(x=factor(Chromosome),y=Changes, fill=Type)) + xlab('Chromosome') + theme_classic() +
  geom_line(data=var_rate,aes(x=factor(Chromosome),y=Change_rate*10000000, group=Type, color=Type)) + scale_color_manual(values=c('red','blue')) +
  scale_y_continuous(sec.axis=sec_axis(trans=~./10000000,name='Change rate'))

len=ggplot() +
  geom_col(data=var_rate[var_rate$Type == ' SV',],aes(x=factor(Chromosome),y=-Length)) + theme_classic() +
  scale_x_discrete(position = "top") + 
  theme(axis.text.x =element_blank(), axis.ticks.x=element_blank(),axis.title.y=element_text(color='white'))+ xlab('')+
  scale_y_continuous(limits=c(-50000000,0),labels = abs) + ylab('Chromosome size')

ggarrange(var,len, nrow=2)

## effects by impact 
# Get the positions (for % markers)
df2 <- SV_eff_imp %>%
  mutate(csum = rev(cumsum(rev(Count))),
         pos = Count/2 + lead(csum, 1),
         pos = if_else(is.na(pos), Count/2, pos))
df3 <- TIP_eff_imp %>%
  mutate(csum = rev(cumsum(rev(Count))),
         pos = Count/2 + lead(csum, 1),
         pos = if_else(is.na(pos), Count/2, pos))

imp1=ggplot(SV_eff_imp, aes(x="", y=Count, fill=Type)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0, direction=-1) + theme_void() +
  geom_label_repel(data = df2,
                  aes(y = pos, label = Percent),
                  segment.color='grey',
                  size = 4.5, nudge_x = 1, show.legend = FALSE) +
  ggtitle('Other SVs')

imp2=ggplot(TIP_eff_imp, aes(x="", y=Count, fill=Type)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0, direction=-1) + theme_void() +
  geom_label_repel(data = df3,
                   aes(y = pos, label = Percent),
                   segment.color='grey',
                   size = 4.5, nudge_x = 1, show.legend = FALSE) +
  ggtitle('TIPs')

ggarrange(imp1,imp2,common.legend = T)

## effects type
ggplot() +
  geom_col(data=effect_type,aes(x=Type_var,y=Count, fill=Type_eff)) + theme_classic()

effect_transcript=effect_type[effect_type$Type_eff  %in% c(  "3_prime_UTR_truncation ", "3_prime_UTR_variant ", "5_prime_UTR_truncation ", "5_prime_UTR_variant ", "exon_loss_variant ", "feature_ablation ", "intragenic_variant ", "non_coding_transcript_exon_variant ", "non_coding_transcript_variant ", "transcript_ablation " ),]

tr=ggplot() +
  geom_col(data=effect_transcript,aes(x=Type_eff,y=Count, fill=Type_var)) + theme_classic() + coord_flip() + ggtitle('A: Transcript variants')

effect_frame=effect_type[effect_type$Type_eff  %in% c("conservative_inframe_deletion ","conservative_inframe_insertion ","disruptive_inframe_deletion ","disruptive_inframe_insertion ","frameshift_variant "),]

fr=ggplot() +
  geom_col(data=effect_frame,aes(x=Type_eff,y=Count, fill=Type_var)) + theme_classic() + coord_flip() + ggtitle('B: Frame variants')

effect_startstop=effect_type[effect_type$Type_eff  %in% c("start_lost ","start_retained_variant ","stop_gained ","stop_lost ","stop_retained_variant "),]

stst=ggplot() +
  geom_col(data=effect_startstop,aes(x=Type_eff,y=Count, fill=Type_var)) + theme_classic() + coord_flip() + ggtitle('C: Start/Stop variants')

effect_splice=effect_type[effect_type$Type_eff  %in% c("splice_acceptor_variant ","splice_donor_variant ","splice_region_variant "),]

spl=ggplot() +
  geom_col(data=effect_splice,aes(x=Type_eff,y=Count, fill=Type_var)) + theme_classic() + coord_flip() + ggtitle('D: Splice region variants')

effect_genefusion=effect_type[effect_type$Type_eff  %in% c("bidirectional_gene_fusion ","gene_fusion "),]

gf=ggplot() +
  geom_col(data=effect_genefusion,aes(x=Type_eff,y=Count, fill=Type_var)) + theme_classic() + coord_flip() + ggtitle('E: Gene fusion variants')

ggarrange(tr,fr,stst,spl,gf,common.legend = T)

## effect region

gene_flank=effect_region[effect_region$Region  %in% c("DOWNSTREAM ","GENE ","UPSTREAM ","INTERGENIC "),]
gene_flank$Region = factor(gene_flank$Region, levels=c("DOWNSTREAM ","GENE ","UPSTREAM ","INTERGENIC "))

geneflank=ggplot(data=gene_flank,aes(x=Region,y=Count, fill=Type_var, label=Percent)) +
  geom_col() + theme_classic() + ggtitle('A') + #theme(axis.text.x = element_text(size=15, angle=90,hjust=0.95,vjust=0.2))
  coord_flip() + geom_text(aes(color=Type_var)) + scale_color_manual(values=c('red','blue')) +
  ylab('Number of variants')

transcr=effect_region[effect_region$Region  %in% c("UTR_5_PRIME ","EXON ","INTRON ","UTR_3_PRIME "),]
transcr$Region = factor(transcr$Region, levels=c("UTR_5_PRIME ","EXON ","INTRON ","UTR_3_PRIME "))

transcrplot=ggplot(data=transcr,aes(x=Region,y=Count, fill=Type_var, label=Percent)) +
  geom_col() + theme_classic() + ggtitle('B') + #theme(axis.text.x = element_text(size=15, angle=90,hjust=0.95,vjust=0.2))
  coord_flip() + geom_text(aes(color=Type_var)) + scale_color_manual(values=c('red','blue'))+
  ylab('Number of variants')
ggarrange(geneflank,transcrplot,common.legend = T)

