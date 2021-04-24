---
title: 使用UIBezierPath贝塞尔曲线配合CAShapeLayer抠图
tags:
  - 动画
  - 贝塞尔
categories: 技术改变世界
abbrlink: 55740
date: 2018-09-01 12:01:03
---

2017.12.27

### 系统提供的UIBezierPath构造方法

先来看看构造方法列表，以及构造出来的形状，具体详见后面的示例及图片。

1、矩形

```
+ (instancetype)bezierPathWithRect:(CGRect)rect;
```

2、内切圆，即椭圆

```
+ (instancetype)bezierPathWithOvalInRect:(CGRect)rect;
```

3、圆角矩形

```
+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius; // rounds all corners with the same horizontal and vertical radius
，可设置圆角的半径
```

4、部分圆角的矩形

```
+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
```

<!-- more -->

```undefined
* rect: 矩形frame
* corners: 要画成圆角的部位
* cornerRadii: 圆角的大小
```

5、圆弧

```
+ (instancetype)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;
```



```undefined
* center: 圆心坐标
* radius: 圆的半径
* startAngle: 起点角度
* endAngle: 终点角度
* clockwise: 是否顺时针
```

6、指定路径

```
+ (instancetype)bezierPathWithCGPath:(CGPathRef)CGPath;
```

### 配合CAShapeLayer

利用CAShapeLayer，能画出各种形状，只需要将UIBezierPath的CGPath赋予CAShapeLayer的path即可。

#### 代码示例

```objectivec
// 要抠的透明区域位置
CGRect cutFrame = CGRectMake(0, 200, self.view.bounds.size.width, 400);
UIBezierPath *cutPath1 = [UIBezierPath bezierPathWithRect:cutFrame];//图1 - 普通矩形
/*
 UIBezierPath *cutPath2 = [UIBezierPath bezierPathWithRoundedRect:cutFrame cornerRadius:20];//图2 - 圆角为20的圆角矩形
 UIBezierPath *cutPath3 = [UIBezierPath bezierPathWithRoundedRect:cutFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];//图3 - 左上和右上为圆角20的部分圆角矩形
 UIBezierPath *cutPath4 = [UIBezierPath bezierPathWithOvalInRect:cutFrame];//图4 - 内切圆（椭圆）
 */

// 要抠透明区域的原图
CGRect viewFrame = self.view.bounds;
UIBezierPath *viewPath = [UIBezierPath bezierPathWithRect:viewFrame];

// 调用bezierPathByReversingPath，进行路径反转，才会产生抠图效果
[viewPath appendPath:[cutPath1 bezierPathByReversingPath]];

// 配合CAShapeLayer，调用layer（此layer必须是第一层，不能嵌套）的setMask方法设置遮罩层
CAShapeLayer *shapeLayer = [CAShapeLayer layer];
shapeLayer.path = viewPath.CGPath;
[self.view.layer setMask:shapeLayer];       
```

[代码示例2](https://www.jianshu.com/p/11b14e104f3a)

```
 
 
 UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *path = [[UIBezierPath bezierPathWithOvalInRect:rect] bezierPathByReversingPath];
    [maskPath appendPath:path];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.frame;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    maskLayer.fillColor = [UIColor redColor].CGColor;
    maskLayer.strokeStart = 0.f;
    maskLayer.strokeEnd = 1.0f;
    maskLayer.lineWidth = 1.0f;
    [self.layer addSublayer:maskLayer];
    self.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    self.layer.mask = maskLayer;
```



> 其中调用了两个贝塞尔对象，第一个做了个全局的背景，第二个画出了需要的位置的图形，然后将两个贝塞尔合成到第一个上，然后将贝塞尔添加到CAShapeLayer上绘制出来图形，最后将CAShapeLayer mask到图层的layer上得到了所需的图形。

其中，关键的几个点我再说明下，
 1.`bezierPathByReversingPath`这个方法的调用，并不是每一个贝塞尔图形都需要调用的，比如，绘制扇形的就不用调用这个也可以实现，但是其他的比如我用的绘制椭圆的就需要调用，具体原理，不多做解释。

1. `appendPath`这个方法将两个贝塞尔连接成为了一个，完成了所需的图形。
2. layer层的mask属性。关于这个属性做了什么事可以参考[这篇文章](https://link.jianshu.com?t=http://blog.csdn.net/livesxu/article/details/50538606)

#### 效果图

##### 图1 - 普通矩形

![Xnip2020-10-31_17-37-15](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_17-37-15.jpg)

General preferences pane

##### 图2 - 圆角为20的圆角矩形

![Xnip2020-10-31_17-37-45](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_17-37-45.jpg)

General preferences pane

##### 图3 - 左上和右上为圆角20的部分圆角矩形

![Xnip2020-10-31_17-38-07](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_17-38-07.jpg)

General preferences pane

##### 图4 - 内切圆（椭圆）

![Xnip2020-10-31_17-38-25](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_17-38-25.jpg)



