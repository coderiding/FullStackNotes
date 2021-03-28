#coding:utf-8

import os
import json
import time
from common.error import UsersExistsError,RoleError,LevelNameError,NagativeError
from common.utils import check_file
from common.utils import timestamp_to_string
from common.const import ROLES,FIRSTLEVEL,SECONDLEVEL

class Base(object):
    def __init__(self,user_json,gift_json):
        self.user_json = user_json
        self.gift_json = gift_json

        self.check_json(self.user_json)
        self.check_json(self.gift_json)
        self.__init_gift_json()

    def check_json(self,path):
        return check_file(path)

    # 定义读取user.json方法
    def __read_users(self,time_to_str):
        with open(self.user_json,'r') as f:
            data = json.loads(f.read())

        if time_to_str == True:
            for username,v in data.items():#这里的v就是value，key就是username
                v['create_time'] = timestamp_to_string(v['create_time'])
                v['update_time'] = timestamp_to_string(v['update_time'])
                data[username] = v
        return data

    # 定义写入数据到user.json方法
    def __write_user(self,**user):
        if 'username' not in user:
            raise ValueError('missing username')
        if 'role' not in user:
            raise ValueError('missing role')

        user['active'] = True
        user['create_time'] = time.time()
        user['update_time'] = time.time()
        user['gifts'] = []

        existUsers = self.__read_users(time_to_str=False)
        print(existUsers)

        if user['username'] in existUsers:
            raise UsersExistsError('username %s had exists'%user['username'])

        existUsers.update(
            {user['username']:user}
        )

        self.__saveJson(data=existUsers,path=self.user_json)

    def __changeRole(self,username,role):#汶：记得参数传入的顺序
        # 判断用户窜在
        users = self.__read_users(time_to_str=False)
        user = users.get(username)
        if not user:
            return False

        # 判断角色存在
        if role not in ROLES:
            raise RoleError('role %s not exists'%role)

        user['role'] = role
        user['update_time'] = time.time()
        users[username] = user

        self.__saveJson(data=users,path=self.user_json)

        return True

    def __changeActive(self,username):
        users = self.__read_users(time_to_str=False)
        user = users.get(username)
        if not user:
            return False

        user['active'] = not user['active']
        user['update_time'] = time.time()
        users[username] = user

        self.__saveJson(data=users,path=self.user_json)

        return True

    def __deleteUser(self,username):
        users = self.__read_users(time_to_str=False)
        user = users.get(username)
        if not user:
            return False

        deleuser = users.pop(username)

        self.__saveJson(data=users,path=self.user_json)

        return True

    def __init_gift_json(self):

        data = {
                'level1':{
                    'level1':{},
                    'level2':{},
                    'level3':{}
                },
                'level2':{
                    'level1':{},
                    'level2':{},
                    'level3':{}
                },
                'level3': {
                    'level1': {},
                    'level2': {},
                    'level3': {}
                },
                'level4': {
                    'level1': {},
                    'level2': {},
                    'level3': {}
                },
        }
        gifts = self.__read_gift_json()
        if len(gifts) != 0:
            return

        self.__saveJson(data=data,path=self.gift_json)

    def __read_gift_json(self):
        with open(self.gift_json,'r') as f:
            return json.loads(f.read())

    def __write_gift_json(self,firstLevel,secondLevel,giftname,giftcout):

        if firstLevel not in FIRSTLEVEL:
            raise LevelNameError('first level not exist')
        if secondLevel not in SECONDLEVEL:
            raise LevelNameError('second level not exist')

        gifts = self.__read_gift_json()

        if giftcout <= 0:
            giftcout = 1

        gift_pool = gifts[firstLevel]
        gift = gift_pool[secondLevel]

        if giftname in gift:
            gift[giftname]['count'] = gift[giftname]['count']+giftcout
        else:
            gift[giftname] = {
                'name':giftname,
                'count':giftcout
            }

        gift_pool[secondLevel] = gift
        gifts[firstLevel] = gift_pool

        self.__saveJson(data=gifts,path=self.gift_json)

    def __saveJson(self,data,path):
        json_data = json.dumps(data)
        with open(path, 'w') as f:
            f.write(json_data)

    def __checkLevel(self,firstLevel,secondLevel,giftName):
        if firstLevel not in FIRSTLEVEL:
            raise LevelNameError('firstLevel not exists')
        if secondLevel not in SECONDLEVEL:
            raise LevelNameError('secondLevel not exists')

        gifts_data = self.__read_gift_json()

        firstLeve_data = gifts_data[firstLevel]
        gifts_pool = firstLeve_data[secondLevel]
        return {
            'firstLeve_data':firstLeve_data,
            'gifts_pool':gifts_pool,
            'gifts_data':gifts_data
        }


    def __update_gift(self,firstLevel,secondLevel,giftName,giftCount,is_admin):

        # 整个奖品数据文件，包括4个Level，每个Level，又分为3个子Level，根据奖品名字在子Level中找到奖品
        # 一个firstLevel可以有多个secondLevel
        # 一个 secondLevel 可以有很多的礼物

        data = self.__checkLevel(firstLevel=firstLevel,secondLevel=secondLevel,giftName=giftName)
        firstLeve_data = data.get('firstLeve_data') # 当前奖品池的level
        gifts_pool = data.get('gifts_pool') # 当前奖品池
        gifts_data = data.get('gifts_data') # 当前奖品所有数据

        choose_gift = gifts_pool[giftName]

        if is_admin:
            if giftCount <= 0:
                raise Exception('当前数量不能为0')

            choose_gift['count'] = giftCount
        else:
            if choose_gift['count'] - giftCount < 0:
                raise NagativeError('数量不能为负数')

            choose_gift['count'] -= giftCount

        gifts_pool[giftName] = choose_gift
        firstLeve_data[secondLevel] = gifts_pool # 把更新的奖品池数据赋值给对应的Level2对应的子level
        gifts_data[firstLevel] = firstLeve_data #

        self.__saveJson(data=gifts_data,path=self.gift_json)

    def __delete_gift(self,firstLevel,secondLevel,giftName):
        data = self.__checkLevel(firstLevel=firstLevel, secondLevel=secondLevel, giftName=giftName)
        firstLeve_data = data.get('firstLeve_data')  # 当前奖品池的level
        gifts_pool = data.get('gifts_pool')  # 当前奖品池
        gifts_data = data.get('gifts_data')  # 当前奖品所有数据

        if giftName not in gifts_pool:
            return 'delete gift not exists'

        deletegift = gifts_pool.pop(giftName)

        firstLeve_data[secondLevel] = gifts_pool
        gifts_data[firstLevel] = firstLeve_data

        self.__saveJson(data=gifts_data,path=self.gift_json)

        return deletegift


if __name__ == "__main__":
    gift_p = os.path.join(os.getcwd(),'storage','gift.json')
    user_p = os.path.join(os.getcwd(),'storage','user.json')
    print(gift_p)
    print(user_p)

    base_obj = Base(user_json=user_p,gift_json=gift_p)
    # base_obj.write_user(username='liu',role='admin')
    # result = base_obj.changeRole(username='liu',role='normal')
    # print(result)
    # changeActiveResult = base_obj.changeActive(username='liu')
    # print(changeActiveResult)
    # deleteuser = base_obj.deleteUser('liu')
    # print(deleteuser)
    # print(base_obj.read_gift_json())
    # base_obj.write_gift_json(firstLevel='level4',secondLevel='level1',giftname='iphone8',giftcout=10)
    # print(base_obj.delete_gift(firstLevel='level4',secondLevel='level1',giftName='iphone8'))

