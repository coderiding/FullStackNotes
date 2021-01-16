//
//  UIViewController+hook.m
//  xbb
//
//  Created by coderiding on 2020/11/27.
//  Copyright © 2020 xiaobangban. All rights reserved.
//

#import "UIViewController+hook.h"
#import <objc/runtime.h>

@implementation UIViewController (hook)

+ (void)load {
    [UIViewController swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(aop_viewWillAppear:)];
}

- (void)aop_viewWillAppear:(BOOL)animated {
    [self aop_viewWillAppear:animated];
    // 添加自定义的代码
    
    NSLog(@"MX打印：进入视图：%@",[self class]);
}

// 工具方法
+ (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector {
    Class class = self;
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
