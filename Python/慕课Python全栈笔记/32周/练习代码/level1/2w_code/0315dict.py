# coding:utf-8

# update
dictd = {'a':1,'b':2}
dictd.update({'c':3})
print(dictd)

# setdafault(如果字典存在对应的key，就获取那个key对应的值；如果不存在对应的key，则保存一份传入的key和value)
val = dictd.setdefault('a',3)
print(val)
val2 = dictd.setdefault('e',4)
print(val2)
print(dictd)

# keys
keydict = {'a':1,'b':2,'c':3}
print(keydict.keys())
allkeys = keydict.keys()
print(list(allkeys)) # 伪列表变成真列表

# values 2210316
getValues = {'a':1,'b':2}
re = getValues.get('c',3)
print(re) # dict不存在c，返回自定义的数字3
res = getValues['a']
print(res)

# clear pop del
cleardict = {'a':1,'b':2}
bdict = {'c':3,'d':4}
cleardict.clear()
print(cleardict)

cleardict = bdict
print(cleardict)
cleardict.pop('c') # 删除key为c的value
print(cleardict)

del cleardict['d'] # 删除key为d的value
print(cleardict)

# copy
copydict = {'apple':30,'bnana':50}
ccdict = copydict.copy()
print(id(copydict))
print(id(ccdict))

# popitem
popimteidcit = {'a':1,'b':3}
print(popimteidcit)
popimteidcit.popitem()
print('删除字典最后的键值对后返回结果：',popimteidcit)