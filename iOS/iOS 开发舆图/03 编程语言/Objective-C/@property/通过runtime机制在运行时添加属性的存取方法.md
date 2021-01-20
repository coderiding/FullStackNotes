在C函数中不能直接使用实例变量，需要将Objc对象self转成C中的结构体，因此在Person类同样需要显式声明实例变量而且访问级别是@public

[https://www.jianshu.com/p/c883687c6405](https://www.jianshu.com/p/c883687c6405)

```objectivec
#import <Foundation/Foundation.h>

@interface People : NSObject

@property (nonatomic, copy) NSString *name;

@end

#import "People.h"
#import <objc/objc-runtime.h>

@interface People ()
{
    @public
    NSString *_name;
}
@end

@implementation People

@dynamic name;

+ (BOOL)resolveInstanceMethod:(SEL)sel {

    if (sel == @selector(setName:)) {
        
        class_addMethod([self class], sel, (IMP)setName, "v@:@");
        return YES;
    }else if (sel == @selector(name)){
        
        class_addMethod([self class], sel, (IMP)getName, "@@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

void setName(id self, SEL _cmd, NSString* name)
{
    
    if (((People*)self)->_name != name) {
        ((People *)self)->_name = [name copy];
    }
}

NSString* getName(id self, SEL _cmd)
{
    return ((People *)self)->_name;
}
@end
```