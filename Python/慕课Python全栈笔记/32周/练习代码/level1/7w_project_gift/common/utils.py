#coding:utf-8

import os
import re
import time
from .error import NotFileError,NotPathError,FormatError

def endwith(sub,data):
    _sub = '%sZ'%sub
    result = re.findall(_sub,data)
    for i in result:
        return True
    return False


def timestamp_to_string(timestamp):
    t_obj = time.localtime(timestamp)
    t_str = time.strftime('%Y-%m-%d %H:%M:%S',t_obj)
    return t_str


def check_file(path:str):
    if not os.path.exists(path):
        raise NotPathError('not this file')

    if not path.endswith('.json'):
        raise FormatError('format wrong')

    if not os.path.isfile(path):
        raise NotFileError('not file error')

