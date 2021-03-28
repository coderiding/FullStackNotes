#coding:utf-8

class firstClass(object):
    name = None
    age = None

    def fly(self):
        print(f'{self.name} 在飞')

    def jump(self):
        print(f'{self.name} 在跳')

liuwen = firstClass()
liuwen.name = 'liuwen'
liuwen.fly()
liuwen.jump()

# 构造函数

class initfirstClass(object):
    def __init__(self,name,age=None):
        self.name = name
        self.age=age

    def fly(self):
        print(f'{self.name} 在飞')

    def jump(self):
        print(f'{self.name} 在跳')


yinxian = initfirstClass(name='yinxian')
yinxian.fly()
yinxian.jump()

# 装饰器
def decoretion_func(func):
    print(func)
    def inner(*args,**kwargs):
        print('a=',*args,'b=',**kwargs)
        result = func(*args,**kwargs)
        if result == 'ok':
            print('结果没问题')
        else:
            print('结果有问题')
    return inner

@decoretion_func #这个是装饰器
def test(data):
    return data

test('ok')

# classmethod
class methodclass(object):
    def __init__(self,body):
        self.body = body

    def fly(self):
        print('fly')
        self.jump() # 可以调用clasmethod修饰的函数，但反过来调用就不行
        self.sleep()

    @classmethod
    def jump(cls):
        print('jump')
        # cls.fly() 这里不能调用

    @staticmethod
    def sleep():
        print('i want sleep')

    @property
    def name(self):
        return self.__name

    @name.setter
    def name(self,value):
        self.__name = value



classInstance = methodclass('1')
classInstance.fly()
classInstance.sleep()
methodclass.jump() # 不需要初始化实例，直接调用
methodclass.sleep()

# 被proerty修饰的属性，不能通过实例化的方式赋值，但是可以通过下面非实例化的方式赋值
# 需要设置setter方法后，就可以了
classInstance.name = 'yinxian'
# methodclass.name = 'liuwen'
print(classInstance.name)
print(methodclass.name)

# super使用
class superuse(object):
    def __init__(self):
        print('i am super')

class childuse(superuse):
    def __init__(self):
        super(childuse,self).__init__()
        super().__init__()# 两种写法
        print('i am child')

if __name__ == '__main__':
    c = childuse()
    print(c)

#__maro__
print(childuse.__mro__) # 打印集成的顺序

#__getattr__
class gaoji(object):
    def __getattr__(self, item):
        return ('不存在=%s的key'%item)

    def __setattr__(self, key, value):
        self.__dict__[key]=value
        print(self.__dict__)

    def __call__(self, *args, **kwargs):
        print(*args)
        print(**kwargs)

insGaoji = gaoji()
print(insGaoji.name)#触发__getattr__，判断不存在的key
print(insGaoji('3333'))#触发__call__，把类变成函数
insGaoji.name=1# 触发__setattr__，不存在的key，自动保存进去
print(insGaoji.name)

#链式调用
class gaoji2(object):
    def __init__(self,attr):
        self.__attr = attr

    def __getattr__(self, item):
        if self.__attr:
            item = '{}.{}'.format(self.__attr,item)
        else:
            item = item
        return gaoji(item)

    def __setattr__(self, key, value):
        self.__dict__[key]=value
        print(self.__dict__)

    def __call__(self, *args, **kwargs):
        print(*args)
        print(**kwargs)

insGaoji2 = gaoji2('888')
insGaoji2.a.b.c()