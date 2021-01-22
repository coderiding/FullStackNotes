- svn 版本管理工具
- working copy 会显示修改数量
    - 白色数量为别人修改数量
    - 灰色数量为自己修改数量
- 忽略提交的文件：Cornerstone——>Preference——>Subversion——>Global ignores中添加，去掉“use default global ignores”即可。

```
//xcode 本身的文件 

.xcuserdatad,.xcscmblueprint,xcuserdata, 

//pods 文件夹和锁定 

Pods,Podfile.lock 
```

- 总结:不要提交.xcworkspace的文件,图片的新增和删除直接提交,文件的新增和删除要和project.pbxproj一起提交。
(如果你在新增或删除文件是没有提交project.pbxproj,只提交了文件,项目不会有问题。
但是需要更新之后的人手动去找到要删除的文件目录,或者手动去找到要添加文件的模块添加文件进去)