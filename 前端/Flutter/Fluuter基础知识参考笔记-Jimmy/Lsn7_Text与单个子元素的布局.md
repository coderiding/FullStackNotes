# Lsn7.Text与单个子元素的布局



[TOC]



## Text
文本显示的方向需要在Text实例中指定，当使用MaterialApp时，文本的方向将自动设定

```
//构造方法一：
Text(
  this.data, 
  { Key key,
    this.style,
    this.textAlign,//文本对齐方式(left,right,center,justify(两端对齐),start,end)
    this.textDirection,//文本方向(rtl,ltr)
    this.locale,
    this.softWrap,//是否自动换行，若为false，文字将不考虑容器大小，单行显示，超出屏幕部分将默认截断处理
    this.overflow,//当文字超出屏幕时的处理方式(clip截断,fade渐隐,ellipsis省略号(ellipsis需要设置maxLines = 1或者softWrap = false))
    this.textScaleFactor,//字体显示倍率，字体最终大小=TextStyle.fontSize*倍率
    this.maxLines,//最大行数设置
    this.semanticsLabel,
  })
  
//构造方法二：
Text.rich(this.textSpan,...)
```


```
  TextStyle({
    this.inherit = true,//是否继承
    this.color,//字体颜色
    this.fontSize,//字体大小
    this.fontWeight,//字体粗细
    this.fontStyle,//normal(使用直立的字形)或者italic(使用专为倾斜而设计的字形)
    this.letterSpacing,//字母间隙(负值可以让字母更紧凑)
    this.wordSpacing,//单词间隙(负值可以让单词更紧凑)
    this.textBaseline,//文本绘制基线(alphabetic/ideographic)
    this.height,//用在Text控件上时，行高（会乘以fontSize,所以不宜设置过大）
    this.locale,//区域设置
    this.foreground,
    this.background,
    this.decoration,//文字装饰(none/underline/overline/lineThrough)
    this.decorationColor,//文字装饰的颜色
    this.decorationStyle,//文字装饰的风格(solid/double/dotted/dashed/wavy)
    this.debugLabel,
    String fontFamily,//字体
    String package,
  })
```


[字体下载地址](https://fonts.google.com/)



```
TextSpan({
    this.style,
    this.text,
    this.children,
    this.recognizer,
  })
```


## Container
```
Container({
  Key key,
  this.alignment, //对齐方式指的是Container内child的对齐方式
  this.padding, //child到container边界的距离
  Color color, //颜色---与decoration冲突
  Decoration decoration, //背景装饰--BoxDecoration
  this.foregroundDecoration, //前景装饰--BoxDecoration
  double width, //宽
  double height, //高
  BoxConstraints constraints, //对Container进行布局约束
  this.margin, //container与周边的距离
  this.transform, //Container矩阵变换
  this.child,
})
```


## LimitedBox



## Align



## Center



## Padding



## ConstrainedBox



## Transform

