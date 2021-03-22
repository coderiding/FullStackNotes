#coding:utf-8

import base64

replace_one = '%'
replace_two = '$'

# 加密,传入字符串或者二进制
def encode(data):
    if isinstance(data,str):
        data = data.encode('utf-8')
    elif isinstance(data,bytes):
        data = data
    else:
        raise Exception('必须传入比特或字符串数据类型')

    # return base64.encodebytes(data).decode('utf-8') # 加密后转字符串，如果不转你试试返回什么给你看
    # return base64.encodebytes(data) # 后面没有decode救护返回带b开头的二进制数据类型字符

    _data = base64.encodebytes(data).decode('utf-8')#转成字符串
    _data = _data.replace('d',replace_one).replace('2',replace_two)# 使用替换的方法，解决加密不安全的问题
    return _data

# 解密，传入二进制
def decode(data):
    if isinstance(data,bytes): # 也可以使用 if not isinstance()
        return base64.decodebytes(data).decode('utf-8')# 因为解密出来的也是二进制，需要转换到字符串观看
    else:
        raise Exception('需要传入比特数据类型来进行解密')




if __name__ == '__main__':
    encrpy_result = encode('wen')
    print(encrpy_result)
    de_encrpt = encrpy_result.replace(replace_one,'d').replace(replace_two,'2')
    # 加密的字符串转二进制
    b_en = de_encrpt.encode('utf-8')
    print(decode(b_en))# 成功，传入比特数据类型，可以成功解密
