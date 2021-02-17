// 导入用户集合构造函数
const {User} = require('../../model/user');
// 导入bcrypt
const bcrypt = require('bcrypt');

module.exports = async (req,res) => {
    // 接收请求参数 
    const {email,password} = req.body; 
    if (email.trim().length == 0 || password.trim().length == 0) {
        return res.status(300).send('<h4>邮件地址或者密码错误</h4>');
    }
    // 根据邮箱地址查询用户信息
    let user = await User.findOne({email})
    // 查询到用户
    if(user){
        // 将客户端传递过来的密码和用户信息中的密码进行比对
        // true 比对成功
        // false 对比失败
        let isValid = await bcrypt.compare(password,user.password);
        if(isValid){
            // 将用户存储在请求中,用来判断登录状态
            req.session.username = user.username;
            req.app.locals.userInfo = user;
            res.redirect('/admin/user')
        }else{
            res.status(400).render('admin/error',{msg:'邮箱地址或者密码错误'});
        }
    }else {
        // 没有查到
        res.status(400).render('admin/error',{msg:'邮箱地址或者密码错误'});
    }
} 