# coding:utf-8

import random
import asyncio
import time
import os

async def a():
    for i in range(10):
        print(i,'a',os.getpid())
        await asyncio.sleep(random.random() * 2) # time.sleep是同步的
    return 'a function'

async def b():
    for i in range(10):
        print(i,'b',os.getpid())
        await asyncio.sleep(random.random() * 2)
    return 'b function'

async def main():
    await asyncio.gather( # 用gather去集合异步函数
        a(),
        b()
    )

if __name__ == '__main__':
    print(os.getpid()) # 看异步是不是在同一个进程
    start = time.time()
    asyncio.run(main()) # 用run去执行异步函数
    end = time.time() - start
    print(end)