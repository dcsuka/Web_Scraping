library(wdman)
library(RSelenium)
library(tidyverse)

selServ <- selenium(
  port = 4446L,
  version = 'latest',
  chromever = '103.0.5060.134', # set to available
)

remDr <- remoteDriver(
  remoteServerAddr = 'localhost',
  port = 4446L,
  browserName = 'chrome'
)

remDr$open()
remDr$navigate("insert URL here")

text_elements <- remDr$findElements("xpath", "//div/div/div/div[2]/div/span")

sapply(text_elements, function(x) x$getElementText()) %>%
  unlist() %>%
  as_tibble_col("results") %>%
  filter(str_length(results) > 15)

# # A tibble: 6 × 1
#   results                                                                                                                        
#   <chr>                                                                                                                          
# 1 "The meaning of HI is —used especially as a greeting. How to use hi in a sentence."                                            
# 2 "Hi definition, (used as an exclamation of greeting); hello! See more."                                                        
# 3 "A friendly, informal, casual greeting said upon someone's arrival. quotations ▽synonyms △. Synonyms: hello, greetings, howdy.…
# 4 "Hi is defined as a standard greeting and is short for \"hello.\" An example of \"hi\" is what you say when you see someone. i…
# 5 "hi synonyms include: hola, hello, howdy, greetings, cheerio, whats crack-a-lackin, yo, how do you do, good morrow, guten tag,…
# 6 "Meaning of hi in English ... used as an informal greeting, usually to people who you know: Hi, there! Hi, how are you doing? …
