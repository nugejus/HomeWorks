import re
import numpy as np
from collections import Counter

class Model:
    def __init__(self):
        pass

    def norm(self, matrix):
        return matrix / np.linalg.norm(matrix, axis=1, keepdims=True)

    def get_relevance(self, req_norm, doc_norm):
        relevance = []
        for req in req_norm:
            x = {i : y.sum() for i, y in enumerate(doc_norm * req)}
            x = sorted(x.items(), key = lambda x : x[1],reverse = True)
            relevance.append(x)
        
        return relevance
    
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
    
    def get_tf(self, normal_form, term_idx):
        tf = np.zeros((len(normal_form), len(term_idx)), dtype=np.float64)
        for i, doc in enumerate(normal_form):
            term_count = Counter(doc)
            for term, count in term_count.items():
                if term in term_idx:
                    tf[i, term_idx[term]] = count
        return tf
