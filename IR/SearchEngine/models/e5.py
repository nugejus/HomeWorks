from sentence_transformers import SentenceTransformer
from model import Model

class E5(Model):
    def __init__(self):
        pass

    def __call__(self, initial_requests, initial_documents):
        model = SentenceTransformer('intfloat/multilingual-e5-small')
        request_embeddings = model.encode(initial_requests, normalize_embeddings=True)
        document_embeddings = model.encode(initial_documents, normalize_embeddings=True)

        req_norm = self.norm(request_embeddings)
        doc_norm = self.norm(document_embeddings)

        return self.get_relevance(req_norm, doc_norm)