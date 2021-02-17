// 引用express框架
const express = require('express');
// 导入express-seesion模块
const session = require('express-session');
// 引入系统处理路径方法
const path = require('path');
// 引入body-parser模块 用来处理post请求参数
const bodyPaser = require('body-parser');
// 创建网站服务器
const app = express();
// 数据库连接
require('./model/connect'); 
// 处理post请求参数,传入false，使用系统的queryString处理参数
app.use(bodyPaser.urlencoded({extended:false}));
// 配置session
app.use(session({secret:'secret key'}));

// 告诉express框架模板所在的位置，参数views是固定写法
app.set('views',path.join(__dirname,'views'));
// 告诉express框架模板的默认后缀是什么
app.set('view engine','art');
// 当渲染后缀为art的博班时 所使用的模板引擎是什么
app.engine('art',require('express-art-template'));

// 开放静态资源文件
app.use(express.static(path.join(__dirname,'public')));

// 引入路由模块
const home = require('./route/home')
const admin = require('./route/admin');
const { nextTick } = require('process');

// 拦截请求 判断用户登录状态
app.use('/admin',require('./middleware/loginGuard.js'))

// 为路由匹配请求路径
app.use('/home',home);
app.use('/admin',admin);

// 监听端口
app.listen(8000);
console.log('网站服务器启动成功，请访问localhost')