import numpy as np
from model import Model

class Tf_Idf(Model):
    def __init__(self):
        super().__init__()
        pass

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




