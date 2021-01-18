```objectivec
@property(strong,nonatomic)CAGradientLayer *topFirstGradinetLayer;

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews]; 

    self.topFirstGradinetLayer.frame = CGRectMake(0,0,self.topFirstView.width,self.topFirstView.height);
}

- (CAGradientLayer *)topFirstGradinetLayer {
    if (!_topFirstGradinetLayer) {
        _topFirstGradinetLayer = [CAGradientLayer layer];
        _topFirstGradinetLayer.frame = CGRectZero;
        _topFirstGradinetLayer.startPoint = CGPointMake(1.02, 0.72);
        _topFirstGradinetLayer.endPoint = CGPointMake(0, 0.72);
        _topFirstGradinetLayer.colors = @[(__bridge id)[UIColor colorWithRed:43/255.0 green:46/255.0 blue:63/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0].CGColor];
    }
    return _topFirstGradinetLayer;
}
```