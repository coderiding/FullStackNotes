```objectivec
//main.m
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSObject *objc = [[NSObject alloc] init];
    }
    return 0;
}
```

```objectivec
clang -rewrite-objc main.m -o main.cpp
// 更加优秀的编译是根据平台 和架构来

/**
xcrun                      : xcode  run
 -sdk  iphoneos      : iphoneos操作系统
 -arch  arm64         : arm64架构
*/
xcrun  -sdk  iphoneos  clang  -arch  arm64  -rewrite-objc  OC源文件  -o  输出的CPP文件
```

在生成的main.cpp文件中可以查找到NSObject_IMP的代码片段，这个就是NSOject对象对应的C++结构体：

```objectivec
struct NSObject_IMPL {
    Class isa; //一个指向struct objc_class结构体类型的指针
};

// 查看Class本质
typedef struct objc_class *Class;
```

我们通过NSObject对象对应的结构体发现，结构体中只有一个isa指针变量。按理来说NSObject对象需要的内存大小只要能够满足存放一个指针大小就可以了，一个指针变量在64位的机器上大小是8个字节（我们只讨论64位的机器大小），也就是说只要有8个字节的内存空间就能满足存放一个NSObject对象了。

那是不是说一个NSObject对象就占用8个字节大小的内存呢？实际上不是这样的。我们需要分清楚两个概念，对象占用的内存空间和对象实际利用的内存空间。我们可以用坐车的例子来说明一下这两个概念的区别：对象占用的内存空间就好比汽车的载客数量，对象实际利用的内存空间就好比车上实际的乘客数量，实际的乘客数量是不会超过车辆的最大载客数量的，也不会存在空载的情况。NSObject对象中的isa指针变量就好比车上的乘客，实际上系统给一个NSObject对象分配了16个字节大小的内存空间。实际情况我们可以通过下面的代码来验证一下：

```objectivec
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSObject *objc = [[NSObject alloc] init];
        
        NSLog(@"objc对象实际需要的内存大小: %zd", class_getInstanceSize([objc class]));
        NSLog(@"objc对象实际分配的内存大小: %zd", malloc_size((__bridge const void *)(objc)));
    }
    return 0;
}

//输出的结果
2018-08-02 23:31:39.891056+0800 OC对象的本质[8461:5063635] objc对象实际利用的内存大小: 8
2018-08-02 23:31:39.891320+0800 OC对象的本质[8461:5063635] objc对象实际占用的内存大小: 16
```

为什么一个NSObject对象明明只需要8个字节的内存大小就可以了，但是还是分配到了16个字节大小的内存空间？对于这个问题我们可以通过阅读objc4的源代码来找到答案。通过查看跟踪obj4中alloc和allocWithZone两个函数的实现，会发现这个连个函数都会调用一个instanceSize的函数：

```objectivec
size_t instanceSize(size_t extraBytes) const {
        if (fastpath(cache.hasFastInstanceSize(extraBytes))) {
            return cache.fastInstanceSize(extraBytes);
        }

        size_t size = alignedInstanceSize() + extraBytes;
        // CF requires all objects be at least 16 bytes.
        if (size < 16) size = 16;
        return size;
    }
```

这个函数的代码很简单，返回的结果就是系统给一个对象分配内存的大小。当对象的实际大小小于16时，系统就返回16个字节的大小。也就是说16个字节大小是系统的最低消费。还是用坐车的例子来说明一下，假如有8个人想坐车，他们打电话叫车说要一辆能坐8个人大小的车，对方说sorry我们没有坐8个人大小的车，我们这里最小的就是坐16个人的车。最后来了一辆坐16个人的车，拉了8个人开走了。车就好比一个NSOject对象，车上的乘客就好比是对象中的成员，车的大小或者说载客数量就相当于一个对象占用的内存大小，车上实际的乘客数量就是对象中成员的大小。所以说一个NSObject对象占用多少内存，我想应该很明白了。

我们可以继续深入一点，推算针对我们自定义的类内存布局和对象占用的内存空间。假设我们定义一个Animal的类，其中只有一个int成员变量weight。

```objectivec
//interface
@interface Animal: NSObject
{
    int weight;
}
@end
//implementation
@implementation Animal
@end
```

我们同样可以通过把OC文件转化为C++文件的方式来查看Animal类对应的结构体实现。

