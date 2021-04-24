速度  git  代理

* 提升github速度

git config --global http.proxy socks5://127.0.0.1:7890
git config --global http.https://github.com.proxy socks5://127.0.0.1:7890

* 恢复速度

git config --global --unset http.proxy
git config --global --unset http.https://github.com.proxy



git 回滚到之前某一commit

git log
git reset –hard 8ff24a6803173208f3e606e32dfcf82db9ac84d8



---------------------

GitHub下载克隆clone指定的分支tag代码

命令：git clone --branch [tags标签] [git地址] 或者 git clone --b [tags标签] [git地址]

例如：git clone -b 3.5.0 https://github.com/danielgindi/Charts.git


git clone --depth 1 --branch 3.5.0 https://github.com/danielgindi/Charts.git