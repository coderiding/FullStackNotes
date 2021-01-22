# 集成gitSvn的github命令小结

> 如果你是初学者，可以按照步骤来，这是一个记录贴，方便查询代码；

## 初步建立GitHub仓库的一些命令：

```
touch README.md  // 新建说明文件 

ssh-keygen -t rsa -C "your_email@youremail.com" // 创建本地的keygen 

cd ~/.ssh // 进入创建好keygen的文件 

用cat id_rsa.pub来查看keygen，然后再把它复制到你的github 

```

<!--more-->

```
ssh -T git@github.com // 这个是测试一下连接； 

git config --global user.name "your name" 

git config --global user.email "your_email@youremail.com" 

git init // 在当前项目目录中生成本地git管理,并建立一个隐藏.git目录 

git add . // 添加当前目录中的所有文件到索引 

git commit -m "first commit"  // 提交到本地源码库，并附加提交注释 

git remote add origin https: // github.com/chape/test.git // 添加到远程项目，别名为origin 

git push -u origin master  // 把本地源码库push到github   别名为origin的远程项目中，确认提交 

```

## 开发前

### 1.拉取最新代码

```
git pull origin master // 从Github上pull到本地源码库 
//或者
git pull

```

## 开发后

### 1.编码后提交代码

```
cd / 到你要更新的目录下 
git add . 
git commit -m "update test" // 检测文件改动并附加提交注释 
git push -u origin master // 提交修改到项目主线 

```

### 2.查看提交历史

```
//会按提交时间列出所有的更新，最近的更新排在最上面
git log

//常用 -p 选项展开显示每次提交的内容差异，用 -2 则仅显示最近的两次更新：
git log -p -2

```

### 3.查看文件的改动

```
// 可以查看本地的改动，即git status看到的文件的具体改动
git diff 

// 看两个版本之间有哪些文件改动
git diff commit-id1 commit-id2 --stat

// 看两个分支之间有哪些文件差异
git diff branch1 branch2 --stat

// 看两个分支之间有哪些文件差异
git diff tag1 tag2 --stat

```

### 4.撤销文件改动

```
git checkout . #本地所有修改的。没有的提交的，都返回到原来的状态

git stash #把所有没有提交的修改暂存到stash里面。可用git stash pop回复。
git reset --hard HASH #返回到某个节点，不保留修改。
git reset --soft HASH #返回到某个节点。保留修改

git clean -df #返回到某个节点
git clean 参数
    -n 显示 将要 删除的 文件 和  目录
    -f 删除 文件
    -df 删除 文件 和 目录
    
git checkout . && git clean -xdf

----------------------------------------
写完代码后，我们一般这样
git add . //添加所有文件
git commit -m "本功能全部完成"
执行完commit后，想撤回commit，怎么办？

--mixed 
意思是：不删除工作空间改动代码，撤销commit，并且撤销git add . 操作
这个为默认参数,git reset --mixed HEAD^ 和 git reset HEAD^ 效果是一样的。

--soft  
不删除工作空间改动代码，撤销commit，不撤销git add . 

--hard
删除工作空间改动代码，撤销commit，撤销git add . 
注意完成这个操作后，就恢复到了上一次的commit状态。

顺便说一下，如果commit注释写错了，只是想改一下注释，只需要：
git commit --amend
此时会进入默认vim编辑器，修改注释完毕后保存就好了。

```

### 5.查看某个类或文件每行是谁改动的

```
$ git blame <filename>
$ git blame -L 100,100 <filename>
$ git blame -L 100,+10 <filename>

$ git log -L start,end:file
$ git log -L 155,155:git-web--browse.sh
```

## 冲突

```
// 查看冲突
git status
```

## 分支创建、切换、合并、删除、拉取

### 分支查看

```
1.查看本地分支
git branch

2.查看远程分支

3.查看全部分支{包括远程和本地}
git branch -a
```

### 1.分支创建

```
1.创建本地分支dev，
git checkout -b dev// 添加一个名为dev的分支

2.推送分支dev远程
git push origin dev:dev
```

- git checkout命令加上-b参数表示创建并切换，相当于以下两条命令：

```
$ git branch dev
$ git checkout dev
Switched to branch 'dev'
```

### 2.分支切换

```
git checkout master // 切换到主分支 
git checkout dev // 切换到子分支 
```

### 切换分支到指定的提交（commit）

