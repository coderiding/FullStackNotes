#coding:utf-8

import hashlib
import time

base_sign = 'wen'

def custom():
    a_timstamp = int(time.time())
    _token = '%s%s'%(base_sign,a_timstamp)
    hasobj = hashlib.sha1(_token.encode('utf-8')).hexdigest() # 对二进制数据进行加密
    print(hasobj)
    return hasobj,a_timstamp # 可以返回多个返回值,注意返回值的顺序，和使用返回值的顺序一致

def checkpassword(token,timestmap):
    _token = '%s%s'%(base_sign,timestmap)
    hasobj = hashlib.sha1(_token.encode('utf-8')).hexdigest()
    if hasobj == token:
        return True
    else:
        return False

if __name__ == '__main__':
    # custom()
    need_help_token,timestamp = custom()#注意返回值的顺序，和使用返回值的顺序一致
    time.sleep(1)
    result = checkpassword(need_help_token,int(time.time()))
    if result == True:
        print('验证通过')
    else:
        print('验证失败')