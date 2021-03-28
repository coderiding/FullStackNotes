#coding:utf-8

import os
import random

from base import Base
from common.error import UsersExistsError,NotActiveError,RoleError,CountNumberError

class User(Base):
    def __init__(self,username,user_json,gift_json):
        self.username = username
        self.randomNumber = list(range(1,101))

        super().__init__(user_json=user_json,gift_json=gift_json)
        self.getUser(username=username)

    def getUser(self,username):
        users = self._Base__read_users(time_to_str=False)
        user = users.get(username)

        if user == None:
            raise UsersExistsError('no esixt user')

        if user['active'] == False:
            raise NotActiveError('user no active')

        if user['role'] != 'normal':
            raise RoleError('you ar not normal user')

        self.role = user.get('role')
        self.active = user.get('active')
        self.name = user.get('username')
        self.user = user

    def getGiftList(self):
        gifts = self._Base__read_gift_json()

        giftlist = []

        for leveone,levelone_pool in gifts.items():
            for leveltwo,levetow_pool in levelone_pool.items():
                for name,giftinfo in levetow_pool.items():
                    giftlist.append(giftinfo.get('name'))
        print(giftlist)
        return giftlist

    def chooseGift(self):

        levelonenumber = random.choice(self.randomNumber)
        levelone = ''
        if 1<= levelonenumber <= 50:
            levelone = 'level1'
        elif 51 <= levelonenumber < 70:
            levelone = 'level2'
        elif 70 <= levelonenumber < 90:
            levelone = 'level3'
        elif 90 <= levelonenumber <= 100:
            levelone = 'level4'
        else:
            raise CountNumberError('数字不存在')

        leveltwonumber = random.choice(self.randomNumber)

        leveltwo = ''
        if 1 <= leveltwonumber <= 50:
            leveltwo = 'level1'
        elif 51 <= leveltwonumber < 70:
            leveltwo = 'level2'
        elif 70 <= leveltwonumber < 100:
            leveltwo = 'level3'
        else:
            raise CountNumberError('数字不存在')

        gifts = self._Base__read_gift_json()
        levelonepool = gifts.get(levelone)
        leveltwopool = levelonepool.get(leveltwo)
        if len(leveltwopool) == 0:
            print('没中奖')
            return
        giftName = []
        for k,_ in leveltwopool.items():
            giftName.append(k)
        gift_name = random.choice(giftName)
        gift_info = leveltwopool.get(gift_name)
        if gift_info.get('count') == 0:
            print('没奖品了')
            return
        gift_info['count'] -= 1
        leveltwopool[gift_name] = gift_info
        levelonepool[leveltwo] = leveltwopool
        gifts[levelone] = levelonepool
        print(gift_info)
        # self.user[gifts] = [gift_info]
        self._Base__saveJson(gifts,self.gift_json)
        self.user['gifts'].append(gift_name)
        self.updateuser()

    def updateuser(self):
        users = self._Base__read_users(time_to_str=False)
        users[self.username] = self.user

        self._Base__saveJson(users,self.user_json)



if __name__ == '__main__':
    gift_p = os.path.join(os.getcwd(), 'storage', 'gift.json')
    user_p = os.path.join(os.getcwd(), 'storage', 'user.json')
    userinstance = User(username='liu',user_json=user_p,gift_json=gift_p)
    # userinstance.getGiftList()
    # print(userinstance.randomNumber)
    userinstance.chooseGift()