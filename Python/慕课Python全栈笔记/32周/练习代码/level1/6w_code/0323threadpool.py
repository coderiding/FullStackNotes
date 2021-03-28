#coding:utf-8

import time
from concurrent.futures import ThreadPoolExecutor
import threading

lock = threading.Lock()

def work(i):
    lock.acquire()
    print(i)
    time.sleep(1)
    lock.release()
    return '%s result'%i

if __name__ == '__main__':
    tpool = ThreadPoolExecutor(2)
    resultlist = []
    for i in range(20):
        result = tpool.submit(work,(i,))
        resultlist.append(result)

    for i in resultlist:
        print(i.result())#获取返回值，work执行后的返回值，因为是异步，所以在线程池才能拿到返回值
