# coding:utf-8

# 首字母大写
def nameCappture(name):
    temp = ''
    index = 0
    for item in name:
        print(item)
        if index == 0:
            temp += item.capitalize()
        else:
            temp += item
        index += 1
    return temp

print(nameCappture('liuwen'))

# 不确定参数
argtuple = (1,2,3)
argdict = {'a':1,'b':2}
def testargs(*args,**kwargs):
    if 1 in args:
        print(1)
    if 'a' in kwargs:
        print('a')
    else:
        print('no body')
testargs(*argtuple,**argdict)#传入元组，前面加*；传入dict，前面加两个*

# 全局变量
name = 'liuwen'
def changename(data):
    global name
    name = 'yinxian' # 这样无法直接修改,需要在用global修饰变量
changename(name)
print(name)

# 递归
countnumber = 0
def countn():
    global countnumber
    countnumber += 1
    if countnumber < 5:
        print('现在的数字是%s',countnumber)
        return countn()
    else:
        print('我已经结束了，现在数字是%s',countnumber)

countn()

# 匿名函数 lambda
users = [
    {'name':'liuwen'},
    {'name':'xiaomu'},
    {'name':'asbd'}
]
users.sort(key=lambda x:x['name']) # 里面的x自动传入users？，这么厉害
print(users)

f = lambda x,y=2:x+y # 匿名函数后面只能进行简单的运算
print(f(1))