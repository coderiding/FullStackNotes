# coding:utf-8

name_puple = ('a','b','c')
name_list = ['1','2','3']

name_puple += ('d',)
print(name_puple)

name_puple *= 3
print(name_puple)

name_list += ['4']
name_list *= 4
print(name_list)

print('4' not in name_list)
print('a' in name_puple)

# append

alist = []
print(alist.append(True)) # 添加bool
print(alist.append(None)) # 添加空
applist = ['1']
print(alist.append(['1'])) # 添加数组
alist.append(applist)
print(alist)
print(alist.append((1,))) # 添加元组
print(alist)

# count 列表的cout 和元组的 cout
countlist = ['狗','狗','猫','猪','鼠','猫','猫','猪','猪','猪','鼠','鼠','鼠','鼠','鼠']
countpuple = ('狗','猫','猪','鼠','猫','猫','猪','猪','猪','鼠','鼠','鼠','鼠','鼠')
dogcount = countlist.count('狗')
catcount = countlist.count('猫')

print(f'狗有{dogcount}只\n猫有{1}只'.format(catcount))

# remove
rlist = ['1','2','3']
print(rlist.remove('1'))
print(rlist)

# del
del rlist
# print(rlist) 因为已经删除，所以没有了

# reverse 颠倒
relist = ['1','2']
relist.reverse()
print(relist)

# sort 永久性排序
slist = ['a','d','b','k']
slist.sort()
print(slist)

# clear
clearlist = ['a',1,(1111,),{"3":1}]
print(len(clearlist))
clearlist.clear()
print(clearlist)

# copy
copylist = ['1','2',(1,)]
cccopy = copylist.copy()
print(copylist)
print(cccopy)
print(id(copylist))
print(id(cccopy))

# extend
aarray = []
barray = []
carray = []
add = ['1']
bdd = ['2']
cdd = ['3']
aarray.extend(add)
barray.extend(bdd)
carray.extend(cdd)
print(aarray)
print(barray)
print(carray)
aarray.extend(barray)
print(aarray)
carray.extend('1')
print(carray)
# carray.extend(1) # 不能extend数字和bool
# carray.extend(True)
carray.extend({'1':2})
print(carray) # extend字典，只保存字典中的key

#insert
inserlist = [1,2,3,4]
inserlist.insert(8,9)
print(inserlist) # 没有index8的位置，所以存到最后面

# 切片
ap = [1,2,3,4,5,6,7,8,9,10]
print(len(ap) - 1)
print(ap[9])

# pop
ap.pop(0)
print(ap)

# del
del ap[1]
print(ap)

# 字符串索引与切片
stringdd = 'qejlwjflksdjklfjdsf'
new_stringd = stringdd[::-1]
print(new_stringd)