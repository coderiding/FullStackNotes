# coding:utf-8

import multiprocessing
import os
import time
import random

def work_a():
    for i in range(10):
        print('a',i,os.getpid())
        time.sleep(random.random()*2)

def work_b():
    for i in range(10):
        print('b',i,os.getpid())
        time.sleep(random.random()*2)


if __name__ == '__main__':
    print('主程序pid%s'%os.getpid())
    a_p = multiprocessing.Process(target=work_a)
    b_p = multiprocessing.Process(target=work_b)
    for i in (a_p,b_p):
        i.start()
        i.join()#这里阻塞了，会导致a_p执行完之后才到b_p

    print('结束了')