# coding:utf-8

aStr = 'abC'
print(aStr.swapcase()) # 大写转小写，小写转大写

# zfill

af = 'abc'
print(af.zfill(10))

# count
abc = 'abdjsdlkjfkldsjweifewiodsjfksdjflewji'
print(abc.count('j')) # 打印abc中有几个j

alista = ['a','b','c']
print(alista.count('a'))

adicta = {'a':1,'b':2}
# print(adicta.cou) 字典不存在count函数

# startwith

awith = 'a bc de f'

print(awith.startswith('a'))

# endwith
print(awith.endswith('c'))

# find
finda = '2390addbd'
print(finda.find('3'))

# index
print(finda.index('d')) # 使用index，如果元素不存在就会报错

# strip
astrip = 'abcdef    '

# lstrip
print(astrip.lstrip('a')) #去掉左边空格或者指定元素

# rstrip
print(astrip.rstrip()) # 去掉右边空格或者指定元素

# replace
areplace = 'ablkdjskfjiwe999'
print(areplace.replace('9','8',2)) # 替换9位8，长度是2，不传2，代表全部的替换
print(areplace.replace('a','b',1).replace('l','k',1)) # 可以连续使用replace

# casefold

folda = 'AJJIIJTTTTGGG'
print(folda.casefold()) # casefold 针对多语言，lower针对英文

# 格式化 方法1
infonfomat = 'my name is %s,my age is %s'
namef = 'l'
agef = 19
print(infonfomat%(namef,agef))

# format 格式化方法2-推荐
print('my name is {0},my age is {1}'.format('l',22))

# f-string 格式化方法3
print(f'my f name is {namef},my age is {agef}')

# 格式化字符
print('%s'%'abc')
print('%d'%123)
print('%f'%123.3)
print('%u'%123)
print('%c'%123) # 格式化字符
print('%o'%123) # 八进制格式
print('%x'%123) # 16进制
print('%e'%123) # 科学进制

# 转义符
print('my name is mr\'s liuwen')
