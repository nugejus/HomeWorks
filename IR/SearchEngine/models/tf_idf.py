import numpy as np
from collections import Counter
from utils import Utils

class Tf_Idf(Utils):
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
        document_tf = self.get_tf(normal_form,term_idx)
        request_tf = self.get_tf(normal_request,term_idx)

        df = np.sum(document_tf > 0, axis=0)
        idf = np.log10(len(normal_form) / df)

        tf_idf_document = idf * document_tf
        tf_idf_request = idf * request_tf

        doc_norms = self.norm(tf_idf_document)
        req_norms = self.norm(tf_idf_request)

        return self.get_relevance(req_norms, doc_norms)




