//
//  UIViewController+hook.m
//  qmuidemo
//
//  Created by coderiding on 2020/11/26.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "UIViewController+hook.h"
#import <objc/runtime.h>

@implementation UIViewController (hook)

+ (void)load {
    [UIViewController swizzleMethod:@selector(viewDidLoad) withMethod:@selector(aop_viewDidLoad)];
}

- (void)aop_viewDidLoad {
    [self aop_viewDidLoad];
    // 添加自定义的代码
    
    NSLog(@"mx打印：当前视图：%@",[self class]);
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
