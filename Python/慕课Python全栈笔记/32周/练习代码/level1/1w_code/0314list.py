# coding:utf-8

list = [None,None]
print(bool(list))

max_list = [1,2,34,3.14,5]
print(max(max_list))
print(id(max_list))

max_list.append(44)
print(id(max_list)) # 测试列表的内存地址有没有发生变化