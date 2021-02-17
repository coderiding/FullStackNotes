# Lsn8.Image与flutter的布局控件



[TOC]

## Image

```
const Image({
    Key key,
    @required this.image,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,//图片颜色
    this.colorBlendMode,//颜色混合模式
    this.fit,//BoxFit，是否拉伸，包含等处理
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,//重复
    this.centerSlice,//中心缩放
    this.matchTextDirection = false,//图标是否按照图标绘制方向显示，用该属性可生成镜像图片
    this.gaplessPlayback = false,//当ImageProvider发生变化后，重新加载图片的过程中，原图片的展示是否保留。true,保留
  })
```

## Icon

Icon库下载地址：<https://fontawesome.com/icons?d=gallery&s=solid>

```
//使用方式，第一个值是我们要显示图片的Unicode，这个Uniode的值可以在图片详情页面获取
child: new Icon(new IconData(0xf118,fontFamily: "flyou"),size: 100.0,color: Colors.blueAccent,)
```



