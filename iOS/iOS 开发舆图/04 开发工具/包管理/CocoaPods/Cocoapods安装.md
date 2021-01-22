# 一、怎么安装旧版的Cocoapods

[How to downgrade or install an older version of Cocoapods](https://stackoverflow.com/questions/20487849/how-to-downgrade-or-install-an-older-version-of-cocoapods)

1.移除现在的

```
sudo gem uninstall cocoapods
```

2.安装指定版本的

```
sudo gem install cocoapods -v 0.25.0
```

3.使用旧版的初始化

```
pod 0.25.0 setup
```