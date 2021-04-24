---
title: iOS绘制贝塞尔曲线公式
tags:
  - 动画
  - 阴影
  - 贝塞尔
categories: 技术改变世界
abbrlink: 3849
date: 2018-09-01 12:01:03
---



### 1. 贝塞尔曲线的原理

以三阶为例：设P0、P02、P2是一条抛物线上顺序三个不同的点。过P0和P2点的两切线交于P1点，在P02点的切线交P0P1和P2P1于P01和P11，则如下比例成立：

![Xnip2020-10-31_16-30-06](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-30-06.jpg)

这是所谓**抛物线的三切线定理**。

![Xnip2020-10-31_16-30-34](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-30-34.jpg)

当P0，P2固定，引入参数t，令上述比值为t:(1-t)，即有：

![Xnip2020-10-31_16-30-51](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-30-51.jpg)

当P0，P2固定，引入参数t，令上述比值为t:(1-t)，即有：

![Xnip2020-10-31_16-31-09](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-31-09.jpg)

t从0变到1，第一、二式就分别表示控制二边形的第一、二条边，它们是两条一次Bezier曲线。将一、二式代入第三式得：

![Xnip2020-10-31_16-31-26](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-31-26.jpg)

当t从0变到1时，它表示了由三顶点P0、P1、P2三点定义的一条二次Bezier曲线。

并且表明：

这二次Bezier曲线P02可以定义为分别由前两个顶点(P0,P1)和后两个顶点(P1,P2)决定的一次Bezier曲线的线性组合。

依次类推，

由四个控制点定义的三次Bezier曲线P03可被定义为分别由(P0,P1,P2)和(P1,P2,P3)确定的二条二次Bezier曲线的线性组合，由(n+1)个控制点Pi(i=0,1,...,n)定义的n次Bezier曲线P0n可被定义为分别由前、后n个控制点定义的两条(n-1)次Bezier曲线P0n-1与P1n-1的线性组合：

![Xnip2020-10-31_16-31-46](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-31-46.jpg)

由此得到Bezier曲线的递推计算公式

![Xnip2020-10-31_16-32-03](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-32-03.jpg)

<!-- more -->

