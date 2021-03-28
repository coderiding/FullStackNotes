#coding:utf-8

def upperStr(data):
    new_str = ''
    try:
        new_str = data.upper()
    except Exception as e:
        print('程序出错了%s'%e)
    finally:
        print('结束了')
    return new_str

print(upperStr(11))

# raise 抛出异常
def vlauseR(data:int):
    if data == 100:
        # raise ValueError('data不能是100')
        raise Exception('不能是100')
    else:

        print('ok')

vlauseR(70)

# 自定义异常
class newError(Exception):
    def __init__(self,message):
        self.__message__ = message

def timede(d):
    raise newError('我是捣蛋鬼%s'%d)

def testtimeda():
    try:
        timede('wo')
    except newError as e:
        print('什么鬼')
    finally:
        print('结束了')

testtimeda()
