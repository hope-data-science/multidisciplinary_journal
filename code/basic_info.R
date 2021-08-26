
library(pacman)
p_load(tidyverse)

read_csv("data/incites_ra.csv") -> dt

names(dt)

dt %>% 
  select(1,2,ncol(.)) %>% 
  rename(No = `Web of Science Documents`) %>% 
  group_by(Journal) %>% 
  summarise(
    doc_no = sum(No),
    ra_no = n(),
    div = vegan::diversity(No)
  ) %>% 
  arrange(-doc_no) %>% 
  inner_join(
    dt %>% 
      select(1,2,ncol(.)) %>% 
      rename(No = `Web of Science Documents`) %>% 
      group_by(Journal) %>% 
      mutate(
        prop = No/sum(No),
        label = scales::percent(prop,accuracy = .01)
      ) %>% 
      slice_max(prop,n = 3) %>% 
      arrange(Journal,-prop) %>% 
      mutate(id = 1:n()) %>% 
      summarise(
        top_ra = str_c(str_glue("({id}){Name}({label})"),collapse = ";\n")
      ),by = "Journal"
  ) -> basic_info

basic_info %>% 
  setNames(c("期刊","文献总数","学科数量","学科多样性","TOP3学科")) %>% 
  write_excel_csv("data/基本信息.csv")


# https://incites.help.clarivate.com/Content/Indicators-Handbook/ih-normalized-indicators.htm