from model import Model

class Fasttext(Model):
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
        
        return self.get_relevance(self.norm(document_vectors), self.norm(request_vectors))
