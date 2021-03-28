#coding:utf-8

import re

emailtest = 'liuklj@163.com'

def email_check(email):
    result = re.findall('.+@.+\.[a-zA-Z]+',email)
    for i in result:
        return True
    return False

if __name__ == '__main__':
    print(email_check(emailtest))