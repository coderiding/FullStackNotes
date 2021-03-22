# coding:utf-8

# str int float
str_int = '123'
real_int = int(str_int)
print(real_int,type(real_int))

str_float = '123.3'
real_float = float(str_float)
print(real_float,type(real_float))

# join
list2 = ['a','c','c','d']
resulist = ','.join(list2) # 通过用逗号分割将列表转字符串
print(resulist)

# dir
print(dir(bool)) # 打印布尔有的方法和属性

# encode decode
cen = '中国'
cenen = cen.encode('utf-8') # 中文字符转bytes
print(cenen)
print(type(cenen)) # 字符转换后，编程了bytes
print(cenen.decode('utf-8'))

# set tuple list
seta = {1,2,3}
tuplea = (1,2,3)
lista = [1,2,3]

setTotuple = tuple(seta)
print(setTotuple,type(setTotuple))

setTolist= list(seta)
print(setTolist,type(setTolist))

listToSet = set(lista)
print(listToSet,type(listToSet))

listToTuple = tuple(lista)
print(listToTuple,type(listToTuple))

tupleToSet = set(tuplea)
print(tupleToSet,type(tupleToSet))

tupleToList = list(tuplea)
print(tupleToList,type(tupleToList))

# 99乘法表
