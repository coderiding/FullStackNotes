# coding:utf-8

# 迭代器
# 是不是相当于遍历呢，不是，迭代器的作用就是节省性能，每次用到的数据才会加载到内存中

iterobj = iter([1,2,3])
# print(next(iterobj))
# print(next(iterobj))
# print(next(iterobj))
# print(next(iterobj)) # 获取第四个就会报错了，因为已经没有
print('----------------')
# 写一个函数解决上面拿数据失败问题
def _next(iterobj0):
    try:
        return next(iterobj)
    except StopIteration:
        return None

# print(_next(iterobj))
# print(_next(iterobj))
# print(_next(iterobj))
# print(_next(iterobj))
# print(_next(iterobj))
# print(_next(iterobj))

# 使用for循环生成迭代器
for item in iterobj:
    print(item)

# 使用for循环配合yield生成迭代器
def make_iter():
    for i in range(10):
        yield i # 要放到一个函数中

print(make_iter())
for i in make_iter():
    print(i)


