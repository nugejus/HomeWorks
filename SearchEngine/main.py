import os

from models import Tf, Tf_Idf, Fasttext, FasttextIDF, E5, LaBSE
from load_data import LoadData
from out_result import *

initial_documents = LoadData().init_doc()
initial_requests = LoadData().init_req()
normalized_documents = LoadData().normal_doc()
normalized_requests = LoadData().normal_req()

term_idx = LoadData().term_idx()
bigrams = LoadData().load_bigram()
fast_vector = LoadData().fasttext_vector()

model = FasttextIDF()

relevance = model(normalized_documents, normalized_requests, fast_vector, bigrams, term_idx)

for j, r in enumerate(relevance):
  file_name = "request" + str(j) + '.out'
  file_name = os.path.join("out", file_name)
  init_file(file_name)

  out_file(file_name, initial_requests[j])
  out_file(file_name, "="*40)

  for k,(i,weight) in enumerate(r[:10]):
    text = f"{k + 1} ({round(weight,3)}) {initial_documents[i]}"
    out_file(file_name,text)
  print("\n")