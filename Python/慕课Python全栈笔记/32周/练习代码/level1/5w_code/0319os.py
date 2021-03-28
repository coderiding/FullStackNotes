#coding:utf-8

import os

current_path = os.getcwd() # 当前路径

print(os.listdir(current_path)) # 当前路径所有文件listdir

# 创建文件夹
# os.makedirs('%s/testmake'%current_path)

# 修改文件名或者文件夹名
# os.rename('%s/testmake'%current_path,'%s/testmakenew'%current_path)

# 删除空文件夹
# os.rmdir('%s/testmakenew'%current_path)

# os.path
print(os.path.exists('%s/sss'%current_path))#判断路径是否存在
print(os.path.isdir('%s/ss'%current_path))#判断是否是路径
print(os.path.isabs('%s/0319os.py'%current_path))#判断是否是绝对路径
print(os.path.isfile('%s/0319os.py'%current_path))#判断是否是文件
current_path += '/xx.py'
print(os.path.split(current_path))#以最后一层路径为基准切割,就是切割最后一个斜杠