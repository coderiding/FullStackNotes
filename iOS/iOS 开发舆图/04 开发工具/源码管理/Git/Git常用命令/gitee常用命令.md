## MarXTools 常用

---

```
git add .  
git commit  -m  'fix nsdate category'  
git push -u origin master  
git tag 1.1.8 
git push  --tags  

/// 同步本地和服务器，将本地上传到MarXRepo服务器 
pod repo push MarXRepo MarXTools.podspec 
pod repo push MarXRepo MarXTools.podspec --allow-warnings 
```

---

## MarXToolsSwift 常用

```
git add .  
git commit  -m  'change toaster to local because swift4.2'  
git push -u origin master  
git tag 1.1.8 
git push  --tags  

/// 同步本地和服务器，将本地上传到MarXRepo服务器 
pod repo push MarXRepo MarXToolsSwift.podspec 
pod repo push MarXRepo MarXToolsSwift.podspec --allow-warnings 
```

---

## 每次更新podspec文件都要验证一下

```
pod lib lint  --private  
pod lib lint  --private --allow-warnings 
pod lib lint  --private --allow-warnings --verbose 查看的更加细 
```

- 切换版本的时候注意打开那个swift-version的文件，看看有没有其他版本，有时候有冲突
- swift-version 是隐藏在你的项目中的

---

支持swift4.2

```
echo "4.2" >> .swift-version 
```