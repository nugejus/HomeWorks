from sentence_transformers import SentenceTransformer
import numpy as np
from utils import Utils

class LaBSE(Utils):
    def __init__(self):
        super().__init__()
        pass

    def __call__(self,initial_requests, initial_documents):
        model = SentenceTransformer('sentence-transformers/LaBSE')
        request_embeddings = model.encode(initial_requests, normalize_embeddings=True)
        document_embeddings = model.encode(initial_documents, normalize_embeddings=True)

        req_norm = self.norm(request_embeddings)
        doc_norm = self.norm(document_embeddings)

        return self.get_relevance(req_norm, doc_norm)