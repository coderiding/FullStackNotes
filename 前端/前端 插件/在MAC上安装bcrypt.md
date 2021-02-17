我写这个问题只是为了对遇到同样问题的人有所帮助。

假设您已经安装了nodejs，并且对您的帐户具有适当的sudo权限。按COMMAND + T，输入终端

1）类型： npm install -g node-gyp

2）类型： npm install bcrypt

3）转到您的猫鼬模式模型，例如models / user.js和

直接在var mongoose下= require（'mongoose'）add

var bcrypt = require('bcrypt');