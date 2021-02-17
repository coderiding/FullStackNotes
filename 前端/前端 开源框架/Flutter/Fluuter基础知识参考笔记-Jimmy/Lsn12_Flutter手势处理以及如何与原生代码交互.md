# Lsn12.Flutter手势处理以及如何与原生代码交互



[TOC]

## 手势事件处理

在Flutter中的手势事件分为两层：  第一层原始指针事件，描述了屏幕上的指针，例如，触摸，鼠标或者触控笔在屏幕上的位置和移动。  第二层手势，描述了一个或多个指针组成的动作(多点触控)。 

### 指针(Pointers)

指针代表了用户和屏幕之间的交互，有四种类型的指针事件： 

1. PointerDownEvent 指针已经开始和屏幕接触 
2. PointerMoveEvent 指针已经从屏幕上的一个位置移动到另一个位置。 
3. PointerUpEvent 指针停止接触屏幕。 
4. PointerCancelEvent 此指针的输入不再针对此应用。

### 手势(gestures)

手势可以从多个单独的指针中识别出例如点击,拖动，缩放这种动作,手势可以分派多个事件,对应于手势的生命周期(例如开始滑动，滑动,滑动结束) 

源码

```
GestureDetector({
    Key key,
    this.child,
    this.onTapDown,//单击按下
    this.onTapUp,//单击抬起
    this.onTap,//点击(按下+抬起)
    this.onTapCancel,//单击取消
    this.onDoubleTap,//双击
    this.onLongPress,//长按
    this.onVerticalDragDown,//与屏幕接触，也许在垂直方向上开始了移动
    this.onVerticalDragStart,//与屏幕接触，并且垂直方向开始移动。
    this.onVerticalDragUpdate,//与屏幕接触，并且垂直方向上正在移动
    this.onVerticalDragEnd,//垂直移动结束,停止触摸屏幕，并且在停止接触屏幕时以特定速度移动。
    this.onVerticalDragCancel,//取消垂直移动，先前触发[onVerticalDragDown]的指针未完成。
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onPanDown,//与屏幕接触，也许开始移动
    this.onPanStart,//与屏幕接触，也许开始移动
    this.onPanUpdate,//与屏幕接触并移动的指针再次移动。
    this.onPanEnd,//屏幕接触并移动的指针不再与屏幕接触，并且在停止接触屏幕时以特定速度移动。
    this.onPanCancel,//先前触发[onPanDown]的指针没有完成
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.behavior,
    this.excludeFromSemantics: false
  })
```

## 事件流

Flutter框架事件的源头就在gestures/binding.dart里的GestureBinding类开始：



## 调用平台代码

Flutter平台特定的API支持不依赖于代码生成，而是依赖于灵活的消息传递的方式，允许调用特定平台的API：  在客户端，MethodChannel 可以发送与方法调用相对应的消息。 在宿主平台上，MethodChannel 在Android(API) 和 FlutterMethodChannel在iOS (API) 可以接收方法调用并返回结果。 

![channel](channel.jpg)

### 调用原生API--MethodChannel

需要导入：import 'package:flutter/services.dart'; 

### 获取系统的回调与监听--EventChannel

