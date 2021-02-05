https://uizph.com/article/5db177e4a9f13d7f535810c5

### 安装
现MongoDB不再是开源，官方已经从Homebrew中移除，所以无法通过 brew install mongodb 安装，会提示 No available formula with the name "mongodb"，需使用最新的方法安装社区版。

现在开始安装MongoDB，根据需求选择安装的版本：

brew install mongodb-community   // 安装MongoDB社区服务器的最新可用生产版本
brew install mongodb-community@4.2   // 安装MongoDB最新4.2.x
brew install mongodb-community@4.0   // 安装MongoDB最新4.0.x

20210205最新
brew install mongodb-community@4.4

安装结束后，验证是否安装成功，可输入查看版本信息：

mongo -version

### 默认配置文件
正常情况下，不需要自己修改配置，直接用默认配置即可

配置文件：/usr/local/etc/mongod.conf
日志目录路径：/usr/local/var/log/mongodb
数据目录路径：/usr/local/var/mongodb

### 启动和停止服务器
有两种启动方式，使用brew服务启动、手动启动；同时注意的是，用什么方式启动的，就用什么方式停止，否则有可能出现下次无法启动的问题
1.使用brew服务启动，此方式启动，会自动后台运行，关闭终端不影响运行（推荐！）

sudo brew services start mongodb-community  // 启动
sudo brew services stop mongodb-community  // 停止
sudo brew services restart mongodb-community  // 重启
2.手动启动，如果不想或不需要后台MongoDB服务，可手动启动，关闭终端服务器会停止运行

sudo mongod --config /usr/local/etc/mongod.conf
注意：如果不包含 --config 带有配置文件路径的选项，则MongoDB服务器没有默认配置文件或日志目录路径，并将使用数据目录路径/data/db。不推荐使用不带配置文件的启动方式，数据容易丢失！（今天更新Mac OS至10.15.1版本，惊讶的发现/data/db文件夹消失了！！就这么消失了！！！重新创建文件夹提示 mkdir: /data/db: Read-only file system ！直接哭了。。。）

验证服务器是否启动成功，打开浏览器输入地址：

localhost:27017
启动成功的话，浏览器会显示： It looks like you are trying to access MongoDB over HTTP on the native driver port. 

### 启动异常说明
1.启动时提示‘exception in initAndListen: NonExistentPath: Data directory /data/db not found., terminating’

未加--config启动，使用的dbPath是 /data/db ，不存在或没有创建这个文件件的话或报这个错误。

输入：

sudo mkdir -p /data/db
创建db文件可解决！

2.启动报‘exception in initAndListen: DBPathInUse: Unable to lock the lock file: (Unknown error). Another mongod instance is already running on the /data/db directory, terminating.’

mongodb非正常关闭，删除mongod.lock文件即可，然后重启

sudo rm /data/db/mongod.lock
3.输入启动命令没有任何反应

大部分是Mac系统权限的问题，启动的时候加入 sudo 尝试
