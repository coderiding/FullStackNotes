# git的如何删除git中的dsStore

```
如何删除GIT中的.DS_Store 
<http://www.jianshu.com/p/fdaa8be7f6c3> 

删除项目中的所有.DS_Store。这会跳过不在项目中的 .DS_Store 
1.find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch 
将 .DS_Store 加入到 .gitignore 
2.echo .DS_Store >> ~/.gitignore 
更新项目 
3.git add --all 
4.git commit -m '.DS_Store banished!’ 

find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch 
echo .DS_Store >> ~/.gitignore 
git add --all 
git commit -m '.DS_Store banished!' 

禁用或启用自动生成 
禁止.DS_store生成： 
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE 

恢复.DS_store生成：恢复.DS_store生成： 

defaults delete com.apple.desktopservices DSDontWriteNetworkStores 

```