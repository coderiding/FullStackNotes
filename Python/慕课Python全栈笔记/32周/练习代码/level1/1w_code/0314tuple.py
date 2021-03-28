# codring:utf-8

atuple = ('1','2')
print(atuple)

alist = [1,2,'c']
blist = [3,4,'b']
btuple = (alist,blist)
print(btuple)
print((id(btuple)))

blist.append(5) # 测试元组内的list能不能变，看btuple的内存有没有变化（没变化）
alist.append(9)
print(btuple)
print(id(btuple))

onetuple = ('a')
print(type(onetuple)) # 测试只要一个元素，判断类型，这里的类型是str,需要加逗号，就是元组

