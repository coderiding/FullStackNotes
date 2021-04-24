# Lsn9.flutter的动画及其常用控件



[TOC]



## 动画

### Flutter动画分为两类：
1. 补间动画（Tween Animation）
2. 基于物理的动画（Physics-based animation）

### animation.dart   
Animation类--包含当前值和状态两个属性。定义了动画的一系列回调。

### tween.dart--估值器
Flutter通过抽象类Animatable来实现估值器
```
//不同类型的估值器
ReverseTween
ColorTween
SizeTween
RectTween
IntTween
StepTween
ConstantTween
//还可以通过自定义的插值器去实现估值器，例如通过curve实现的估值器CurveTween。
```
### curves.dart--插值器
```
linear
decelerate
ease
easeIn
easeOut
easeInOut
fastOutSlowIn
bounceIn
bounceOut
bounceInOut
elasticIn
elasticOut
elasticInOut
```
##### _Linear--线性

##### SawTooth--循环

//锯齿循环count次。从0.0到1.0线性变化，然后直接恢复到0.0，循环count次
```
const SawTooth(this.count) : assert(count != null);
```
##### Interval--延时

```
//用于延时，例如一个6秒的动画，设置begin为0.5，end为1.0，则动画将于3秒后开始，执行3秒
const Interval(this.begin, this.end, { this.curve = Curves.linear })
      : assert(begin != null),
        assert(end != null),
        assert(curve != null);
```
##### Cubic--创建一个三次曲线

```
const Cubic(this.a, this.b, this.c, this.d)
      : assert(a != null),
        assert(b != null),
        assert(c != null),
        assert(d != null);
```
##### Threshold--阈值

曲线为0.0，直到达到阈值，然后跳到1.0。
##### FlippedCurve--翻转

##### _DecelerateCurve--减速

### animation_controller.dart
#### AnimationController--动画的控制
1. 派生自Animation类
2. 构造函数中需要一个TickerProvider参数。
3. AnimationController在不使用的时候需要dispose，否则会造成资源的泄漏。

##### TickerProvider

它的主要作用是获取每一帧刷新的通知，相当于给动画添加了一个动起来的引擎。



### animations.dart
#### CurvedAnimation--动画的插值器



### transitions.dart
##### AnimatedWidget



### implicit_animations.dart
##### AnimatedContainer



## 常用控件

TextField、TextFormField、FlatButton、RaiseButton、CircleAvatar、Chip、SnackBar



ProgressIndicator--进度条

ProgressIndicator是个抽象类

LinearProgressIndicator--线性进度条

LinearProgressIndicator主要用于明确刻度的进度表示

CircularProgressIndicator--圆形进度条

CircularProgressIndicator主要用于未知刻度的进度表示