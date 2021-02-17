# Lsn16.Flutter开源中国实战三

[TOC]

## Flutter嵌入到安卓代码中



### 1.创建Android和flutter工程

Android工程和Flutter工程是同级的

```
你的项目根目录
  ├── 原生安卓工程
  └── Flutter工程
```
Android项目是正常创建
Flutter项目是创建module工程

### 2.在安卓的setting.gradle中引入依赖
```
include ':app'

//加入下面配置
setBinding(new Binding([gradle: this]))
evaluate(new File(
        settingsDir.parentFile,
        'flutter工程名称/.android/include_flutter.groovy'
))
```
### 3.在app的build.gradle文件中加入工程依赖
```
dependencies {
    ...

    // 加入下面配置
    implementation project(':flutter')
}
```
### 4.在安卓中添加下面代码即可调用flutter

```
//创建flutterView
FlutterView flutterView = Flutter.createView(this, getLifecycle(), "route1");

//添加到根view
addContentView(flutterView, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
```

