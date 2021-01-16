//
//  main.m
//  Memory
//
//  Created by coderiding on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *p = [Person new];
        NSLog(@"class_getInstanceSize = %zd",class_getInstanceSize([Person class]));
        NSLog(@"malloc_size = %zd",malloc_size((__bridge const void *)p));
 
    }
    return 0;
}
