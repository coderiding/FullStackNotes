# coding:utf-8

user_info = {'name':'liuwen','age':18}
result = 'name' in user_info
print(result)

hresult = 'hope' not in user_info
print(hresult)

print(len(user_info)) # 打印字典长度
print(max(user_info)) # 打印数据中最大成员
print((min(user_info)))