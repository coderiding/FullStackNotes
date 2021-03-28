#coding:utf-8

import random

# random

def choose_gitf():
    count = random.randint(1,10)
    if count == 8:
        print('恭喜你中奖了')
    else:
        print('再接再厉')

choose_gitf()

def choose_gift_new():
    count = random.randrange(1,100,2)
    if count < 50:
        print('喜中iphone')
    elif 50<= count < 70:
        print('喜中ipad')
    elif 70<= count < 90:
        print('喜中tv电视')
    else:
        print('喜中房子一套')

choose_gift_new()