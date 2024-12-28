import io
import os
from multiprocessing import Pool
from load_processed_data import *
import json

def load_vectors(fname, terms):
    fin = io.open(fname, 'r', encoding='utf-8', newline='\n', errors='ignore')
    n, d = map(int, fin.readline().split())
    data = {}
    pool = Pool(processes = 300)
    for iter, line in enumerate(fin):
        tokens = line.rstrip().split(' ')
        if tokens[0] in terms:
            data[tokens[0]] = pool.map(float, tokens[1:])

        print(f"{iter}/{n}  {100 * (iter / n)}% is processed", end = "\r")
    return data

term_idx = LoadData().term_idx()

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
vector_file = os.path.join(ROOT_DIR,"wiki.ru.vec")

vectors = load_vectors(vector_file, list(term_idx.keys()))

p = os.path.join(ROOT_DIR,"processed", "fasttext_vectors_only_exists.json")
with open(p,"w", encoding="utf8") as f:
  json.dump(vectors, f, ensure_ascii=False, indent = 4)