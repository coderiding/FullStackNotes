// 引用express框架
const express = require('express');
// 创建博客展示页面路由
const admin = express.Router();

admin.get('/login',(req,res) => {
    res.render('admin/login');
});

// 创建用户列表路由
admin.get('/user',(req,res) => {
    res.render('admin/user');
});

// 将路由对象作为模块成员进行导出
module.exports = admin;