#coding:utf-8

import multiprocessing
import os
import time
from multiprocessing import Manager

def work(i,lock):
    lock.acquire()
    print(i, os.getpid())
    time.sleep(1)
    lock.release()
    return 'result is %s finish'%i

if __name__ == '__main__':
    pp_pool = multiprocessing.Pool(5)
    results = []
    manager = multiprocessing.Manager()
    lock = manager.Lock()

    for i in range(20):
        result = pp_pool.apply_async(func=work,args=[i,lock,])
        results.append(result)

    for res in results:
        print(res.get())

    # time.sleep(20)#进程池在主线程中执行，如果不添加这句，进程池就会马上结束
    # 使用进程池的join和close配合解决这个问题
    pp_pool.close()# 加了这句，表示进程池不会再接受新的任务
    pp_pool.join()# 表示要等待进程池任务都结束