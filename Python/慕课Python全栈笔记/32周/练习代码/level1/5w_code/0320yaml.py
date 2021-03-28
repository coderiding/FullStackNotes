#coding:utf-8

import yaml

def read(path):
    with open(path,'r') as f:
        data = f.read()

        return yaml.load(data,Loader=yaml.FullLoader)

read_path = 'testyaml.yaml'

print(read(read_path))