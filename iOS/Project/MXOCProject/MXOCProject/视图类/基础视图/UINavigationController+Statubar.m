//
//  UINavigationController+Statubar.m
//  xbb
//
//  Created by coderiding on 2020/3/10.
//  Copyright © 2020 xiaobangban. All rights reserved.
//

#import "UINavigationController+Statubar.h"

@implementation UINavigationController (Statubar)

- (UIStatusBarStyle)preferredStatusBarStyle { 
    //找到当前栈中最上层的试图，调用其preferredStatusBarStyle方法 
    return [[self topViewController] preferredStatusBarStyle];
}

- (void)changeToWhite {
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationBar.titleTextAttributes = titleTextAttributes;
    [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor redColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:false];
}

- (void)changeToWhiteWithVC:(UIViewController *)vc {
    vc.navigationItem.leftBarButtonItem = [self createBlackBtn];
    
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationBar.titleTextAttributes = titleTextAttributes;
    [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor redColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:false];
}

- (void)changeToBlackWithVC:(UIViewController *)vc {
    vc.navigationItem.leftBarButtonItem = [self createWhiteBtn];
    
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationBar.titleTextAttributes = titleTextAttributes;
    [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor redColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:false];
}

- (UIBarButtonItem *)createWhiteBtn {
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [popBtn setImage:[UIImage imageNamed:@"mx_nav_back_white"] forState:UIControlStateNormal] ;
    popBtn.frame = CGRectMake(0, 0, 16, 16) ;
    [popBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:popBtn];
    return backItem;
}

- (UIBarButtonItem *)createBlackBtn {
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [popBtn setImage:[UIImage imageNamed:@"mx_nav_back_black"] forState:UIControlStateNormal] ;
    popBtn.frame = CGRectMake(0, 0, 16, 16) ;
    [popBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:popBtn];
    return backItem;
}

-(void)popself {
    [self popViewControllerAnimated:YES];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
