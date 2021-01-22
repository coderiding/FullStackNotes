## ERROR | [iOS] xcodebuild: Returned an unsuccessful exit code. You can use `-verbose` for more information.

原因就是我的库的某个头文件中直接import了第三方库（我对它有依赖）的头文件，我采用了前向声明的方式解决。

---

- 总结：不仅要看库的版本，还要看项目支持的版本

```
[!] Unable to satisfy the following requirements: 

- `AFNetworking (~> 2.3.1)` required by `Podfile` 

Specs satisfying the `AFNetworking (~> 2.3.1)` dependency were found, but they required a higher minimum deployment target. 

解决方案：Podfile 文件 中   platform:ios, ‘8.0’   后边的 8.0 是平台版本号 ，一定要加上 

```

- [https://www.jianshu.com/p/071d30a3af02](https://www.jianshu.com/p/071d30a3af02)

---

- wift_version: The validator for Swift projects uses S
- [https://www.jianshu.com/p/e5209ac6ce6b](https://www.jianshu.com/p/e5209ac6ce6b)
- swift 版本不对
- 使用echo "3.0" > .swift-version命令即可。

```
[!] The validator for Swift projects uses Swift 2.3 by default, if you are using a different version of swift you can use a `.swift-version` file to set the version for your Pod. For example to use Swift 3.0, run: 
    `echo "3.0" > .swift-version`. 

```

---

目录：

```
• You can use the `--no-clean` option to inspect any issue.  
• 记得设置［ LWExtension.podspec ］为平台只支持 ioS ，如果不设置，会报错  
•[ ! ] The validator for Swift projects uses Swift 3.0 by default , if you are u    
• Add LWExtension podspec file  
• 开始推送 pod  
• 发布自己的 pods 到 CocoaPods trunk 及问题记录    
• 确保你所 push 的代码已经打上 "version tag" ，也就是给源代码打上版本号标签：  
• iOS 开发 CocoPods 支持报错： [ ! ] Unable to accept duplicate entry for: XXXXX ( 0.0.1 )    
• [ ! ] There was an error pushing a new version to trunk: getaddrinfo: nodename nor servname provided , or not known    

```

[ ! ] The validator for Swift projects uses Swift 3.0 by default , if you are u
echo 3.0 > .swift-version

[ ! ] There was an error pushing a new version to trunk: getaddrinfo: nodename nor servname provided , or not known
解决办法：翻墙提交就可以了；看到这个错，造成的原因是 DNS 的设置问题，解决办法，将 DNS 改成 114.114.114.114

iOS 开发 CocoPods 支持报错： [ ! ] Unable to accept duplicate entry for: XXXXX ( 0.0.1 )
解决办法：每次都需要 git tag

确保你所 push 的代码已经打上 "version tag" ，也就是给源代码打上版本号标签：
git tag '1.0.0'
git push --tags

---

## 遇到问题：

Add LWExtension podspec file ，通过 github 提交会报下面的错误
Back in early 2014 we launched CocoaPods Trunk . Trunk is the only way that you can submit pods to CocoaPods , we do not accept pull requests to the CocoaPods Specs repo , and so this is being auto-closed. Please see #12199  for more info.

- To push a new version to trunk , you can use pod trunk push.
• You cannot amend an existing pod , however you can delete and deprecate a pod. You need to be using CocoaPods 1.0 to have access to pod trunk delete and pod trunk deprecate. People may be relying on your pod version , so use these with caution.
• If you don't have permission to update a pod that you own , please file a claim on trunk.

解决方案：
发布自己的 pods 到 CocoaPods trunk

---

## 遇到问题：

You can use the `--no-clean` option to inspect any issue.
解决方案：
使用命令

pod lib lint --allow-warnings

---

## 遇到问题：

记得设置［ LWExtension.podspec ］为平台只支持 ioS ，如果不设置，会报错

[ ! ] The validator for Swift projects uses Swift 3.0 by default , if you are u
解决方案：
使用命令

echo 3.0 > .swift-version