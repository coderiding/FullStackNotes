// 引入mongoose第三方模块
const mongoose = require('mongoose');
const { use } = require('../route/home');

// 创建用户集合规则
const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        minlength: 2,
        maxlength: 20
    },
    // 如果邮件不唯一会导致创建失败
    email: {
        type: String,
        unique: true,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    // admin 管理员
    // normal 普通
    role: {
        type: String,
        required: true
    },
    // 0 启用 
    // 1 禁用
    state: {
        type: Number,
        default : 0
    }
})

// 创建集合
const User = mongoose.model('User',userSchema);

// User.create ({
//     username:'iteheima',
//     email: 'williamliu32@aliyiun.com',
//     password: '123456',
//     role: 'admin',
//     state: 0
// }).then(() => {
//     console.log('用户创建成功')
// }).catch(() => {
//     console.log('用户创建失败')
// }) 

// 以后可能开放多个，所以用集合方式
module.exports = {
    User:User
}