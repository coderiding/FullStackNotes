//
//  ViewController.m
//  BasicAnimatinDemo
//
//  Created by 胡啸－ Mac on 16/11/17.
//  Copyright © 2016年 gzsc-hx. All rights reserved.
//

#import "ViewController.h"
#import "CectLayer.h"
#import "WaveLayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CectLayer *cectLayer = [[CectLayer alloc]init];
    [self.view.layer addSublayer:cectLayer];
    [cectLayer strokeChangeWithColor:[UIColor colorWithRed:82/255.0f green:222/255.0f blue:178/255.0f alpha:1]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(cectLayer.allAnimationDuraion * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        
        WaveLayer *waveLayer = [[WaveLayer alloc]init];
        [self.view.layer addSublayer:waveLayer];
        [waveLayer createAnimation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waveLayer.allAnimationDuraion * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                
                self.view.backgroundColor = [UIColor colorWithRed:82/255.0f green:222/255.0f blue:178/255.0f alpha:1];
            } completion:^(BOOL finished) {
                [self createWelcomLabel];
            }];
        });
    });
    
}

- (void)createWelcomLabel{
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:50.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Welcome";
    label.transform = CGAffineTransformScale(label.transform, 0.25, 0.25);
    [self.view addSubview:label];
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        label.transform = CGAffineTransformScale(label.transform, 4.0, 4.0);
        
    } completion:^(BOOL finished) {
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
