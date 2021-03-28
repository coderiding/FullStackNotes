#coding:utf-8

import time
import multiprocessing
import random
import threading

old_list = ['a','b','c','d','e','f','g']
new_list = []

def work():
    result = random.choice(old_list)
    old_list.remove(result)
    new_data = '%s_new' % result
    new_list.append(new_data)
    time.sleep(1)


if __name__ == '__main__':
    start_time = time.time()
    t_list = []
    for i in range(len(old_list)):
        t = threading.Thread(target=work)
        t_list.append(t)
        t.start()#启动线程

    for i in t_list:
        i.join()#等待线程执行完毕

    print(new_list)
    print(old_list)
    print('use_time：%s'%(time.time() - start_time))