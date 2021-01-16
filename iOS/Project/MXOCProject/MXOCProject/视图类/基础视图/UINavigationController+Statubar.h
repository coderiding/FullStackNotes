//
//  UINavigationController+Statubar.h
//  xbb
//
//  Created by coderiding on 2020/3/10.
//  Copyright © 2020 xiaobangban. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Statubar)

- (void)changeToWhite;

- (UIBarButtonItem *)createWhiteBtn;

- (void)changeToWhiteWithVC:(UIViewController *)vc;

- (void)changeToBlackWithVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
