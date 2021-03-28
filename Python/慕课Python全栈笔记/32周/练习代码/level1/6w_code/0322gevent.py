#coding:utf-8

import os
import time
import gevent
import random

def g_a():
    for i in range(5):
        print(i,'a_g',os.getpid())
        gevent.sleep(random.random() * 2)
    return 'a result'

def g_b():
    for i in range(5):
        print(i,'b_g',os.getpid())
        gevent.sleep(random.random() * 2)
    return 'b result'


if __name__ == '__main__':
    start_time = time.time()
    ga = gevent.spawn(g_a)
    gb = gevent.spawn(g_b)
    listg = [ga,gb]
    result = gevent.joinall(listg)
    print(result)
    print(gb.value)
    print(ga.value)
    use_time = time.time() - start_time
    print(use_time)