# Lsn13.Flutter是如何自定义View的



[TOC]

## 自定义流程

1.创建一个类继承CustomPainter，需要重写两个方法，paint和shouldRepaint。 
2.paint方法就是Flutter中负责View绘制的地方，使用传递来的canvas和size即可完成对目标View的绘制 
3.shouldRepaint是控制自定义View是否需要重绘的，返回fals代表这个View在构建完成后不需要重绘 
4.自定义的CustomPainter不是Widget，需借助CustomPaint来给我们自定义的CustomPainter做渲染

## Paint常用属性

```
 Paint _paint = new Paint()
   ..color = Colors.blueAccent//画笔颜色
   ..strokeCap = StrokeCap.round//画笔笔触类型
   ..isAntiAlias = true//是否启动抗锯齿
   ..style=PaintingStyle.fill//绘画风格，默认为填充
   ..blendMode=BlendMode.exclusion//颜色混合模式
   ..colorFilter=ColorFilter.mode(Colors.blueAccent, BlendMode.exclusion)//颜色渲染模式，一般是矩阵效果来改变的，但是flutter中只能使用颜色混合模式
   ..maskFilter=MaskFilter.blur(BlurStyle.inner, 3.0)//模糊遮罩效果，flutter中只有这个
   ..filterQuality=FilterQuality.high//颜色渲染模式的质量
   ..strokeWidth = 15.0;//画笔的宽度，逻辑像素
```

## Path中的常用方法 

| 方法名         | 作用                                     |
| -------------- | ---------------------------------------- |
| moveTo         | 将路径起始点移动到指定的位置             |
| relativeMoveTo | 相对于当前位置移动到                     |
| lineTo         | 从当前位置连接指定点                     |
| relativeLineTo | 相对当前位置连接到                       |
| arcTo          | 二阶贝塞尔曲线                           |
| conicTo        | 三阶贝塞尔曲线                           |
| close          | 关闭路径，连接路径的起始点               |
| reset          | 重置路径，恢复到默认状态                 |
| add**          | 添加其他图形，如addArc，在路径是添加圆弧 |
| contains       | 路径上是否包括某点                       |
| transfor       | 给路径做matrix4变换                      |
| combine        | 结合两个路径                             |

## 不使用CustomPaint

1. 继承SingleChildRenderObjectWidget

2. 继承RenderConstrainedBox
3. 实现void paint(PaintingContext context, Offset offset)方法

