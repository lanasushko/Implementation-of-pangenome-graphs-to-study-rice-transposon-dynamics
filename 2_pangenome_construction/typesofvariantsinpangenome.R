setwd("~/2 CRAG arroz/pangenome description/variants")

count=read.table('variants_count.txt', sep='\t', header=T)

library(ggplot2)
library(ggh4x)
library(forcats)

tips=data.frame(svtype=c('Insertion','Deletion','Breakend','Duplication','Tandem Duplication','Inversion','Interspersed Duplication'),
                count=c(28343,9647,0,0,0,0,0))

ggplot() +
  geom_col(count, mapping=aes(x=fct_reorder(Type_of_variant, Count), y=Count)) + theme_classic() + xlab('Type of variant') + ylab('Number of variants') +
  scale_x_discrete(limits=rev) + geom_text(count, mapping=aes(x=fct_reorder(Type_of_variant, Count), y=Count, label=Count),nudge_y=3000) +
  geom_col(tips, mapping=aes(x=svtype,y=count), fill='blue')

TEscount=read.table('TEs_count.txt', sep='\t', header=T)
TEscount$Subclass = factor(TEscount$Subclass, levels=c('LTR','Non-LTR','TIR','MITE','Helitron')) 


ggplot(TEscount, aes(x=Subclass, y=Count, fill=Superfamily, label=Count)) +
  geom_col() + theme_classic() + geom_text() + scale_x_discrete(labels=c('LTR','Non-LTR','TIR','MITE','Helitron','Other')) +
  ylab('Number of TIPs')


#paste0(Subclass, "&", Class)
#+ guides(x = ggh4x::guide_axis_nested(delim = "&"))

