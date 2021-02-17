MAC运行PHP
https://blog.csdn.net/JonWu0102/article/details/87707088

https://www.jianshu.com/p/4495dfb2c963

概述
Mac系统对于PHP运行非常友好,我们只需要进行简单的配置便可以开始进行使用,本篇文章将一步一步地介绍Apache、PHP和MySQL的安装与配置,为开始进行开发铺好路

Apache
启动Apache服务
在Mac系统中已经安装好了Apache服务,我们只需要通过如下方式启动即可直接使用

在终端中输入如下命令,启动Apache服务

sudo apachectl start
注: 因为sudo是系统管理指令,所以需要输入电脑密码(输入字符时不会显示,输入完成敲击回车即可)

在终端中输入如下命令,查看Apache服务版本

sudo apachectl -v
在本机中版本信息如下

Server version: Apache/2.4.18 (Unix)
Server built:   Feb 20 2016 20:03:19
在浏览器中输入如下网址,检查Apache服务是否启动成功

http://localhost
http://127.0.0.1
如果Apache服务启动成功,页面会显示It works!



Apache的其他配置
关闭Apache服务

在终端中输入如下命令,关闭Apache服务

sudo apachectl stop
重启Apache服务

在终端中输入如下命令,重启Apache服务

sudo apachectl restart
Apache服务安装路径

Apache服务默认安装路径在/private/etc/apache2,属于系统私有目录,我们不可直接在Finder中找到该路径
————————————————



我们可以通过两种方式进入该路径

在终端中输入open /etc命令进入etc文件夹
在Finder -> 前往 -> 前往文件夹中输入/etc即可进入etc文件夹
Apache服务部署路径

Apache服务部署路径在/资源库/WebServer/Documents/,我们的项目需要放置在该路径下
————————————————
如果想要修改部署路径,可以在/private/etc/apache2目录下找到并打开httpd.conf文件,搜索DocumentRoot并修改部署路径

注1: 笔者使用Sublime Text软件进行PHP开发,且该软件可以直接打开该配置文件

注2: 如果提示文本锁定不允许修改,可以将该文件复制到其他文件夹修改之后,在粘贴回来覆盖原文件即可



Apache服务端口号

Apache服务端口号默认为80,如果想要修改端口号,可以在/private/etc/apache2目录下找到并打开httpd.conf文件,搜索Listen 80并修改端口号
————————————————



Mac系统也是自带了php的，是不是瞬间感觉Mac系统真的是大爱啊，不用像windows那么麻烦去配置。既然系统已经自导了php，那么我们只需要在Apache的配置文件中添加Apache对php的支持就可以了，接下来交给我们的终端：
编辑http.conf配置文件，命令为：sudo vim /etc/apache2/httpd.conf，接下来输入电脑的密码就可以进到配置文件当中，然后不断往后翻，直到找到LoadModule php7_module libexec/apache2/libphp5.so，如下图所示。然后按下键盘的i，进入修改模式，将LoadModule php7_module libexec/apache2/libphp5.so前面的注释(也就是#号去掉)，然后按键盘的esc，再输入:wq，回车。保存并退出，就可以了。
Snip20160811_4.png

然后在终端输入 php -v命令来查看当前php的版本
Snip20160811_5.png
配置完后，重启下Apache，sudo apachectl restart。然后在终端输入命令open /Library/WebServer/Documents，此目录为Apache的目录，在此目录下我们新建一个测试文件(记为hello.php)来测试Apache是否和php关联好。<?php phpinfo(); ?>，记得文件的后缀名为.php，然后在浏览器Safari中输入localhost/hello，如果出现下面的页面，则说明关联成功，可以进入下一步了。如果不是，则需要检查哪一步错误，然后重新进行正确的配置。
 