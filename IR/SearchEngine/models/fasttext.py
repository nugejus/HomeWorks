import re
import numpy as np
from utils import Utils

class Fasttext(Utils):
    def __init__(self):
        super().__init__()
        pass

    def _bigram_combination(self, iterable):
        for i in range(len(iterable) - 1):
            yield iterable[i:i+2]

    def _bigram_mean_vector(self, word, bigrams):
        word = list(re.sub(r'[^\w]', '', word))
        vec, i = np.zeros(300), 0
        for bi in self._bigram_combination(word):
            bi = "".join(bi)
            if bi in bigrams.keys():
                vec += bigrams[bi]
            i += 1
        vec /= i if i else 1
        return vec

    def _text_to_vec(self, text, fasttext_vectors, bigrams, term_idx):
        vec = np.zeros((len(term_idx), 300), dtype=np.float64)

        for word in text:
            if word in fasttext_vectors.keys():
                vec[term_idx[word]] = fasttext_vectors[word]
            else:
                vec[term_idx[word]] = self._bigram_mean_vector(word, bigrams)
        return np.average(vec,axis = 0)

    def __call__(self, normalized_requests, normalized_documents, fasttext_vectors, bigrams, term_idx):
        request_vectors = []
        for request in normalized_requests:
            request_vectors.append(self._text_to_vec(request, fasttext_vectors, bigrams, term_idx))

        document_vectors = []
        for document in normalized_documents:
            document_vectors.append(self._text_to_vec(document,fasttext_vectors,bigrams, term_idx))
        
        return self.get_relevance(self.norm(document_vectors), self.norm(request_vectors))
