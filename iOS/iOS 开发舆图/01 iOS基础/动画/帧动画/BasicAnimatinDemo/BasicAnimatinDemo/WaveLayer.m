//
//  WaveLayer.m
//  BasicAnimatinDemo
//
//  Created by 胡啸－ Mac on 16/11/17.
//  Copyright © 2016年 gzsc-hx. All rights reserved.
//

#import "WaveLayer.h"
#import <UIKit/UIKit.h>

@interface WaveLayer()

@property (strong, nonatomic) UIBezierPath *wavePathPre;
@property (strong, nonatomic) UIBezierPath *wavePathStarting;
@property (strong, nonatomic) UIBezierPath *wavePathLow;
@property (strong, nonatomic) UIBezierPath *wavePathMid;
@property (strong, nonatomic) UIBezierPath *wavePathHigh;
@property (strong, nonatomic) UIBezierPath *wavePathComplete;

@end

static const NSTimeInterval KAnimationDuration = 0.25;

@implementation WaveLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
         self.position = CGPointMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height/2-50);
        self.strokeColor = [UIColor colorWithRed:82/255.0f green:222/255.0f blue:178/255.0f alpha:1].CGColor;
        self.fillColor =  [UIColor colorWithRed:82/255.0f green:222/255.0f blue:178/255.0f alpha:1].CGColor;
    }
    return self;
}

- (UIBezierPath *)wavePathPre{
    if (!_wavePathLow) {
        _wavePathPre = [[UIBezierPath alloc]init];
        [_wavePathPre moveToPoint:CGPointMake(0, 100)];
        [_wavePathPre addLineToPoint:CGPointMake(0, 90)];
        [_wavePathPre addLineToPoint:CGPointMake(100, 90)];
        [_wavePathPre addLineToPoint:CGPointMake(100, 100)];
        [_wavePathPre closePath];
        
    }
    return _wavePathPre;
}

- (UIBezierPath *)wavePathStarting{
    if (!_wavePathStarting) {
        _wavePathPre = [[UIBezierPath alloc]init];
        [_wavePathStarting moveToPoint:CGPointMake(0, 100)];
        [_wavePathStarting addLineToPoint:CGPointMake(0, 90)];
//        [_wavePathStarting addLineToPoint:CGPointMake(100, 90)];
        [_wavePathStarting addCurveToPoint:CGPointMake(100, 90) controlPoint1:CGPointMake(25, 98) controlPoint2:CGPointMake(75, 80) ];
        [_wavePathStarting addLineToPoint:CGPointMake(100, 100)];
        [_wavePathStarting closePath];
        
    }
    return _wavePathPre;
}

- (UIBezierPath *)wavePathLow
{
    if (!_wavePathLow) {
        _wavePathLow = [[UIBezierPath alloc]init];
        [_wavePathLow moveToPoint:CGPointMake(0, 100)];
        [_wavePathLow addLineToPoint:CGPointMake(0, 70)];
        [_wavePathLow addCurveToPoint:CGPointMake(100, 70) controlPoint1:CGPointMake(25, 60) controlPoint2:CGPointMake(75, 75)];
        [_wavePathLow addLineToPoint:CGPointMake(100, 100)];
        [_wavePathLow closePath];
    }
    return _wavePathLow;
}

- (UIBezierPath *)wavePathMid{
    if (!_wavePathMid) {
        _wavePathMid = [[UIBezierPath alloc]init];
        [_wavePathMid moveToPoint:CGPointMake(0, 100)];
        [_wavePathMid addLineToPoint:CGPointMake(0, 50)];
        [_wavePathMid addCurveToPoint:CGPointMake(100, 50) controlPoint1:CGPointMake(25,65) controlPoint2:CGPointMake(75, 40)];
        [_wavePathMid addLineToPoint:CGPointMake(100, 100)];
        [_wavePathMid closePath];

    }
    return _wavePathMid;
}

- (UIBezierPath *)wavePathHigh{
    if (!_wavePathHigh) {
        _wavePathHigh = [[UIBezierPath alloc]init];
        [_wavePathHigh moveToPoint:CGPointMake(0, 100)];
        [_wavePathHigh addLineToPoint:CGPointMake(0, 30)];
        [_wavePathHigh addCurveToPoint:CGPointMake(100, 30) controlPoint1:CGPointMake(25,20) controlPoint2:CGPointMake(75, 40)];
        [_wavePathHigh addLineToPoint:CGPointMake(100, 100)];
        [_wavePathHigh closePath];
        
    }
    return _wavePathHigh;
}

- (UIBezierPath *)wavePathComplete{
    if (!_wavePathComplete) {
        _wavePathComplete = [[UIBezierPath alloc]init];
        [_wavePathComplete moveToPoint:CGPointMake(0, 100)];
        [_wavePathComplete addLineToPoint:CGPointMake(0, -5.0)];
        [_wavePathComplete addLineToPoint:CGPointMake(100, -5.0)];
        [_wavePathComplete addLineToPoint:CGPointMake(100, 100)];
        [_wavePathComplete closePath];
        
    }
    return _wavePathComplete;
}

- (void)createAnimation{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.fromValue = (__bridge id)(self.wavePathPre.CGPath);
    basicAnimation.toValue = (__bridge id)(self.wavePathStarting.CGPath) ;
    basicAnimation.duration = KAnimationDuration;
    basicAnimation.beginTime = 0;

    CABasicAnimation *startingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    startingAnimation.fromValue = (__bridge id)(self.wavePathStarting.CGPath);
    startingAnimation.toValue = (__bridge id)(self.wavePathLow.CGPath);
    startingAnimation.duration = KAnimationDuration;
    startingAnimation.beginTime = basicAnimation.beginTime +basicAnimation.duration;
    
    CABasicAnimation *lowAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    lowAnimation.fromValue = (__bridge id)(self.wavePathStarting.CGPath);
    lowAnimation.toValue = (__bridge id)(self.wavePathLow.CGPath);
    lowAnimation.duration = KAnimationDuration;
    lowAnimation.beginTime = startingAnimation.beginTime + startingAnimation.duration;
    
    CABasicAnimation *midAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    midAnimation.fromValue = (__bridge id)(self.wavePathLow.CGPath);
    midAnimation.toValue = (__bridge id)(self.wavePathMid.CGPath);
    midAnimation.duration = KAnimationDuration;
    midAnimation.beginTime = lowAnimation.beginTime + lowAnimation.duration;
    
    CABasicAnimation *hightAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    hightAnimation.fromValue = (__bridge id)(self.wavePathMid.CGPath);
    hightAnimation.toValue = (__bridge id)(self.wavePathHigh.CGPath);
    hightAnimation.duration = KAnimationDuration;
    hightAnimation.beginTime = midAnimation.beginTime + midAnimation.duration;
    
    CABasicAnimation *completetAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    completetAnimation.fromValue = (__bridge id)(self.wavePathHigh.CGPath);
    completetAnimation.toValue = (__bridge id)(self.wavePathComplete.CGPath);
    completetAnimation.duration = KAnimationDuration;
    completetAnimation.beginTime = hightAnimation.beginTime + hightAnimation.duration;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    group.animations = @[basicAnimation,startingAnimation,lowAnimation,midAnimation,hightAnimation,completetAnimation];
    group.duration = completetAnimation.beginTime + completetAnimation.duration;
    group.fillMode               = kCAFillModeForwards;
    group.removedOnCompletion    = NO;
    [self addAnimation:group forKey:nil];
    
    self.allAnimationDuraion = group.duration;
    
    
}
@end
