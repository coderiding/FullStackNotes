// 引用express框架
const express = require('express');

// 创建博客展示页面路由
const admin = express.Router(); 

admin.get('/login',require('./admin/loginPage.js'));

// 实现登录功能
admin.post('/login',require('./admin/login.js'));

// 创建用户列表路由
admin.get('/user',require('./admin/userPage.js'));

// 实现退出功能
admin.get('/logout',require('./admin/logout.js'));

// 将路由对象作为模块成员进行导出
module.exports = admin;