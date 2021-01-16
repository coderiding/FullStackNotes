//
//  MXToastView.m
//  xbb
//
//  Created by codeRiding on 2017/11/24.
//  Copyright © 2017年 codeRiding. All rights reserved.
//

#import "MXToastView.h"

@interface MXToastView ()

@property(nonatomic,copy)UIWindow *gradeWindow;

@end

@implementation MXToastView

- (instancetype)initPassToast
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    
    if (self) {
        CGRect rect = self.frame;
        rect.origin.x = ([UIScreen mainScreen].bounds.size.width - rect.size.width)/2;
        rect.origin.y = ([UIScreen mainScreen].bounds.size.height - rect.size.height)/2;
        self.frame = rect;
        
        [self show];
    }
    
    return self ;
}

+ (instancetype)showPassToast
{
    return [[self alloc] initPassToast];
}

- (void)show
{
    [self.gradeWindow addSubview:self];
    self.gradeWindow.hidden = NO;
    self.alpha = 1;
    [self.layer addAnimation:[self scaleAnimation] forKey:nil];
    
    [UIView animateWithDuration:.4 animations:^{
        self.gradeWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:.2 animations:^{
        self.gradeWindow.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            self.gradeWindow.hidden = YES;
            self.gradeWindow = nil;
        }
    }];
}

#pragma mark -

- (IBAction)clickBtnDismissView:(id)sender
{
    [self dismiss];
}

#pragma mark === animation

- (CAKeyframeAnimation*)scaleAnimation
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.28;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4f, 0.4f, 0.4f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.06f, 1.06f, 1.06f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.70f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return popAnimation;
}

- (UIWindow*)gradeWindow
{
    if (!_gradeWindow) {
        _gradeWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _gradeWindow.windowLevel = UIWindowLevelStatusBar;
        _gradeWindow.backgroundColor = [UIColor clearColor];
        _gradeWindow.userInteractionEnabled = YES ;
        
    }
    return _gradeWindow ;
}

- (void)dealloc
{
    [self removeFromSuperview];
    self.gradeWindow = nil;
}

@end
