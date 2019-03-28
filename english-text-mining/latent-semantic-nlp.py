import nltk
import re
import pandas as pd
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.decomposition import TruncatedSVD
import timeit
import glob


# load article and clean \r and \n tags
txt_files = glob.glob('./*.txt')
articles = []
for txt in txt_files:
      article = str(open(txt, 'rb').read())
      article = article[1:].replace("\\r", "").replace("\\n", "")
      articles.append(article)

# define stop words
stopset = set(stopwords.words('english'))

########## TF-IDF Vectorizing ##########
vectorizer = TfidfVectorizer(stop_words=stopset,
                             use_idf=True, ngram_range=(1, 3))
X = vectorizer.fit_transform(articles)

########## LSA ##########
lsa = TruncatedSVD(algorithm='randomized', n_components=5, n_iter=100,
                   random_state=None, tol=0.0)
lsa.fit(X)
terms = vectorizer.get_feature_names()
output = [None]*5
for i, comp in enumerate(lsa.components_):
      termsInComp = zip (terms, comp)
      sortedTerms = sorted (termsInComp, key=lambda x: x[1], reverse=True) [:10]
      output[i] = list(sortedTerms)
      print("Article %d:" % (i+1))
      for term in sortedTerms:
            print(term[0])
      print("\n")
labels = ['word', 'score']
for article, out in zip(txt_files, output):
      df = pd.DataFrame.from_records(out, columns=labels)
      article = article[2:len(article)-4]
      df.to_csv(article + ".csv")
      
