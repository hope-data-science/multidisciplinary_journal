
library(pacman)
p_load(tidyverse)
read_csv("data/incites_ra.csv") -> dt
read_csv("data/Baseline.csv") %>% na.omit() %>% 
  select(Name,total_No = `Web of Science Documents`)-> df

# sorted by percentile sd
dt %>% select(1,2,contains("Percentile"),ncol(.)) %>% 
  rename(No = `Web of Science Documents`,Percentile = `Average Percentile`) %>% 
  inner_join(df) %>% 
  mutate(prop = No/total_No) %>%
  group_by(Journal) %>% 
  mutate(impact_var = sd(Percentile)) %>% 
  ungroup() %>% 
  mutate(Journal = reorder(Journal,impact_var)) %>% 
  ggplot(aes(Journal,Percentile)) +
  geom_jitter(aes(color = Journal,size = prop),alpha = .5) + 
  geom_violin(aes(fill = Journal),alpha = .2,size = .8,
              draw_quantiles = c(0.25, 0.5, 0.75))+
  geom_hline(yintercept = 50,linetype = "dashed",color = "red") +
  scale_color_brewer(palette = "Set1") + 
  scale_fill_brewer(palette = "Set1") + 
  labs(x = NULL,y = "\nAverage Percentile") +
  coord_flip() + 
  theme_classic() +
  theme(legend.position = "none")

# https://incites.help.clarivate.com/Content/Indicators-Handbook/ih-normalized-indicators.htm#Average  
