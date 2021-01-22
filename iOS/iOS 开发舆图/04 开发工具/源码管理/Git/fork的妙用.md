# github的fork的妙用

## 你先改改别的开源项目

- 比如你想改别人的项目，但不想下载到本地，也想用pod管理
- 这时你就可以用fork功能
- 点击github上的fork，下载项目，直接改变开源的代码
- 然后打tag，上传
- 最后在项目中应用，具体引用的命令例子

```
pod ' 库名', :podspec => 'podspec文件路径'指定导入库的podspec文件路径 

pod ' 库名', :tag => 'tag名'指定导入库的Tag分支 

pod ' 库名', :Git => '源码git地址'指定导入库的源码git地址 

pod 'TTADataPickerView', :git => '<https://github.com/KameraSui/TTADataPickerView.git>' 
```