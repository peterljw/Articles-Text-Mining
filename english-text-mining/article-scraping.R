library(rvest)
library(tidyverse)

topic_list <- c("Data_science","Machine_learning", "Artificial_intelligence", "Natural_language_processing", "Computer_vision")

get_content <- function(topic) {
  page <- read_html(paste('https://en.wikipedia.org/wiki/', topic, sep = ""))
  content <- page %>%
    html_nodes("p") %>%
    html_text()
  return(content)
}

for(topic in topic_list) {
  content <- unlist(get_content(topic))
  content <- paste(content, sep="\n", collapse="") 
  content <- gsub("\\", "", content, fixed = TRUE)
  write.table(content, paste(topic,".txt", sep=""), col.names = F, row.names = F, quote = F)
}
