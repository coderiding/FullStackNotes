# Cocoa Pods-更新

cocoapods 更新指定的库
```
pod install / update  --verbose --no-repo-update

pod update MJRefresh
```

---

如果你执行的时候出现了Updating local specs repositories提示
```
pod update MJRefresh  --verbose --no-repo-update
pod update FLEX  --verbose --no-repo-update

pod update 库名 --verbose --no-repo-update
```

该命令只更新指定的库，其它库忽略
```
pod install --verbose --no-repo-update
```
该命令只安装新添加的库，已更新的库忽略