```
git checkout cbcf45ec166e
```

### 3.分支合并

```
git merge host // 合并分支host到主分支

git merge dev // 将dev合并到master
```

- 切换回master分支后,到master分支上把dev合并过来

```
git merge dev // 将dev合并到master
```

### 4.分支删除

```
git branch -d host // 删除分支host 

或者
git push origin --delete dbg_lichen_star

或者
git branch -r -d origin/branch-name

或者
//推送一个空分支到远程分支，其实就相当于删除远程分支：
git push origin :dbg_lichen_star
git push origin :branch-name
```

### 5.分支拉取

```
git checkout -b v0.9rc1 origin/v0.9rc// 拉取远程版本到本地

git checkout -b dev(本地分支名称) origin/dev(远程分支名称)

// 指定分支git clone
git clone -b dev_jk <http://10.1.1.11/service/tmall-service.git>
```

- 根据某个commit创建本地分支
- 当前分支的某个commit id = 12345678，我们可以基于这个id创建本地分支

```
git checkout 12345678 -b newBranch
```

## 分支Tag

### 查看本地分支标签

```
git tag

或者

git tag -l

或者

git tag --list
```

### 查看远程所有标签

```
git ls-remote --tags

或者

git ls-remote --tag
```

### 给当前分支打标签

```
git tag 《标签名》

例如

git tag v1.1.0
```

### 给特定的某个commit版本打标签，比如现在某次提交的id为 039bf8b

```
git tag v1.0.0 039bf8b
git push origin --tags
或者可以添加注释

git tag v1.0.0 -m "add tags information" 039bf8b

或者

git tag v1.0.0 039bf8b -m "add tags information"
```

### 删除本地某个标签

```
git tag --delete v1.0.0

或者

git tag -d v1.0.0

或者

git tag --d v1.0.0
```

### 删除远程的某个标签

```
git push -d origin v1.0.0

或者

git push --delete origin v1.0.0

或者

git push origin -d v1.0.0

或者

git push origin --delete v1.0.0

或者

git push origin :v1.0.0
```

### 将本地标签一次性推送到远程

```
git push origin --tags

或者

git push origin --tag

或者

git push --tags

或者

git push --tag
```

### 将本地某个特定标签推送到远程

```
git push origin v1.0.0
```

### 查看某一个标签的提交信息

```
git show v1.0.0
```

### 后期进阶用到的GitHub命令：

```
git push origin master // 把本地源码库push到Github 
git config --list // 查看配置信息 
git status // 查看项目状态信息 
git branch // 查看项目分支 
git branch -a 查看远程分支
git fetch origin dev（dev为远程仓库的分支名）
git checkout -b host// 添加一个名为host的分支 
git checkout -b v0.9rc1 origin/v0.9rc // 
git checkout master // 切换到主分支 
切换到develop 分支  git checkout develop
git merge host // 合并分支host到主分支
git branch -d host // 删除分支host 

删除远程分支
git branch -r -d origin/branch-name
git push origin :branch-name

在本地创建分支dev并切换到该分支
git checkout -b dev(本地分支名称) origin/dev(远程分支名称)

下载指定分支的代码
使用Git下载指定分支命令为：git clone -b 分支名仓库地址
使用Git下载v.2.8.1分支代码，使用命令：git clone -b v2.8.1 <https://git.oschina.net/oschina/android-app.git>

git clone -b zch <https://git.281.com.cn/wyapp/wybb_user.git>
git clone  <http://10.1.1.11/service/tmall-service.git> //git clone 不指定分支
git clone -b dev_jk <http://10.1.1.11/service/tmall-service.git>  //git clone 指定分支
```

- 持续更新,逐步完善...*

### 报错The following untracked working tree files would be overwritten by checkout

```
// 清除一下，其实git clean -d -fx表示：删除 一些 没有 git add 的 文件；
git clean -d -fx
```

### 最近更新说明：

- 2015.10.16 终于知道了怎么同步远程仓库到本地。
- 2016.06.03 把文章迁移过来

> 桃之夭夭，灼灼其华，之子于归，宜其室家。 —— 《诗经·周南·桃夭》

[github常用命令](https://www.notion.so/github-3772018ad80249438bcc86fe39f96ee8)

[gitee常用命令](https://www.notion.so/gitee-0e730e4b436a4bc8984670fecf14b4cc)