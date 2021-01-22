Checkout 和 pull 的区别？

[http://www.ruanyifeng.com/blog/2014/06/git_remote.html](http://www.ruanyifeng.com/blog/2014/06/git_remote.html)

```
git fetch ：相当于是从远程获取最新版本到本地，不会自动 merge  
默认情况下， git fetch 取回所有分支（ branch ）的更新。如果只想取回特定分支的更新，可以指定分支名。  
git fetch < 远程主机名 > < 分支名 >  
取回 origin 主机的 master 分支  
git fetch origin master  

git branch 命令的 -r 选项，可以用来查看远程分支， -a 选项查看所有分支。  
git branch -r  
git branch -a  

git pull ：相当于是从远程获取最新版本并 merge 到本地  
git pull 命令的作用是，取回远程主机某个分支的更新，再与本地的指定分支合并。  
git pull < 远程主机名 > < 远程分支名 >:< 本地分支名 >  
取回 origin 主机的 next 分支，与本地的 master 分支合并，需要写成下面这样。  

git pull origin next:master  
如果远程分支是与当前分支合并，则冒号后面的部分可以省略。  
git pull origin next  
这等同于先做 git fetch ，再做 git merge 。  

git fetch origin  

git merge origin/next  

git checkout 命令作用是创建一个新的分支    
使用 git merge 命令或者 git rebase 命令，在本地分支上合并远程分支  

git merge origin/master  
或者  

git rebase origin/master  
命令表示在当前分支上，合并 origin/master 

```

如果 git pull 提示 “no tracking information” ？