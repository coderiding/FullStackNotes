#coding:utf-8

import re

url_str = 'http://www.baidu.com'

def check_url(url):
    result = re.findall('[a-zA-Z]{4,5}://\w+.\w+.\w+',url)
    for i in result:
        return True
    return False

if __name__ == '__main__':
    print(check_url(url_str))