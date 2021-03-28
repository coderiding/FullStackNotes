#coding:utf-8

import multiprocessing
import json
import time

class work(object):
    def __init__(self,q):
        self.q = q

    def putmessage(self,message):
        if not isinstance(message,str):
            message = json.dumps(message)
        self.q.put(message)

    def recvmessage(self):
        while 1:
            result = self.q.get()
            try:
                res = json.loads(result)
            except:
                res = result
            print(res)

    def send_all(self):
        for i in range(20):
            self.q.put(i)
            time.sleep(1)

if __name__ == '__main__':
    q = multiprocessing.Queue()
    worka = work(q)
    send = multiprocessing.Process(target=worka.putmessage,args=({'name':'xiaomu'},))
    recv = multiprocessing.Process(target=worka.recvmessage)
    send_all = multiprocessing.Process(target=worka.send_all)
    send_all.start()
    send.start()
    recv.start()
    send.join()#等待进程结束，利用耗时长的来调用
    # recv.terminate()#终结接收端