import numpy as np
from collections import Counter
from utils import Utils

class Tf(Utils):
  def __init__(self):
     super().__init__()
     pass
  
  def get_tf(self, normal_form, term_idx):
    tf = np.zeros((len(normal_form), len(term_idx)), dtype=np.float64)
    for i, doc in enumerate(normal_form):
        term_count = Counter(doc)
        for term, count in term_count.items():
            if term in term_idx:
                tf[i, term_idx[term]] = count
    return tf

  def __call__(self, normal_form, normal_request, term_idx):
    document_tf = self.get_tf(normal_form, term_idx)
    request_tf = self.get_tf(normal_request, term_idx)

    doc_norms = self.norm(document_tf)
    req_norms = self.norm(request_tf)

    return self.get_relevance(req_norms, doc_norms)