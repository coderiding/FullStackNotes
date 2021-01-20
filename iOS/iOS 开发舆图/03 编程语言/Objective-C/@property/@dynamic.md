@dynamic 告诉编译器：属性的 setter 与 getter 方法由用户自己实现，不自动生成。假如一个属性被声明为 @dynamic var，而且你没有提供 @setter方法和 @getter 方法，编译的时候没问题，但是当程序运行到 instance.var = someVar，由于缺 setter 方法会导致程序崩溃；或者当运行到 someVar = var 时，由于缺 getter 方法同样会导致崩溃。

```objectivec
#import <Foundation/Foundation.h>

@interface People : NSObject

@property (nonatomic, copy) NSString *name;

@end

#import "People.h"

@interface People ()
{
    NSString *_name;
}
@implementation People

@dynamic name;

- (void)setName:(NSString *)name {

    _name = [name copy];
}

- (NSString *)name {

    return _name;
}

@end

```