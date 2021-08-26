

library(pacman)
p_load(tidyverse)

dir("data/incites",full.names = T) -> fn

import_data = function(x){
  read_csv(x) %>% 
    na.omit() %>% 
    mutate(Journal = str_extract(x,"(?<=\\/)[^\\/]+(?=\\.csv)"))
}

lapply(fn,import_data) %>% 
  bind_rows() -> dt

write_csv(dt,"data/incites_ra.csv")

# str_extract("data/incites/National Science Review.csv","(?<=\\/)[^\\/]+(?=\\.csv)")

# Exported date  Aug 25, 2021. 
# InCites dataset updated  2021-07-30. Includes Web of Science content indexed through 2021-06-30. 
