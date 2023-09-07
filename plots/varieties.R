data=read.csv('accessions for plot.csv', sep=';')

library(ggplot2)

data$Population = factor(data$Population, levels=unique(data$Population))

cbPalette=c('#31de5f','#2260d4','#d925c1','#d9d625','#25d9a6','#d97325','#d925d0','#d93a25','#9a25d9','#441b96','#28733b','#287370','#fffd8f','#8f9cff','#82000b','#8a8a8a')
cbPalette=c('#064a87', '#80d4e3', '#40a9c6', '#0f355c', '#daeff0', '#2d8eb8', '#76b5c5', '#abdbe3', '#441b96', '#2260d4','#9a25d9','#8f9cff','#fffd8f','#d925d0','#82000b','#8a8a8a')

ggplot(data, aes(x=Population, y=Count, fill=Subpopulation)) +
  geom_col() + theme_classic() + scale_fill_manual(values=cbPalette)

