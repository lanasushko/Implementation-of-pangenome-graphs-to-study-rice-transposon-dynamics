setwd("~/2 CRAG arroz/pangenome description/SV lengths")

data=read.table('SV_lengths.lengths', header=T)

library(ggplot2)

ggplot(data.frame(data), aes(Len))+ facet_grid(rows = vars(Type_var)) +   # Histogram with logarithmic axis
  geom_histogram(bins = 100) + scale_x_log10() + xlab('Length (bp)')

