from nltk.tokenize import word_tokenize,sent_tokenize
from nltk import download
import pymorphy3

import json
import os

download("stopwords")
download('punkt')
download('punkt_tab')

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

"""
Load files:
    1. Исходная коллекция текста (объединения текста ссылки из 3 фактов)
    2. Запросы (3 факты)
    3. Стоп - слова
"""
with open(os.path.join(ROOT_DIR,"raw_files","collections.in"), encoding = "utf8") as f:
  collection = f.read()

with open(os.path.join(ROOT_DIR,"raw_files","stop_words.in"), encoding = "utf8") as f:
  stop_words = f.read()
  stop_words = stop_words.split("\n")
  delimeters = ['.',';',')','(','[',']',',','-','«','…',':','»','—','’','“','„']
  stop_words += delimeters

with open(os.path.join(ROOT_DIR,"raw_files","requests.in"), encoding = "utf8") as f:
  request = f.read().split("\n")

# tokenize collection by sentenses and terms

collection_tokenized = sent_tokenize(collection)
collection_terms = [word_tokenize(sent) for sent in collection_tokenized]

morph = pymorphy3.MorphAnalyzer()
normal_sents = []

for sent in collection_terms:
  normal_sent = []
  for word in sent:
    parsed = morph.parse(word)
    if parsed[0].normal_form not in stop_words:
      normal_sent.append(parsed[0].normal_form)
  normal_sents.append(normal_sent)

terms = list(set([word for sent in normal_sents for word in sent if word not in stop_words]))
term_idx = {t : idx for idx, t in enumerate(terms)}

normal_request = []
for sent in request:
  tokens = word_tokenize(sent)
  parsed = [morph.parse(t) for t in tokens]
  normal_sent = [p[0].normal_form for p in parsed if p[0].normal_form not in stop_words and p[0].normal_form in terms]
  normal_request.append(normal_sent)


# save as json file

with open(os.path.join(ROOT_DIR,"processed","initial_documents.json"),"w", encoding="utf8") as f:
  json.dump(collection_tokenized, f,ensure_ascii=False,indent = 4)

with open(os.path.join(ROOT_DIR,"processed","initial_request.json"),"w", encoding="utf8") as f:
  json.dump(request, f,ensure_ascii=False,indent = 4)

with open(os.path.join(ROOT_DIR,"processed","normalized_documents.json"),"w", encoding="utf8") as f:
  json.dump(normal_sents, f,ensure_ascii=False,indent = 4)

with open(os.path.join(ROOT_DIR,"processed","normalized_request.json"),"w", encoding="utf8") as f:
  json.dump(normal_request, f,ensure_ascii=False,indent = 4)

with open(os.path.join(ROOT_DIR,"processed","term_idx.json"),"w", encoding="utf8") as f:
  json.dump(term_idx, f,ensure_ascii=False,indent = 4)
