Dashed line border around UIView

[https://stackoverflow.com/questions/13679923/dashed-line-border-around-uiview](https://stackoverflow.com/questions/13679923/dashed-line-border-around-uiview)

```objectivec
#import <QuartzCore/QuartzCore.h>
```

```objectivec
CAShapeLayer *yourViewBorder = [CAShapeLayer layer];
yourViewBorder.strokeColor = [UIColor blackColor].CGColor;
yourViewBorder.fillColor = nil;
yourViewBorder.lineDashPattern = @[@2, @2];
yourViewBorder.frame = yourView.bounds;
yourViewBorder.path = [UIBezierPath bezierPathWithRect:yourView.bounds].CGPath;
[yourView.layer addSublayer:yourViewBorder];

var yourViewBorder = CAShapeLayer()
yourViewBorder.strokeColor = UIColor.black.cgColor
yourViewBorder.lineDashPattern = [2, 2]
yourViewBorder.frame = yourView.bounds
yourViewBorder.fillColor = nil
yourViewBorder.path = UIBezierPath(rect: yourView.bounds).cgPath
yourView.layer.addSublayer(yourViewBorder)
```

您还可以使用图案图片设置不同类型的设计，如下例所示

```objectivec
[yourView.layer setBorderWidth:5.0];
[yourView.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"DotedImage.png"]] CGColor]];///just add image name and create image with dashed or doted drawing and add here
```