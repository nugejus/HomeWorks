import os
import json

class LoadData:
    def __init__(self):
        self.ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

    def init_doc(self):
        path = os.path.join(self.ROOT_DIR,"processed","initial_documents.json")
        with open(path, encoding="utf8") as f:
            initial_documents = json.load(f)
        return initial_documents
    
    def normal_doc(self):
        path = os.path.join(self.ROOT_DIR,"processed","normalized_documents.json")
        with open(path, encoding="utf8") as f:
            normalized_documents = json.load(f)
        return normalized_documents
    
    def init_req(self):
        path = os.path.join(self.ROOT_DIR,"processed","initial_request.json")
        with open(path, encoding="utf8") as f:
            initial_request = json.load(f)
        return initial_request

    def normal_req(self):
        path = os.path.join(self.ROOT_DIR,"processed","normalized_request.json")
        with open(path, encoding="utf8") as f:
            normalized_request = json.load(f)
        return normalized_request

    def term_idx(self):
        path = os.path.join(self.ROOT_DIR,"processed","term_idx.json")
        with open(path, encoding="utf8") as f:
            term_idx = json.load(f)
        return term_idx
    
    def fasttext_vector(self):
        path = os.path.join(self.ROOT_DIR,"processed","fasttext_vectors_only_exists.json")
        with open(path, encoding="utf8") as f:
            vector = json.load(f)
        return vector
    
    def load_bigram(self):
        path = os.path.join(self.ROOT_DIR,"processed","bigrams.json")
        with open(path, encoding="utf8") as f:
            vector = json.load(f)
        return vector
