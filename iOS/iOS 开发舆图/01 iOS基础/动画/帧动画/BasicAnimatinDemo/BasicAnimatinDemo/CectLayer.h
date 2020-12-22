//
//  CectLayer.h
//  BasicAnimatinDemo
//
//  Created by 胡啸－ Mac on 16/11/17.
//  Copyright © 2016年 gzsc-hx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CectLayer : CAShapeLayer

@property (nonatomic,strong)UIBezierPath *rectPath;
@property (nonatomic,assign)NSTimeInterval allAnimationDuraion;

- (void)strokeChangeWithColor:(UIColor *)color;

@end
