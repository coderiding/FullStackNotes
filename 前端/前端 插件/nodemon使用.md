
### 介绍
在之前我们启动应用服务采用的方式都是node app.js，但我们每次修改完node代码之后都需要重启服务器即是重新运行命令node app.js才能完成修改。现在使用nodemon替代node在开发环境下启动服务就会这么麻烦了。nodemon将监视启动目录中的文件，如果有任何文件更改，nodemon将自动重新启动node应用程序。nodemon不需要对代码或开发方式进行任何更改。 nodemon只是简单的包装你的node应用程序，并监控任何已经改变的文件。nodemon只是node的替换包，只是在运行脚本时将其替换命令行上的node。


### -bash: nodemon: command not found
-bash: nodemon: command not found

全局安装
npm install -g nodemon