```objectivec
struct Animal_IMPL {
    struct NSObject_IMPL NSObject_IVARS; //实际上就是一个isa指针
    int weight;
};

struct NSObject_IMPL {
    Class isa; //一个指向struct objc_class结构体类型的指针
};

//简化版本
struct Animal_IMPL {
    Class isa;
    int weight;
};
```

通过struct Animal_IMPL结构体，我们不难看出结构体中有两个成员变量：一个isa指针和一个int型成员变量。Animal结构体对象实际需要的内存大小应该是16字节（指针8个字节，int型变量4个字节）。Animal结构体对象实际需要的内存大小是12字节，那系统给Animal对象实际分配的内存大小是多少呢？我们还是通过调用class_getInstanceSize和malloc_size这两个函数来看一下。

```objectivec
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

//interface
@interface Animal: NSObject
{
    int weight;
}
@end

//implementation
@implementation Animal
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSObject *objc = [[NSObject alloc] init];
        Animal *animal = [[Animal alloc] init];
        NSLog(@"animal对象实际需要的内存大小: %zd", class_getInstanceSize([animal class]));
        NSLog(@"animal对象实际分配的内存大小: %zd", malloc_size((__bridge const void *)(animal)));
    }
    return 0;
}

//输出结果
2018-08-03 13:56:38.463885+0800 OC对象的本质[7461:967943] animal对象实际利用的内存大小: 16
2018-08-03 13:56:38.463899+0800 OC对象的本质[7461:967943] animal对象实际占用的内存大小: 16
```

我们发现Animal对象实际需要的内存大小是16字节，而不是我们之前推算出来的12字节，这其中涉及到了结构体成员变量的内存对齐的问题，结构体内存对齐其中有一条要求结构体大小需要是最大成员变量大小的整数倍，这里的最大成员变量是指针变量（8个字节），结构体的最终的大小需要是8的整数倍，所以结果是16而不是12。系统实际分配的大小也是16字节，这个就比较好理解了，之前我们提到系统最小分配的内存大小是16字节。

我们可以在Animal类中增加一个int成员变量，此时新的对象实际需要的内存和实际分配得到的内存大小是多少呢？答案是都是16个字节大小。新增了一个4字节大小int型的变量，实际需要的内存大小就是8+4+4=16字节，系统实际分配的大小也是16字节。

如果我们再增加一个int型的成员变量的话，对象实际需要的内存和实际分配得到的内存大小是多少呢？我们可以简单的推算一下，对象结构中有4个成员变量，一个指针变量和3个int型变量，4个成员变量的内存大小加起来是20（8+4+4+4）个字节大小，根据结构体内存对齐的原则，结构体实际需要的内存大小应该是8的整数倍，也就是24个字节。对象实际需要的内存大小是24个字节，那么系统实际分配给对象的内存大小又是多少呢？我们可以通过代码来查看一下最终的结果。

```objectivec
@interface Animal: NSObject
{
    int weight;
    int height;
    int age;
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {      
        Animal *animal = [[Animal alloc] init];
        NSLog(@"animal对象实际需要的内存大小: %zd", class_getInstanceSize([animal class]));
        NSLog(@"animal对象实际分配的内存大小: %zd", malloc_size((__bridge const void *)(animal)));
    }
    return 0;
}

//输出结果
2018-08-03 17:45:59.468699+0800 OC对象的本质[11044:1911186] animal对象实际需要的内存大小: 24
2018-08-03 17:45:59.468719+0800 OC对象的本质[11044:1911186] animal对象实际分配的内存大小: 32
```

新的Animal对象实际需要的内存大小是24字节，但是系统给对象实际分配的内存大小是32字节。这有时为什么呢？我们需要查看相关的资料和Apple的关于malloc的开源代码才能弄清楚其中的原因。具体原因是Apple系统中的malloc函数分配内存空间时，内存是根据一个bucket的大小来分配的. bucket的大小是16，32，48，64，80 ...，可以看出系统是按16的倍数来分配对象的内存大小的。

我们可以再增加两个double型的成员变量来进一步的做验证。

```objectivec
@interface Animal: NSObject
{
    int weight;
    int height;
    int age;
    double d1;
    double d2;
}
@end
```

我们能够在不运行代码的情况下推算出对象实际需要和系统实际分配的内存大小。对象的成员变量的内存大小是36（8+4+4+4+8+8）个字节，但是需要内存对齐，最终对象实际需要的内存是40字节。系统分配的内存大小是48字节。

通过把OC对象转化为C++结构体的方法，我们很容易搞清楚OC对象的内存分配情况