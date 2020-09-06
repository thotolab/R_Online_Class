library(tidyverse)
library(tidytext)
library(tidyr)


fn <- system.file("extdata", "RD-Mortality-Report_2015-18-180531.pdf", package="dslabs")
system2("open", args = fn)

txt <- pdf_text(fn)
txt <- txt[9]
x <- str_split(txt,"\n")
s <- x[[1]]
str_trim(s)
header_index <- str_which(s,"2015")[1]
header <- s[header_index]
tmp <- str_split(s[header_index], "\\s+", simplify = TRUE)
month <- tmp[1]
header <- tmp[-1]

tail_index <- str_which(s,"Total")

n <- str_count(s,"\\d+")

out <- c(1:header_index, which(n==1), tail_index:length(s))
s <- s[-out]
s <- str_remove_all(s, "[^\\d\\s]")
s <- str_split_fixed(s, "\\s+", n = 6)[,2:6]
tab <- s %>% 
  as_data_frame() %>% 
  setNames(c("day", header)) %>%
  mutate_all(as.numeric)

tab <- tab %>% gather(year, deaths, -day) %>%
  mutate(deaths = as.numeric(deaths))
tab

tab %>% filter(year != "2018") %>% 
  ggplot(aes(x = day, y = deaths)) + geom_line(aes(color = year)) + geom_vline(xintercept = 20)
