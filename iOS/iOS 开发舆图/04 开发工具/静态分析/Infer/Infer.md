```objectivec
百度网盘备份：分享-开发者-网页html-iOS编译
1585789767

结合infer静态分析工具后的自动部署流程图
https://raw.githubusercontent.com/codeRiding/github_pic_0001/master/Xnip2020-04-02_16-43-13.jpg

Infer 的安装，有从源码安装和直接安装 binary releases 两种方式。

Infer捕捉的bug类型:
1、Java中捕捉的bug类型
* Resource leak
* Null dereference
2、C/OC中捕捉的bug类型
* Resource leak
* Memory leak
* Null dereference
* Premature nil termination argument
3、只在 OC中捕捉的bug类型
* Retain cycle
* Parameter not null checked
* Ivar not null checked

目前infer 支持的编译器有如下几种
https://raw.githubusercontent.com/codeRiding/github_pic_0001/master/Xnip2020-04-02_08-56-58.jpg

不管你使用哪一种编译器，infer 分析都会经过两种阶段：
* 1、捕获阶段: Infer 捕获编译命令(上面介绍的编译器命令)，将文件翻译成 Infer 内部的中间语言。
* 2、分析阶段:Infer 将分析bugs结果输出到不同格式文件中，如csv、txt、json 方便对分析结果进行加工分析。

----------------------

如果想在 macOS 上编译源码进行安装的话，你需要预先安装一些工具，这些工具在后面编译时会用到，命令行指令如下：

brew install autoconf automake cmake opam pkg-config sqlite gmp mpfr
brew cask install java

你可以使用如下所示的命令，通过编译源码来安装：

# Checkout Infer
git clone https://github.com/facebook/infer.git
cd infer
# Compile Infer
./build-infer.sh clang
# install Infer system-wide...
sudo make install
# ...or, alternatively, install Infer into your PATH
export PATH=`pwd`/infer/bin:$PATH

使用源码安装所需的时间会比较长，因为会编译一个特定的 Clang 版本，而 Clang 是个庞大的工程，特别是第一次编译的耗时会比较长。我在第一次编译时，就大概花了一个多小时。所以，直接安装 binary releases 会更快些，在终端输入：

brew install infer

-----------------------

Infer 就安装好了。

接下来，我通过一个示例和你分享下如何使用 Infer。我们可以先写一段 Objective-C 代码：

#import <Foundation/Foundation.h>
 
@interface Hello: NSObject
@property NSString* s;
@end
 
@implementation Hello
NSString* m() {
    Hello* hello = nil;
    return hello->_s;
}
@end

在终端输入：

infer -- clang -c Hello.m

.
Found 1 source file to analyze in /Users/ming/Downloads/jikeshijian/infer-out
Starting analysis...
 
legend:
  "F" analyzing a file
  "." analyzing a procedure
 
F.
*Found 5 issues*
 
hello.m:10: error: NULL_DEREFERENCE
  pointer `hello` last assigned on line 9 could be null and is dereferenced at line 10, column 12.
  8.   NSString* m() {
  9.       Hello* hello = nil;
  10. *>*    return hello->_s;
  11.   }
 
hello.m:10: warning: DIRECT_ATOMIC_PROPERTY_ACCESS
  Direct access to ivar `_s` of an atomic property at line 10, column 12. Accessing an ivar of an atomic property makes the property nonatomic.
  8.   NSString* m() {
  9.       Hello* hello = nil;
  10. *>*    return hello->_s;
  11.   }
 
hello.m:4: warning: ASSIGN_POINTER_WARNING
  Property `s` is a pointer type marked with the `assign` attribute at line 4, column 1. Use a different attribute like `strong` or `weak`.
  2.   
  3.   @interface Hello: NSObject
  4. *>*@property NSString* s;
  5.   @end
  6.   
 
hello.m:10: warning: DIRECT_ATOMIC_PROPERTY_ACCESS
  Direct access to ivar `_s` of an atomic property at line 10, column 12. Accessing an ivar of an atomic property makes the property nonatomic.
  8.   NSString* m() {
  9.       Hello* hello = nil;
  10. *>*    return hello->_s;
  11.   }
 
hello.m:4: warning: ASSIGN_POINTER_WARNING
  Property `s` is a pointer type marked with the `assign` attribute at line 4, column 1. Use a different attribute like `strong` or `weak`.
  2.   
  3.   @interface Hello: NSObject
  4. *>*@property NSString* s;
  5.   @end
  6.   
 
 
*Summary of the reports*
 
  DIRECT_ATOMIC_PROPERTY_ACCESS: 2
         ASSIGN_POINTER_WARNING: 2
               NULL_DEREF

--------------------

通过infer分析后开始解决问题

可以看出，我们前面的 hello.m 代码里一共有五个问题，其中包括一个错误、四个警告。第一个错误如下：

hello.m:10: error: NULL_DEREFERENCE
  pointer `hello` last assigned on line 9 could be null and is dereferenced at line 10, column 12.
  8.   NSString* m() {
  9.       Hello* hello = nil;
  10. *>*    return hello->_s;
  11.   }
这个错误的意思是， hello 可能为空，需要去掉第 10 行 12 列的引用。我把这行代码做下修改，去掉引用：

return hello.s;
再到终端运行一遍 infer 命令：

infer -- clang -c Hello.m
然后，就发现只剩下了一个警告:

hello.m:4: warning: ASSIGN_POINTER_WARNING
  Property `s` is a pointer type marked with the `assign` attribute at line 4, column 1. Use a different attribute like `strong` or `weak`.
  2.   
  3.   @interface Hello: NSObject
  4. *>*@property NSString* s;
  5.   @end
  6.  
这个警告的意思是说，属性 s 是指针类型，需要使用 strong 或 weak 属性。这时，我将 s 的属性修改为 strong：

@property(nonatomic, strong) NSString* s;
运行 Infer 后，发现没有问题了。

Capturing in make/cc mode...
Found 1 source file to analyze in /Users/ming/Downloads/jikeshijian/infer-out
Starting analysis...
 
legend:
  "F" analyzing a file
  "." analyzing a procedure
 
F.
*No issues found

---------------------

infer工作原理

第一个阶段是转化阶段，将源代码转成 Infer 内部的中间语言。类 C 语言使用 Clang 进行编译，Java 语言使用 javac 进行编译，编译的同时转成中间语言，输出到 infer-out 目录。

第二个阶段是分析阶段，分析 infer-out 目录下的文件。分析每个方法，如果出现错误的话会继续分析下一个方法，不会被中断，但是会记录下出错的位置，最后将所有出错的地方进行汇总输出。
默认情况下，每次运行 infer 命令都会删除之前的 infer-out 文件夹。你可以通过 --incremental 参数使用增量模式。增量模式下，运行 infer 命令不会删除 infer-out 文件夹，但是会利用这个文件夹进行 diff，减少分析量。
一般进行全新一轮分析时直接使用默认的非增量模式，而对于只想分析修改部分情况时，就使用增量模式。【mx：这就是infer完胜其他分析工具的地方吗？还可以增量分析，从而减少分析的时间】

Infer 检查的结果，在 infer-out 目录下，是 JSON 格式的，名字叫做 report.json 。生成 JSON 格式的结果，通用性会更强，集成到其他系统时会更方便。
```