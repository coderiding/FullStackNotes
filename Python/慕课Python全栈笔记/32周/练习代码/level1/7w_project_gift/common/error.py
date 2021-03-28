#coding:utf-8

import os

class NotPathError(Exception):
    def __init__(self,message):
        self.message = message


class FormatError(Exception):
    def __init__(self,message):
        self.message = message


class NotFileError(Exception):
    def __init__(self,message):
        self.message = message


class UsersExistsError(Exception):
    def __init__(self,message):
        self.message = message


class RoleError(Exception):
    def __init__(self,message):
        self.message = message


class LevelNameError(Exception):
    def __init__(self,message):
        self.message = message


class NagativeError(Exception):
    def __init__(self,message):
        self.message = message


class NotActiveError(Exception):
    def __init__(self,message):
        self.message = message

class CountNumberError(Exception):
    def __init__(self,message):
        self.message = message