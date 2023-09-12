data=data.frame(SV_calling_tool=c('SVIM','SVIM','MUM&Co','MUM&Co','SyRI','SyRI','Assemblytics','Assemblytics'),
                type_detected=c('TIPs','Other SVs','TIPs','Other SVs','TIPs','Other SVs','TIPs','Other SVs'),
                count=c(6223,7483,4564,3006,2195,6426,491,1193),
                TIPs_dels_detected=c(6223,4564,2195,491),
                SVs_dels_detected=c(13706,7570,133509,1684),
                nonTIP_SVs_dels_detected=c(7483,3006,131314,1193))

library(ggplot2)
library(ggbreak) 

data$method=factor(data$method, levels=unique(data$method))

ggplot(data, aes(x=SV_calling_tool, y=count, fill=type_detected)) +
  geom_col(position='stack') + theme_classic() +
  #scale_y_break(c(15000, 130000)) + 
  xlab("SV calling tool") + 
  ylab("Number of deletions detected")  + guides(fill=guide_legend(title=element_blank()))
  #scale_fill_manual(values = c("",))
