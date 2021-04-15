//
//  main.m
//  mainSP
//
//  Created by coderiding on 2021/4/13.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/runtime.h>
#import "ViewController.h"

const NSString *abc = @"abc";
const int a = 1;

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
        NSLog(@"%p",abc);
        NSLog(@"%p",a);
        NSObject *c1 = [NSObject new];
        Class c2 = [NSObject class];
        NSLog(@"%p",c1);
        NSLog(@"NSObject：object_getClass（参数是实例id）=  %p",object_getClass(c1));
        NSLog(@"NSObject：object_getClass（参数是类）=  %p",object_getClass(c2));
        NSLog(@"NSObject：Class=  %p",[c1 class]);
        NSLog(@"-------------------------------");
        ViewController *v1 = [ViewController new];
        Class v2 = [ViewController class];
        NSLog(@"ViewController：object_getClass（参数是实例id）=  %p",object_getClass(v1));
        NSLog(@"ViewController：object_getClass（参数是类）=  %p",object_getClass(v2));
        NSLog(@"ViewController：Class=  %p",[v1 class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