Bézier curve(贝塞尔曲线)是应用于二维图形应用程序的[数学曲线](https://links.jianshu.com/go?to=http%3A%2F%2Fbaike.baidu.com%2Fview%2F627248.htm)。 曲线定义：起始点、终止点（也称锚点）、控制点。通过调整控制点，贝塞尔曲线的形状会发生变化。 1962年，法国数学家Pierre Bézier第一个研究了这种[矢量](https://links.jianshu.com/go?to=http%3A%2F%2Fbaike.baidu.com%2Fview%2F77474.htm)绘制曲线的方法，并给出了详细的计算公式，因此按照这样的公式绘制出来的曲线就用他的姓氏来命名，称为贝塞尔曲线。
 以下公式中：B(t)为t时间下 点的坐标；

P0为起点,Pn为终点,Pi为控制点

#### 一阶贝塞尔曲线(线段，2个点)：

![Xnip2020-10-31_16-33-17](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-33-17.jpg)

![13180946-f9e271ce4b0564ba](https://gitee.com/coderiding/picbed/raw/master/uPic/13180946-f9e271ce4b0564ba.gif)

意义：由 P0 至 P1 的连续点， 描述的一条线段

#### 二阶贝塞尔曲线(抛物线，3个点)：

![Xnip2020-10-31_16-34-29](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-34-29.jpg)

![13180946-f2d45116705c5e4a](https://gitee.com/coderiding/picbed/raw/master/uPic/13180946-f2d45116705c5e4a.gif)

原理：
 由 P0 至 P1 的连续点 Q0，描述一条线段。
 由 P1 至 P2 的连续点 Q1，描述一条线段。
 由 Q0 至 Q1 的连续点 B(t)，描述一条二次贝塞尔曲线。

经验：P1-P0为曲线在P0处的切线。

```
  //创建一条贝塞尔
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 5.0;//宽度
    aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath.lineJoinStyle = kCGLineJoinRound;  //终点处理
    //起始点
    [aPath moveToPoint:CGPointMake(20, 100)];
    //添加两个控制点
    [aPath addQuadCurveToPoint:CGPointMake(220, 100) controlPoint:CGPointMake(170, 0)];
    //划线
    [aPath stroke];

```



#### 三阶贝塞尔曲线（4个点）：

![Xnip2020-10-31_16-35-14](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-35-14.jpg)

![13180946-b34fdb05faf90427](https://gitee.com/coderiding/picbed/raw/master/uPic/13180946-b34fdb05faf90427.gif)

通用公式：

![Xnip2020-10-31_16-36-02](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-36-02.jpg)

```
  //三次曲线
    
    UIBezierPath* bPath = [UIBezierPath bezierPath];
    
    
    bPath.lineWidth = 5.0;
    bPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    bPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    //起始点
    [bPath moveToPoint:CGPointMake(20, 250)];
    
    //添加两个控制点
    [bPath addCurveToPoint:CGPointMake(350, 250) controlPoint1:CGPointMake(310, 200) controlPoint2:CGPointMake(210, 400)];
    
    [bPath stroke];
```



### 高阶贝塞尔曲线：

#### 4阶曲线（5个点）：

![13180946-0763ad2a88972708](https://gitee.com/coderiding/picbed/raw/master/uPic/13180946-0763ad2a88972708.gif)

#### 5阶曲线（6个点）：

![13180946-98cc9c94a6cf9f21](https://gitee.com/coderiding/picbed/raw/master/uPic/13180946-98cc9c94a6cf9f21.gif)

#### 贝塞尔曲线的推到过程：

![13180946-d3cb88783c00081d](https://gitee.com/coderiding/picbed/raw/master/uPic/13180946-d3cb88783c00081d.jpg)

![13180946-a78263de8bb34744](https://gitee.com/coderiding/picbed/raw/master/uPic/13180946-a78263de8bb34744.jpg)

### 2. 用Swift进行贝塞尔曲线绘制

##### 2.1 普通线条绘制

用Swift进行普通线条的绘制代码，如下：

```swift
import UIKit

class BezierPathView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.drawLine()
        self.drawCommonCurve()
        self.drawSmoothPath()
    }
    
    func drawLine() {
        
        let offset:CGFloat = 50.0
        
        // 绘制矩形
        //let rectpath = UIBezierPath(rect: CGRect.init(x: 15, y: offset, width: 300, height: 60))
        let rectpath = UIBezierPath(roundedRect: CGRect.init(x: 15, y: offset, width: 300, height: 60), cornerRadius: 5.0)

        rectpath.lineWidth = 5.0
        UIColor.green.setStroke()
        rectpath.stroke()
        UIColor.red.setFill()
        rectpath.fill()
        
        // 绘制直线
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 25.0, y: offset + 130.0))
        path.addLine(to: CGPoint(x: 300.0, y: offset + 130.0))
        path.lineWidth = 5.0
        UIColor.cyan.setStroke()
        path.stroke()
    }
    
    func drawCommonCurve() {
        
        let offset:CGFloat = 260.0
        
        let curvePath = UIBezierPath()
        curvePath.move(to: CGPoint(x: 30.0, y: offset))
        curvePath.addQuadCurve(to: CGPoint(x: 350.0, y: offset), controlPoint: CGPoint(x: 350.0, y: offset + 100))
        UIColor.blue.setStroke()
        curvePath.stroke()
    }
    
    func drawSmoothPath() {
        
        let offset:CGFloat = 430
        
        let pointCount:Int = 4
        let pointArr:NSMutableArray = NSMutableArray.init()
        for i in 0...pointCount {
            let px: CGFloat = 15 + CGFloat(i) * CGFloat(80)
            let py: CGFloat = i % 2 == 0 ? offset - 60 : offset + 60
            let point: CGPoint = CGPoint.init(x: px, y: py)
            pointArr.add(point)
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = 2.0
        var prevPoint: CGPoint!
        
        for i in 0 ..< pointArr.count {
            let currPoint:CGPoint = pointArr.object(at: i) as! CGPoint
            
            // 绘制绿色圆圈
            let arcPath = UIBezierPath()
            arcPath.addArc(withCenter: currPoint, radius: 3, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
            UIColor.green.setStroke()
            arcPath.stroke()
            
            // 绘制平滑曲线
            if i==0 {
                bezierPath.move(to: currPoint)
            }
            else {
                let conPoint1: CGPoint = CGPoint.init(x: CGFloat(prevPoint.x + currPoint.x) / 2.0, y: prevPoint.y)
                let conPoint2: CGPoint = CGPoint.init(x: CGFloat(prevPoint.x + currPoint.x) / 2.0, y: currPoint.y)
                bezierPath.addCurve(to: currPoint, controlPoint1: conPoint1, controlPoint2: conPoint2)
            }
            prevPoint = currPoint
        }
        UIColor.red.setStroke()
        bezierPath.stroke()
    }
}
```

运行结果：

![Xnip2020-10-31_16-38-43](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_16-38-43.jpg)

[源码Github地址](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2FQiShare%2FQiTransform)
