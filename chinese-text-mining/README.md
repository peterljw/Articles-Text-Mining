# Articles-Text-Mining

The project begins with scraping about 300 articles from [Synced AI Dailies](https://www.jiqizhixin.com/dailies), a Chinese artificial intelligence blog, and the text contents are then pre-processed into text corpus using stopwords. Using the package **jiebaR**, text data are analyzed to extract the most frequent words and the keywords in each article, which are saved into the csv file, article-keywords.csv. In addition, the last part of the script extracts a list of keywords from all articles and generates word clouds based on each word's keyword score. To create one of the word clouds, an image mask is created from Synced's logo to generate a word cloud which visualizes the logo.

## Built With

* [RSelenium](https://cran.r-project.org/web/packages/RSelenium/index.html) - R package used for dynamic web scraping 
* [Rvest](https://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/) - R package used for static web scraping
* [tidyverse](https://www.tidyverse.org/) -  An opinionated collection of R packages designed for data science
* [jiebaR](https://cran.r-project.org/web/packages/jiebaR/index.html) -  R package for Chinese text segmentation, keyword extraction, speech tagging, and other NLP techniques

## Authors

* **Jiawei Long** - [peterljw](https://github.com/peterljw)
