//
//  WaveLayer.h
//  BasicAnimatinDemo
//
//  Created by 胡啸－ Mac on 16/11/17.
//  Copyright © 2016年 gzsc-hx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface WaveLayer : CAShapeLayer

@property (nonatomic,assign)NSTimeInterval allAnimationDuraion;
- (void)createAnimation;
@end
