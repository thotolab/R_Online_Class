
library(tidyverse)
library(tydir)
data(who)

who1 <- who %>% 
  gather (
    new_sp_m014:newrel_f65, key = "key",
    value = "cases",
    na.rm = TRUE
  )

who2 <- who1 %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))

who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
  
who4 <- who3 %>% select(-new,-iso2,-iso3)

who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)

