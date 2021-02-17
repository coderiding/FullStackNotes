# iOS 10之后获取NSLog日志

* 接下来，我们就看看 iOS 10 之后，如何来获取 NSLog 日志。
* 统一日志系统的方式，是把日志集中存放在内存和数据库里，并提供单一、高效和高性能的接口去获取系统所有级别的消息传递。
* macOS 10.12 开始使用了统一日志系统，我们通过控制台应用程序或日志命令行工具，就可以查看到日志消息。
* 但是，新的统一日志系统没有 ASL 那样的接口可以让我们取出全部日志，所以为了兼容新的统一日志系统，你就需要对 NSLog 日志的输出进行重定向。
* 对 NSLog 进行重定向，我们首先想到的就是采用 Hook 的方式。因为 NSLog 本身就是一个 C 函数，而不是 Objective-C 方法，所以我们就可以使用 fishhook 来完成重定向的工作。具体的实现代码如下所示：

```
static void (&orig_nslog)(NSString *format, ...);
 
void redirect_nslog(NSString *format, ...) {
    // 可以在这里先进行自己的处理
    
    // 继续执行原 NSLog
    va_list va;
    va_start(va, format);
    NSLogv(format, va);
    va_end(va);
}
 
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        struct rebinding nslog_rebinding = {"NSLog",redirect_nslog,(void*)&orig_nslog};
 
        NSLog(@"try redirect nslog %@,%d",@"is that ok?");
    }
    return
}
```

* 可以看到，我在上面这段代码中，利用了 fishhook 对方法的符号地址进行了重新绑定，从而只要是 NSLog 的调用就都会转向 redirect_nslog 方法调用。
* 在 redirect_nslog 方法中，你可以先进行自己的处理，比如将日志的输出重新输出到自己的持久化存储系统里，接着调用 NSLog 也会调用的 NSLogv 方法进行原 NSLog 方法的调用。当然了，你也可以使用 fishhook 提供的原方法调用方式 orig_nslog，进行原 NSLog 方法的调用。上面代码里也已经声明了类 orig_nslog，直接调用即可。
* NSLog 最后写文件时的句柄是 STDERR，我先前跟你说了苹果对于 NSLog 的定义是记录错误的信息，STDERR 的全称是 standard error，系统错误日志都会通过 STDERR 句柄来记录，所以 NSLog 最终将错误日志进行写操作的时候也会使用 STDERR 句柄，而 dup2 函数是专门进行文件重定向的，那么也就有了另一个不使用 fishhook 还可以捕获 NSLog 日志的方法。你可以使用 dup2 重定向 STDERR 句柄，使得重定向的位置可以由你来控制，关键代码如下：

```
int fd = open(path, (O_RDWR | O_CREAT), 0644);
dup2(fd, STDERR_FILENO);
```

* 其中，path 就是你自定义的重定向输出的文件地址。
* 这样，我们就能够获取到各个系统版本的 NSLog 了。那么，通过其他方式打的日志，我们怎么才能获取到呢？