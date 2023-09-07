data=data.frame(method=c('Known set','"TEMP2",linear genome','"TEMP2",linear genome', '"vg call", graph genome','"vg call", graph genome'),
                filter=c('Known set','3 supporting reads', '5 supporting reads','3 supporting reads', '5 supporting reads'),
                countTIPs=c(3776,5447,3935,4702,4038),
                countknownTIPs=c(3776,2184,1814,2804,2683)
)


library(ggplot2)

data$method=factor(data$method, levels=unique(data$method))

ggplot(data) +
  geom_col(aes(x=method, fill=filter, y=countTIPs), position='dodge') +
  geom_col(aes(x=method, fill=filter, y=countknownTIPs), position='dodge', color='blue') +
  ylab('Total number of detected TIPs') +
  xlab('Method') + guides(fill=guide_legend(title="Filter")) +
  theme_classic()
