import numpy as np
from model import Model

class FasttextIDF(Model):
    def __init__(self):
        super().__init__()
        pass

    def __call__(self, normalized_requests, normalized_documents, fasttext_vectors, bigrams, term_idx):
        request_vectors = []
        for request in normalized_requests:
            request_vectors.append(self._text_to_vec(request, fasttext_vectors, bigrams, term_idx))

        document_vectors = []
        for document in normalized_documents:
            document_vectors.append(self._text_to_vec(document,fasttext_vectors,bigrams, term_idx))

        document_vectors, request_vectors = np.array(document_vectors), np.array(request_vectors)

        df = np.sum(document_vectors > 0, axis=0)
        idf = np.log10(len(normalized_documents) / (df + 1))

        request_vectors = idf * request_vectors
        document_vectors = idf * document_vectors

        return self.get_relevance(self.norm(request_vectors), self.norm(document_vectors))