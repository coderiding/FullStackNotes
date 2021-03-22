#coding:utf-8

import sys
import os

current_path = os.getcwd()

# open
# f = open('%s/textwrit.txt'%current_path,'w+')#w只能写，w+可读可写
# f.write('no body here')
# f.writelines(['no\n','i\n','love\n'])
# print(f.read())
# f.close()

# f = open('%s/textwrit.txt'%current_path,'wb+')
# f.write(b'no body here')
# f.writelines([b'no',b'i',b'love'])
# print(f.read())
#
# f.close()

class Open(object):
    def __init__(self,path,mode='w',is_return=True):
        self.path = path
        self.mode = mode
        self.is_return = is_return

    # 写法一
    # def write(self,message):
    #     f = open(self.path,mode=self.mode)
    #     if self.is_return:
    #         message = '%s\n'%message
    #     f.write(message)
    #     f.close()

    # 写法二，使用with 来省略close
    def write(self,message):
        with open(self.path,mode=self.mode) as f:
            if self.is_return:
                message = '%s\n' % message
            f.write(message)

    def writeliness(self,listmessage:list):
        f = open(self.path, mode=self.mode)
        if self.is_return:
            hlist = []
            for item in listmessage:
                item = '%s\n' % item
                hlist.append(item)
            f.writelines(hlist)
        else:
            f.writelines(listmessage)

        f.close()

if __name__ == '__main__':
    open_path = os.path.join(current_path,'textclass.txt')
    openins = Open(open_path,is_return=True)
    openins.write('abc')# 这里会覆盖上一个数据
    openins.write('1111')# 这里会覆盖上一个数据
    l = ['abc','cdf','efg']
    openins.writeliness(listmessage=l)# 这里会覆盖上一个数据


# read 读取文件
fr = open('%s/0319os.py'%current_path,'r')
frdata = fr.read()
print(frdata)
print(len(frdata)) #文件长度
frdatalines = fr.readlines()#为什么这里读不出来数据
frdataline = fr.readline()
fr.close()
print(frdataline)
print(frdatalines)