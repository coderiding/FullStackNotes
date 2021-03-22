# codiding:utf-8

# if 语句
strj = 'i am liuwen'
strlist = strj.split()
print(strlist)
if strlist[0] == 'i':
    strlist[0] = 'you'

if strlist[1] == 'am':
    strlist[1] = 'are'

if strlist[-1] == 'liuwen':
    strlist[-1] = 'yinxian'

print(strlist)

# or and
if strlist[0] == 'you' or strlist[1] == 'are':
    strlist.clear()

print(strlist)

# else
if 'i' in strlist:
    print('您好')
else:
    print('滚蛋')

# elseif

# for 循环
baclist = ['a',2,'3']
for item in baclist:
    print(item)

backdict = {'a':1,'b':2}
for i in backdict:
    print(i)
    print(backdict[i])

# while 循环
countresult = 0
while countresult <= 100:
    countresult += 1
    if countresult == 99:
        print('马上到100了')
    elif countresult == 100:
        print('到100了')
        print(countresult)

# range
l = range(6)
listf = []
for i in l:
    listf.append(i)
    print(i)
else:
    print('循环结束') # 循环不报错，就可以执行
print(listf)

strinli = 'i am liuwen'
strillist = strinli.split()

listStrin = ' '.join(strillist)
print(listStrin)

# continue break
istring = 'i a m l i p q'
istringlist = istring.split()
for i in istringlist:
    if i == 'p':
        break
    else:
        print(i)
else:
    print('循环结束了') # 这里无法执行，因为有break打断了真个循环

# 99乘法表
for i in range(1,10):
    for j in range(1,i+1):
        print('{} * {} = {}'.format(i,j,i * j),end = ' ')
    print(' ')

i = 0
j = 0

while i < 9:
    i += 1
    while j <9:
        j += 1
        print('{} * {} = {}'.format(i,j,i * j),end = ' ')
        if i == j:
            j = 0
            print('')
            break