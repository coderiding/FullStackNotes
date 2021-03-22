#coding:utf-8

from datetime import timedelta
from datetime import datetime
import time

def getBeforOnHourTime():
    one_hour = timedelta(hours=1)
    now = datetime.now()
    befor_one_hour = now - one_hour
    print(befor_one_hour)

getBeforOnHourTime()

def getBeforThreeDays():
    three_days = timedelta(days=3)
    now = datetime.now()
    befor_three_days = now - three_days
    return befor_three_days

print(getBeforThreeDays())

# 日期字符串转时间格式
dataSS = '2018/10/11 11:12:13'
datesj = datetime.strptime(dataSS,'%Y/%m/%d %H:%M:%S')
print(datesj)

# 时间格式转字符串
daten = datetime.now()
datenS = daten.strftime('%Y-%m-%d %H:%M:%S:%f')
print(datenS)

# 本地时间
nowlo = time.localtime() # 不传入参数，就用当前执行代码时的时间，默认
print(nowlo)

# datetime 生成时间戳, datetime更多用于对日期的处理，time包更多用户对事件的处理
daten3 = datetime.now()
datetimestamp = datetime.timestamp(daten3)
print(datetimestamp)

# datetime 时间戳转换
timestamptodate = datetime.fromtimestamp(datetimestamp)
print(timestamptodate)