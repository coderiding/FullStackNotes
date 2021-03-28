# coding:utf-8

import sys

# sys.argv
# 在命令行执行 python 0319sys.py version
# 上面的version就是代表外部传入的参数，是sys.argv[1]，那么sys.argv[0]是什么呢
# 通过sys.argv来打印就知道 ,结果就是 ['/Users/coderiding/FullStackNotes/Python/慕课Python全栈笔记/32周/练习代码/5w_code/0319sys.py']
# print(sys.argv) #就是当前模块的绝对路径

# 一下代码需要在命令行执行
# command = sys.argv[1]
# if command == 'version':
#     print(sys.version)
# elif command == 'platform':
#     print(sys.platform)
# elif command == 'modules':
#     print(sys.modules)#获取py启动时加载的模块