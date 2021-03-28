#coding:utf-8

import json
import os

def readdata(path):
    with open(path,'r') as f:
        data = f.read()

    return json.loads(data) # 这里之前用错load，实际是loads


def write(path,data):
    with open(path,'w') as f:
        if isinstance(data,dict):
            sdata = json.dumps(data)
            f.write(sdata)
        else:
            raise Exception('需要传入字典类型')
    return True

if __name__ == "__main__":
    write_path = 'jsondata.json'
    write_data = {'project': "我喜欢蔡依林", 'name': 'wen', 'age': '18'}
    writeResult = write(path=write_path, data=write_data)

    readdata1 = readdata(path=write_path)

    # 添加新字段
    readdata1['sex'] = 'boy'
    write(write_path,readdata1) # 为什么写新的值，下面没有重新读，也能读到新值呢
    print(readdata1)


