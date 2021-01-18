```objectivec
_fillButton3 = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorGreen];
self.fillButton3.titleLabel.font = UIFontMake(14);
[self.fillButton3 setTitle:@"点击修改按钮fillColor" forState:UIControlStateNormal];
[self.fillButton3 setImage:UIImageMake(@"icon_emotion") forState:UIControlStateNormal];
self.fillButton3.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
self.fillButton3.adjustsImageWithTitleTextColor = YES;
[self.fillButton3 addTarget:self action:@selector(handleFillButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:self.fillButton3];

UIColor *color = [QDCommonUI randomThemeColor];
self.fillButton3.fillColor = color;
self.fillButton3.titleTextColor = UIColorWhite;
```