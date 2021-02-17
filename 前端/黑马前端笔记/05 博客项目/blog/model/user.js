// 引入mongoose第三方模块
const mongoose = require('mongoose');
// 导入bcrypt
const bcrypt = require('bcrypt');
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

async function createUser () {
    const salt = await bcrypt.genSalt(10); 
    const pass = await bcrypt.hash('123456',salt);

    const user = await User.create ({
        username:'iteheima',
        email: 'williamliu321@aliyiun.com',
        password: pass,
        role: 'admin',
        state: 0
    });

    console.log(user);
} 

// 以后可能开放多个，所以用集合方式
module.exports = {
    User:User
}