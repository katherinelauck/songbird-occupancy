##### Produce figures for songbird occupancy publication
# Author: Katherine Lauck
# Last updated: 19 May 2020
#
# This script builds figures for use in Spring 2020 Conservation Ecology term paper and eventual publication.
# 
# Dependencies
library(tidyverse)
library(rio)

load("results/jags/ssom_2018_Vintf_short.rdata")
colnames(res$BUGSoutput$summary)
cols<-c('mean', '2.5%','97.5%','Rhat','n.eff')
summ<-res$BUGSoutput$summary

vars<-rownames(summ)

summ[grep("mu", vars),cols]
summ[grep("p", vars),cols]
R2jags::traceplot(res$BUGSoutput,varname = grep('mu',vars,value = T))


# later can be repurposed to compare various sps' lambda.dr.com. Need to figure out how to label boxes with just an index like in Danny's graph. But maybe just having no axes is fine too?

# figure with boxplots of distance to road effect ordered by mean effect

fig.data <- as_tibble(res$BUGSoutput$sims.matrix[,grep('^lambda.dr\\[',vars,value = T)]) %>%
pivot_longer(names_to = "param",cols = all_of(colnames(.))) %>%
  mutate(param = fct_reorder(param,
                             value,
                             .fun = 'mean'),
         commercial = factor(rep(dd$data$commercial,
                                 length.out = length(fig.data$param))))
fig.data %>%
  ggplot(mapping = aes(y = value,x = param,fill = commercial)) +
  geom_boxplot()+
  # coord_flip()+
  labs(
    x = "Species ordered by mean simulated effect of distance to roads",
    y = "Simulated value"
  ) +
  # scale_x_discrete(labels = c(seq(1:15))) +
  theme_classic()

# filter out species with detections greater or equal to 10

pc <- import(paste0('results/data/pointCountMaster.csv'))

n.detect <- pc %>%
  group_by(species) %>%
  summarize(n()) %>%
  arrange(desc(`n()`))

  
