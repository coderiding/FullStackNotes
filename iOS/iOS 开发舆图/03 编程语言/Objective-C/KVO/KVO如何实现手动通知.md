# KVO如何实现手动通知
* 如果将一个对象设定成属性,这个属性是自动支持KVO的,如果这个对象是一个实例变量,那么,这个KVO是需要我们自己来实现的.

---监听实例变量
```
#import "RootViewController.h"
#import "Student.h"

@interface RootViewController ()

@property (nonatomic, strong) Student *student;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 创建学生对象
    _student = [Student new];
    
    // 监听属性name
    [_student addObserver:self
               forKeyPath:@"name"  // 属性
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    
    // 监听实例变量age
    [_student addObserver:self
               forKeyPath:@"age"   // 实例变量
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    
    _student.name = @"YouXianMing"; // 改变名字
    _student.age  = @"18";          // 改变年龄
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"%@", change);
}

@end
```

---.h
```
#import <Foundation/Foundation.h>

@interface Student : NSObject
{
    NSString  *_age;
}
- (void)setAge:(NSString *)age;
- (NSString *)age;

@property (nonatomic, strong) NSString  *name;

@end
```

---.m
```
#import "Student.h"

@implementation Student

@synthesize name = _name;
- (void)setName:(NSString *)name
{
    _name = name;
}
- (NSString *)name
{
    return _name;
}


// 手动设定KVO
- (void)setAge:(NSString *)age
{
    [self willChangeValueForKey:@"age"];
    _age = age;
    [self didChangeValueForKey:@"age"];
}
- (NSString *)age
{
    return _age;
}
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    // 如果监测到键值为age,则指定为非自动监听对象
    if ([key isEqualToString:@"age"])
    {
        return NO;
    }
    
    return [super automaticallyNotifiesObserversForKey:key];
}

@end
```

---参考
* https://yq.aliyun.com/articles/30483
* https://tech.glowing.com/cn/implement-kvo/
* https://www.jianshu.com/p/6305af232100
* 百度网盘1590392095