# coding:utf-8

# set
seta = {1,2,3}
print(type(seta))

# setaa = {['a',3,4]} 通过大括号的方式添加列表，不能加入可变的数据类型，列表是可变的，
# print(setaa)

setcc = set(['a','b','c']) # 将列表加入到集合中，实际上是把列表的内容拿出来放到集合，看打印结果
print(setcc)

setkk = set({'a':1,'b':3}) # 将字典加入到集合中，实际上是把字典的key拿出来放到集合，看打印结果
print(setkk)

# remove
setkk.remove('a')
print(setkk)

setkk.update('9933ac') #会把字符串拆开加入到集合中,就像拆开列表一样
print(setkk)

setkk.add('112')
print(setkk)

# difference 差集
ddefa = ['a','b','e','f']
kkllkf = ['c','a','b']
ddefaSet = set(ddefa)
kkllkfSet = set(kkllkf)
re = ddefaSet.difference(kkllkfSet) # ddefaSet中有的，但是kkllkfSet没有的
print(re)

# intersection 交集
a = ['a','b','c']
b = ['a','e','f']
c = ['g','a','h']
a_set = set(a)
b_set = set(b)
c_set = set(c)
intersection_result = a_set.intersection(b_set,c_set) # 查看a、b、c set中的交集，就是3个都有的，就是a
print(intersection_result)

# union 并集
aa = ['a','b','c']
bb = ['a','e','f']
cc = ['g','a','h']
aa_set = set(aa)
bb_set = set(bb)
cc_set = set(cc)
union_result = aa_set.union(bb_set,cc_set) # 里面的参数只要是interation，就是说是集合、列表、字符串、元组都行
print(union_result)

# isdisjoint 判断两个几个是否包含相同元素，没有返回True
aaa = ['a','b','c']
bbb = ['a','e','f']
ccc = ['g','a','h']
aaa_set = set(aaa)
bbb_set = set(bbb)
ccc_set = set(ccc)
print(bbb_set.isdisjoint(aaa_set))
print(ccc_set.isdisjoint(aaa_set))