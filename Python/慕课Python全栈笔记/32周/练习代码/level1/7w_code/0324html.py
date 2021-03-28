#coding:utf-8

import re

htmlstr = ('<div class="s-top-nav" style="display:none;">'
           '</div><div class="s-center-box"></div>')

# 拿到style后面字符
def getStyle(html):
    result = re.findall('style=".*?"',html)
    return result

# 拿到=号后面的字符
def getDeng(html):
    re_obj = re.compile('=".*?"')
    result = re.findall(re_obj,html)#问号表示非贪婪模式
    return result

if __name__ == '__main__':
    print(getStyle(htmlstr))
    print(getDeng(htmlstr))

