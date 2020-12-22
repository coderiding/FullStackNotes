//
//  CectLayer.m
//  BasicAnimatinDemo
//
//  Created by 胡啸－ Mac on 16/11/17.
//  Copyright © 2016年 gzsc-hx. All rights reserved.
//

#import "CectLayer.h"

static const float kLineWidth = 5.0;

@implementation CectLayer

- (instancetype)init{
    self = [super init];
    if (self) {
        self.path = self.rectPath.CGPath;
        self.lineWidth = kLineWidth;
        self.position = CGPointMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height/2-50);
        self.fillColor = [UIColor whiteColor].CGColor;
        _allAnimationDuraion = 0.8;
    }
    return self;
}

- (UIBezierPath *)rectPath{
    if (!_rectPath) {
        _rectPath = [[UIBezierPath alloc]init];
        [_rectPath moveToPoint:CGPointMake(0, 100)];
        [_rectPath addLineToPoint:CGPointMake(0, -kLineWidth)];
        [_rectPath addLineToPoint:CGPointMake(100, -kLineWidth)];
        [_rectPath addLineToPoint:CGPointMake(100, 100)];
        [_rectPath addLineToPoint:CGPointMake(-kLineWidth/2, 100)];
        [_rectPath closePath];

    }
    return _rectPath;
}

- (void)strokeChangeWithColor:(UIColor *)color {
    self.strokeColor = color.CGColor;
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = @0.0;
    strokeAnimation.toValue = @1.0;
    strokeAnimation.duration = _allAnimationDuraion;
    [self addAnimation:strokeAnimation forKey:nil];
}

@end
