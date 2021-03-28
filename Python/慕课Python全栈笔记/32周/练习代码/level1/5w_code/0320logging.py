#coding:utf-8

import logging
import os

def init_logging(path):
    if os.path.exists(path):
        mode = 'a'
    else:
        mode = 'w'

    logging.basicConfig(
        level = logging.INFO,
        format = '%(levelname)s %(filename)s %(lineno)d %(asctime)s %(message)s',
        filename = path,
        filemode=mode
    )

    return logging

if __name__ == '__main__':
    path = os.getcwd()
    joing_path = os.path.join(path,'testlog.log')
    logginstance = init_logging(joing_path)

    logginstance.info('1132323')
    logginstance.error('errrrorooooorrrr')
    logginstance.warning('warnnnninnnnnnngnnnn')
    logginstance.debug('debgggggguuggggg')
    logginstance.critical('criiitititititiitit')