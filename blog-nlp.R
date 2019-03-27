library(RSelenium)
library(rvest)
library(tidyverse)
require(RSelenium)
library(stringr)
library(tmcn)
library(jiebaR)
library(rio)
library(wordcloud2)
devtools::install_github("lchiffon/wordcloud2", force=T)

# Initial Setup
driver <- rsDriver()
remDr <- driver$client
remDr$getStatus
# Sys.setlocale(category = "LC_CTYPE", locale = "chs")

remDr$navigate("https://www.jiqizhixin.com/dailies")
Sys.sleep(5)
page <- read_html(remDr$getPageSource()[[1]])
load_button <- remDr$findElement(using = 'xpath', "//*[@id='js-has-modal']/div[2]/div/div/span[1]/div/div[3]/a")
daily_list <- page %>%
  html_nodes(".daily-every__list")

while(length(daily_list) < 17) {
  page <- read_html(remDr$getPageSource()[[1]])
  Sys.sleep(3)
  daily_list <- page %>%
    html_nodes(".daily-every__list")
  load_button$clickElement()
}

selected_daily <- daily_list[(length(daily_list)-9):(length(daily_list)-2)]

titles <- selected_daily %>%
  html_nodes(".js-open-modal") %>%
  html_text()
articles <- selected_daily %>%
  html_nodes(".daily__content") %>%
  html_text()

# Terminate driver
remDr$close()
driver$server$stop()

df <- data.frame("Title" = titles, "Article" = articles, stringsAsFactors=FALSE)
saveRDS(df, "content.RDS")

# text mining
key_seg <- worker("keywords", topn = 10)

# extract the most frequent/key words in each article
keyword <- c()
for(i in 1:nrow(df)) {
  words <- keywords(df$Article[i], key_seg)
  for(j in 1:length(words)){
    words[j] <- paste(words[j], names(words)[j], sep=": ")
  }
  keyword <- c(keyword, paste(words, collapse="; "))
}
df$Keyword <- keyword
write.csv(df, "output.csv")

# keywords of the week
all_seg <- worker("keywords", topn = 600)
all_content <- c(unlist(titles), unlist(articles))
all_keywords <- keywords(paste(all_content, collapse = ''), all_seg)

# wordcloud
cloud_df <- data.frame("word" = all_keywords, "freq" = as.numeric(names(all_keywords)), stringsAsFactors = F)
cloud_df <- cloud_df[-c(1,2,5,6,7,8,12,25,33),]
wordcloud2(cloud_df[c(1:120),], fontFamily = "Î¢ÈíÑÅºÚ", maxRotation = pi/2, minRotation = pi/2, rotateRatio = 0.3)
wordcloud2(cloud_df, figPath = "synced.png", fontFamily = "Î¢ÈíÑÅºÚ", color = "dimgrey")
