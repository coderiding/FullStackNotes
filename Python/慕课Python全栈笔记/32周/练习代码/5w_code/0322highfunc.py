# coding:utf-8

from functools import reduce

# fitler
data = [1,2,3,4]

filterresult = filter(lambda x:x > 2,data)
print(filterresult)
for i in filterresult:
    print(i)

# map
mapresult = map(lambda x:x < 2,data)
print(mapresult)
for i in mapresult:
    print(i)

# reduce，py2是内置函数,py3需要导入 from functools import reduce
reduceresult = reduce(lambda x,y:x+y,data)
print(reduceresult)