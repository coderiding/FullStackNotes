#coding:utf-8

import os

from base import Base

from common.error import UsersExistsError,NotActiveError,RoleError


class Admin(Base):
    def __init__(self,username,user_json,gift_json):
        self.username = username
        super().__init__(user_json,gift_json)
        self.getUser()

    def getUser(self):
        users = self._Base__read_users(time_to_str=False)
        user = users.get(self.username)

        if user == None:
            raise UsersExistsError('no esixt user')

        if user['active'] == False:
            raise NotActiveError('user not active')

        if user['role'] != 'admin':
            raise RoleError('no admin user')

        self.user = user
        self.role = user.get('role')
        self.active = user.get('active')
        self.name = user.get('username')
        # print(self.user)
        # print(self.role)
        # print(self.active)
        # print(self.name)

    def checkUserRoler(self,message):
        self.getUser()

        if self.role != 'admin':
            raise RoleError(message)

    def add_user(self,username,role):
        self.checkUserRoler('normal user can not handle this operation')

        self._Base__write_user(username=username,role=role)

    def changeuseractive(self,username):

        self.changeUserRole('normal user can not handle this operation')

        self._Base__changeActive(username=username)

    def changeUserRole(self,username,role):
        self.checkUserRoler('normal user can not handle this operation')

        self._Base__changeRole(username=username,role=role)

    def addgift(self,firstLevel,secondLevel,giftname,giftcout):
        self.checkUserRoler('normal user can not handle this operation')

        self._Base__write_gift_json(firstLevel=firstLevel,secondLevel=secondLevel,giftname=giftname,giftcout=giftcout)

    def delegift(self,firstlevel,secondlevel,giftname):
        self.checkUserRoler('normal user can not handle this operation')
        self._Base__delete_gift(firstLevel=firstlevel,secondLevel=secondlevel,giftName=giftname)

    def updateGiftCount(self,firstLevel,secondLevel,giftName,giftCount):
        self.checkUserRoler('normal user can not handle this operation')
        self._Base__update_gift(firstLevel=firstLevel,secondLevel=secondLevel,giftName=giftName,giftCount=giftCount,is_admin=True)

if __name__ == '__main__':
    gift_p = os.path.join(os.getcwd(), 'storage', 'gift.json')
    user_p = os.path.join(os.getcwd(), 'storage', 'user.json')
    admin = Admin(username='liu',user_json=user_p,gift_json=gift_p)
    # admin.getUser()
    # admin.add_user(username='yin',role='normal')
    # admin.changeuseractive(username='yin')
    # admin.changeUserRole(username='yin',role='admin')
    # admin.addgift(firstLevel='level1',secondLevel='level3',giftname='ipad',giftcout=2)
    # admin.delegift(firstlevel='level1', secondlevel='level1', giftname='iphone8')
    admin.updateGiftCount(firstLevel='level1',secondLevel='level1',giftName='iphonex',giftCount=15)