## 每次更新podspec文件都要验证一下

```
pod lib lint  --private    
pod lib lint  --private --allow-warnings   
```

## MarXTools 常用

---

// 描述最好自己手输

```
git add .    

git commit  -m  “fix nsdate am” 

git push -u origin master    
git tag 1.2.4 
git push  --tags    

最后使用 pod trunk 命令，把 podspec 文件推送到 CocoaPod 官方库 
/// 同步本地和服务器,将本地的上传到cocopod服务器     
pod trunk push MarXTools.podspec --allow-warnings   

pod repo update   
```

---

## MarXToolsSwift 常用

```
git add .    
git commit  -m  'fix double extension'    
git push -u origin master    
git tag 1.2.0   
git push  --tags    

/// 同步本地和服务器,将本地的上传到cocopod服务器     
pod trunk push MarXToolsSwift.podspec --allow-warnings   

pod repo update   
```

---