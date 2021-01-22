自己常用

```
svn update 先更新  

svn commit -m “ 描述 ” 提交  

查看某个分支具体改了什么东西  

```

---

常用命令

```
svn add file|dir -- 添加文件或整个目录    
svn checkout -- 获取 svn 代码    
svn commit  -- 提交本地修改代码    
svn status    -- 查看本地修改代码情况：修改的或本地独有的文件详细信息    
svn merge   -- 合并 svn 和本地代码    
svn revert   -- 撤销本地修改代码    
svn resolve -- 合并冲突代码    
svn help [ command ] -- 查看 svn 帮助，或特定命令帮助    

svn resolved   [ 本地目录全路径]  

svn log            展示给你主要信息：每个版本附加在版本上的作者与日期信息和所有路径修改。  
svn diff            显示特定修改的行级详细信息。  
svn cat            取得在特定版本的某一个文件显示在当前屏幕。  
svn list            显示一个目录在某一版本存在的文件。  

更新到某个版本  
svn update -r m path  

svn diff path ( 将修改的文件与基础版本比较)  
svn diff -r m:n path ( 对版本 m 和版本 n 比较差异)  

将两个版本之间的差异合并到当前文件  
svn merge -r m:n path  

svn update  
   

```

---

例子：

```
svn update                                后面没有目录，默认将当前目录以及子目录下的所有文件都更新到最新版本  

svn update -r 200test.cpp       将版本库中的文件 test.cpp 还原到修正版本（ revision ） 200    

svn update test.php                 更新与版本库同步。  

```

提交的时候提示过期冲突，需要先 update 修改文件，然后清除 svn resolved ，最后再提交 commit

---

# svn的使用小结

## 显示和隐藏文件

1. 显示系统隐藏文件命令

```
defaults write com.apple.finder AppleShowAllFiles -bool true 

```

## 为什么要使用Git

1.Git 的常用命令
1 ）git version : 查看电脑GIT的版本

---

2.Git 工具安装
1 ）如果你下载了Xcode，直接检查Git的版本
2 ）如果你没有Xcode，直接单独下载Git

<!--more-->

## 为什么要使用SVN

1. 没有使用SVN前
- 无法后悔：做错了一个操作后，没有后悔药可以吃
- 版本备份：费空间、费时间
- 版本混乱：因版本备份过多造成混乱，难于找回正确的想要的版本
- 代码冲突：多人操作同一个文件（团队开发中的常见问题）
- 权限控制：无法对源代码进行精确的权限控制
- 追究责任：出现了严重的BUG，无法得知是谁干的，容易耍赖

---

1. 使用SVN后
- 能追踪一个项目从诞生一直到定案的过程
- 记录一个项目的所有内容变化
- 方便地查阅特定版本的修订情况

---

3.SVN 工具

- CVS ：开启版本控制之门，1990年诞生，“远古时代”的主流源代码管理工具
- SVN ：集中式版本控制。是CVS的接班人，速度比CVS快，功能比CVS多且强大。在国内使用率非常高（70%~90%）。
- GIT ：分布式版本控制。目前被越来越多的开源项目使用，不过在国内企业尚未大范围普及。gitHub上的代码就是用git管理的。

---

1. 使用SVN基本操作
- 下载服务器代码
- 修改本地代码
- 提交本地代码

---

5.SVN 常用命令

- svn checkout ：将服务器代码完整的下载到本地
- svn commit ：将本地修改的内容提交到服务器
- svn update ：将服务器最新代码下载到本地
- svn delete ：从本地的版本控制库中删除文件
- svn remove ：从本地的版本控制库中删除文件
- 注意：Checkout只需要做一次
- 提醒：每天下班前：commit“可运行版本” 每天上班前：update前一天所有代码
- svn revert 可以用在：不小心写错了很多东西，想撤销所写的东西（还未把修改提交到服务器）
- svn revert 可以用在2：不小心删错了文件，想把文件恢复回来（还未把删除提交到服务器）
- svn update -r 版本号 可以用在：不小心写错了很多东西，想撤销所写的东西（已经把修改提交到服务器）
- svn update -r 版本号 可以用在2：不小心删错了文件，想把文件恢复回来（已经把删除提交到服务器）

---

1. 搭建SVN服务器
- 服务器用途
- 用于存储客户端上传的源代码
- 可以在Windows上安装Visual SVN Server
- 大部分情况下，公司的开发人员不必亲自搭建SVN服务器

---

1. 搭建SVN客户端
- 上传本地的源代码到服务器，或者更新服务器的代码到本地，保持同步
- 可以在Mac上使用命令行、Versions、Cornerstone、Xcode
- 开发人员就属于客户端这个角色

---

