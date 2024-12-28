import numpy as np

class Utils:
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
    
    