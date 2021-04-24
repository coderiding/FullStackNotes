---
title: iOS CAShapeLayer 与贝塞尔曲线的使用
tags:
  - 动画
  - 阴影
  - 贝塞尔
categories: 技术改变世界
abbrlink: 2253
date: 2018-09-01 12:01:03
---

### CAShapeLayer 的基本使用

#### CAShapeLayer 简介

* 1.CAShapeLayer 继承于 CALayer, 可以使用 CALayer 的所有属性值

* 2.CAShapeLayer 需要与贝塞尔曲线在一起使用才有意义

* 3.使用CAShapeLayer与贝塞尔曲线可以实现不在 view 的 drawRect 方法中绘制出我们想要的图形

* 4.CAShapeLayer 属于 CoreAnimation 框架,其动画渲染是在 GPU 中,相对于 view 的 DrawRect 的方法,它使用的手机的 CPU 进行渲染,所以用CAShapeLayer 的效率极高,大大优化手机性能

#### 贝塞尔曲线与 CAShapeLayer 的关系

* 1.贝塞尔曲线创建矢量的路径
* 2.贝塞尔曲线给CAShapeLayer 提供路径,CAShapeLayer在提供的路径中渲染,路径闭环,因此,路径绘制出了Shape
* 3.用于CAShapeLayer的贝塞尔曲线作为 path , 其 path 是一个首尾相接的闭环的曲线,即使该贝塞尔曲线不是一个闭环的曲线
* 现在用两者绘制几种简单图形

<!-- more -->

##### 1.绘制椭圆
```

//创建椭圆形的贝塞尔曲线

UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 100)];

//创建一个 CAShapeLayer

CAShapeLayer *layer = [CAShapeLayer layer];

layer.frame = CGRectMake(0, 0, 200, 100);

//禁止内容显示超出边界

layer.masksToBounds = YES;

layer.position = self.view.center;

//显示边界值

layer.borderWidth = 1.f;

//CASHapeLayer 与 贝塞尔之间的 frame 互不干扰

//设置填充色

layer.fillColor = [UIColor redColor].CGColor;

//设置绘制色(边框色)

layer.strokeColor = [UIColor purpleColor].CGColor;

//建立贝塞尔曲线与 CAShapeLayer 的关联

layer.path = oval.CGPath;

//添加并且显示

[self.view.layer addSublayer:layer];
```

##### 2.绘制矩形 

* 其实只需要创建出矩形贝塞尔曲线,替换 shapeLayer 的 path 即可,同理圆形也是
```
//创建矩形贝塞尔曲线

UIBezierPath *rect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 200, 100)];

//创建圆形贝塞尔曲线

UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];

```