8.commit 代码的时候选择要忽略的文件

- 以下三个需要忽略的信息，都在xcuserdata 文件夹下，所以只需要忽略xcuserdata文件夹。
- Xcode 默认会记住我们当前正在编辑的文件，也就是上次退出项目时停留的文件，下次打开项目会停留在该文件。我们不需要把这些信息共享给同事，所以需要忽略。
- Xcode 会记录目录的打开情况。同事不需要共享。
- 断点信息。同事不需要共享。

---

9.commit 代码产生冲突的解决办法

1 ）两个人前后都改了同一个位置的代码，先改代码的人先commit。后改代码的没有update就commit，此时就会产生冲突。例如：
2 ）经理->update->修改了第99行代码->commit；张三->修改了第99行代码->commit。此时就会冲突。

---

10.SVN 添加静态库报错

1 ）注意：静态库拖拽到项目中后，.a文件默认是I（ignore）的，但是.a文件是需要参与编译的，所以需要用命令行把.a文件添加到项目中，然后commit。

---

11.SVN 添加storyBoard报错

1 ）建议：尽量使用xib，这样可以避免多个人同时操作storyBoard。
2 ）在原来的Xcode版本中，svn对storyBoard的支持非常不好，鼠标点击一下xib或者storyBoard，xib或者storyBoard就会变成M。现在6.0版本之后，可以点击，但是不可以移动，如果移动xib或者storyBoard也会变为M。因为storyBoard本质是XML。
3 ）多个人同时修改storyBoard的后果，storyBoard冲突，导致storyBoard打不开。
4 ）和代码冲突类似，如果先往storyBoard的同一个位置添加了一个控件，并且后者在不知道前者在同一个位置添加了控件的情况下也再该位置添加了一个控件，那么两个控件在storyBoard上的位置冲突，后者commit会报错。

---

1. 使用SVN建议

1 ）尽可能修改文件之前先update文件，写一些代码后就立即提交到服务器
2 ）尽可能在下班之前半小时就提交代码，这样可以预留出来半小时解决可能存在的冲突
3 ）修改公共文件之前尽可能和同事说一声，修改完成后让同事及时更新，不要做哑巴式程序员，多沟通才能避免一些不必要的冲突和误会，不仅是体现出来对工作的认真，也是对同事的尊重

---

12.SVN 权限

- read only
- read/write

---

13.SVN 中文件状态

- ' ' 没有修改
- A 被添加到本地代码仓库
- C 冲突
- D 被删除
- I 被忽略
- M 被修改
- R 被替换
- X 外部定义创建的版本目录
- ? 文件没有被添加到本地版本库内
- ! 文件丢失或者不完整（不是通过svn命令删除的文件）
- ~ 受控文件被其他文件阻隔

## Git 和SVN区别？

1 ）Git是分布式的，SVN不是；
2 ）Git复杂，Git adds Complexity,刚开始使用会有些疑惑，因为需要建两个Repositories(Local Repositories & Remote Repositories),指令很多，除此之外你需要知道哪些指令在Local Repository，哪些指令在Remote Repository。
3 ）Git下载下来后，在本地不必联网就可以看到所有的log，很方便学习，SVN却需要联网；
4 ）SVN在Commit前，我们都建议是先Update一下，跟本地的代码编译没问题，并确保开发的功能正常后再提交，这样其实挺麻烦的，有好几次同事没有先Updata，就Commit了，发生了一些错误，耽误了大家时间，Git可能这种情况会少些。
5) Git 把内容按元数据方式存储，而SVN是按文件：
6) Git 没有一个全局的版本号，而SVN有
7) Git 的checkout是：而对于Git来说，尽管也有checkout命令，但是由于你需要在本地拥有仓库，所以通常从服务器上checkout代码的第一步是使用git clone来获取一个仓库的拷贝，默认的git clone操作同时还会checkout一份远程仓库上当前active的分支

## 参考链接

1.[http://www.cnblogs.com/wsnb/p/4765597.html](http://www.cnblogs.com/wsnb/p/4765597.html)
2.[http://www.cnblogs.com/wsnb/p/4771379.html](http://www.cnblogs.com/wsnb/p/4771379.html)
3.[http://www.jianshu.com/p/d3ebfa27b3ba](http://www.jianshu.com/p/d3ebfa27b3ba)
4.[http://blog.csdn.net/bruce_6/article/details/38299677](http://blog.csdn.net/bruce_6/article/details/38299677)
5.[http://blog.csdn.net/a117653909/article/details/8952183](http://blog.csdn.net/a117653909/article/details/8952183)
6.[http://www.jianshu.com/p/cf37ecd0c3a3](http://www.jianshu.com/p/cf37ecd0c3a3)