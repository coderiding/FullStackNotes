---
title: iOS阴影设置详解
tags:
  - 动画
  - 阴影
categories: 技术改变世界
abbrlink: 53089
date: 2016-04-26 09:15:18
---

UIView的阴影设置主要通过UIView的`layer`的相关属性来设置

- **阴影的颜色**

```objectivec
imgView.layer.shadowColor = [UIColor blackColor].CGColor;
```

- **阴影的透明度**

```undefined
imgView.layer.shadowOpacity = 0.8f;
```

- **阴影的圆角**

```undefined
imgView.layer.shadowRadius = 4.f;
```

- **阴影偏移量**

<!-- more -->

```objectivec
imgView.layer.shadowOffset = CGSizeMake(4,4);
```

![Xnip2020-10-31_13-45-49](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_13-45-49.jpg)

```objectivec
imgView.layer.shadowOffset = CGSizeMake(0,0);
```

![Xnip2020-10-31_13-46-35](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_13-46-35.jpg)



其实从偏移量上可以看出来，即使偏移量为(0,0)时，围绕view的四周依然能看到一定阴影。

> 这里还要说明一点的是，当我们不设置阴影的偏移量的时候，默认值为(0,-3)，既阴影有3个点的向上偏移量。为什么是向上偏移呢？这好像有点不合常理，其实这是由‘历史原因’造成的，阴影最先是在MacOS平台上出现的，默认是向下偏移3个点，我们知道MacOS的坐标系统和iOS坐标系统y轴方向是相反的，所以在iOS系统中由于y轴方向的改变就变成了默认向上偏移3个点。

- **阴影的路径**
   除了通过上面的操作，我们还可以设定阴影的路径

```objectivec
//路径阴影
UIBezierPath *path = [UIBezierPath bezierPath];
[path moveToPoint:CGPointMake(-5, -5)];
//添加直线
[path addLineToPoint:CGPointMake(paintingWidth /2, -15)];
[path addLineToPoint:CGPointMake(paintingWidth +5, -5)];
[path addLineToPoint:CGPointMake(paintingWidth +15, paintingHeight /2)];
[path addLineToPoint:CGPointMake(paintingWidth +5, paintingHeight +5)];
[path addLineToPoint:CGPointMake(paintingWidth /2, paintingHeight +15)];
[path addLineToPoint:CGPointMake(-5, paintingHeight +5)];
[path addLineToPoint:CGPointMake(-15, paintingHeight /2)];
[path addLineToPoint:CGPointMake(-5, -5)];
//设置阴影路径  
imgView.layer.shadowPath = path.CGPath;
```

![Xnip2020-10-31_13-47-03](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_13-47-03.jpg)


 有关UIBezierPath的知识请看：[UIBezierPath介绍](https://www.jianshu.com/p/6c9aa9c5dd68)

- 阴影轮廓和阴影剪切问题

  我们知道CALayer是可以设置边框的，而且边框的轮廓是不受子图层影响的，就像下图这个样子：

  ![Xnip2020-10-31_13-47-33](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_13-47-33.jpg)

  但是阴影则和边框有所不同，阴影的轮廓是包含了当前图层的所有子图层的轮廓，如图：

  ![Xnip2020-10-31_13-47-48](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_13-47-48.jpg)

  仔细观察可以看出阴影的轮廓包含了当前图层和子图层共同组成的范围。当然此时masksTobounds的值为NO，如果设置成YES，不单会剪切掉超出当前图层的子图层的部分，也会将阴影也剪切到，变成完全看不出阴影的状态。

  ![Xnip2020-10-31_13-48-05](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_13-48-05.jpg)

  * **那如果我们既想剪裁又想实现阴影效果，可能就得通过两个图层来实现了：一个只画阴影的空的外图层，和一个用masksToBounds剪裁内容的内图层，这两个图层相同位置大小。**