from load_processed_data import *
import io
import os
from multiprocessing import Pool
import json
import re 

def has_cyrillic(text):
    return bool(re.search('[а-яА-Я]', text))

def get_bigram(fname):
    fin = io.open(fname, 'r', encoding='utf-8', newline='\n', errors='ignore')
    n, d = map(int, fin.readline().split())
    data = {}
    pool = Pool(processes = 300)
    for iter, line in enumerate(fin):
        tokens = line.rstrip().split(' ')
        if len(tokens[0]) == 2 and has_cyrillic(tokens[0]):
            data[tokens[0]] = pool.map(float, tokens[1:])

        print(f"{iter}/{n}  {round(100 * (iter / n),2)}% is processed", end = "\r")
    return data


ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
vector_file = os.path.join(ROOT_DIR,"wiki.ru.vec")

bigrams = get_bigram(vector_file)

p = os.path.join(ROOT_DIR,"processed", "bigrams.json")
with open(p,"w", encoding="utf8") as f:
  json.dump(bigrams, f,ensure_ascii=False,indent = 4)

print("ALL DONE")