#coding:utf-8

import re

def had_number(data):
    result = re.findall('\d',data)
    for i in result:
        return True
    return False

def remove_number(data):
    result = re.findall('\D',data)
    return ''.join(result)

def startwith(sub,data):
    _sub = '\A%s'%sub
    result = re.findall(_sub,data)
    for i in result:
        return True
    return False

def endwith(sub,data):
    _sub = '%sZ'%sub
    result = re.findall(_sub,data)
    for i in result:
        return True
    return False

def reallen(data):
    return len(re.findall('\S',data))

if __name__ == '__main__':
    str_data = 'i am coding wen hello 33'
    print('数据中是否有数字 =',had_number(str_data))
    print('移除数字后的数据为：',remove_number(str_data))
    print('没有移除空格后的长度 = ', len(str_data))
    print('数据移除空格后的真实长度 = ',reallen(str_data))
    print(startwith('i',str_data))
    print(endwith('44',str_data))

    data_test = 'de@im.com'
    print(re.findall('\w*',data_test))#如果没有加*，就会一个个取出['d', 'e', 'i', 'm', 'c', 'o', 'm']
    # 加了之后变成['de', '', 'im', '', 'com', '']

    data1 = 'ab34@cd6'
    print(re.findall('[a-z]{3}]',data1))#匹配字母3个，结果为空

    data2 = '_ab@3@'
    print(re.findall('\w{1,5}',data2))#你可以把1换成0试试