import os

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

def out_file(file_name, sentence):
    path = os.path.join(ROOT_DIR, file_name)
    print(sentence)
    with open(path, "a",encoding = 'utf8') as f:
        f.write(sentence+"\n")

def init_file(file_name):
    path = os.path.join(ROOT_DIR, file_name)
    with open(path,'w') as f:
        f.write("")
