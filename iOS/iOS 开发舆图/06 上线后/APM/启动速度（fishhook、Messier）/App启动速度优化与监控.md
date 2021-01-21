总耗时=main函数之前{pre-main()}+main函数之后+didFinishLaunchingWithOptions

- App启动会干什么事，分别在什么阶段干什么事，从而在每个阶段缩短干事的时间或者减少要干的事，这样App启动的速度就会起来。
- 启动速度的另一个衡量指标就是，你用了多长时间到达首屏渲染
- 为什么要优化App的启动速度现状是：在App项目开发初期，开发人员不多，代码量也没那么大时，这种情况少见，到了后期，App业务规模扩大，团队人员水平参差不齐，各种代码问题就会爆发出来，终归需要来次全面治理。
- 需要一个能够对启动方法耗时进行全面、精确检查的手段。
- 从粗的方面来提速：对启动阶段功能进行分类整理，合理的将和首屏无关的功能滞后，放到首屏渲染完成之后。
- 从细的方面来提速：使用合适的工具，针对每个方法进行逐个分析、优化、每个阶段都做到极致；
- ---------------启动时间粗略分成两块
T1：main()函数之前，即操作系统加载App可执行文件到内存，然后执行一系列的加载&链接等工作，最后执行至App的main()函数。

T2：main()函数之后，即从main()开始，到appDelegate的didFinishLaunchingWithOptions方法执行完毕。

T3：然而，当didFinishLaunchingWithOptions执行完成时，用户还没有看到App的主界面，也不能开始使用App。
例如在外卖App中，App还需要做一些初始化工作，然后经历定位、首页请求、首页渲染等过程后，用户才能真正看到数据内容并开始使用，
我们认为这个时候冷启动才算完成。我们把这个过程定义为T3。

- ---------------main()函数执行前

**这个阶段的任务**
* 加载可执行文件（app的.o文件的集合）
* 加载动态链接库，进行rebase指针调整和bind符号绑定
* Objc运行时的初始化处理，包括Objc相关类的注册、category注册、selector唯一性检查等。
* 初始化，包括了执行+load()方法，attribute((constructor))修饰的函数的调用、创建C++静态全局变量

**这个阶段的提速**
* 减少动态库加载，苹果最多可以支持6个非系统动态库合并为一个。尽量将多个动态库进行合并。
* 减少.o文件的加载
* 减少加载启动后不会去使用的类或者方法
* +load()方法里的内容可以放到首屏渲染完成后再执行，或使用+initialize()方法替换掉。在一个+load()方法里，进行运行时方法替换操作会带来4毫秒的消耗。
* 控制C++全局变量的数量。

- ---------------main()函数执行后

**这个阶段的任务**
* main()函数执行后是从main()函数执行开始，到appDelegate的didFinishLaunchingWithOptions方法里首屏渲染相关方法执行完成。
* 首页的业务代码都要在这个阶段就是在首屏渲染前执行
* 开发者常见的错误会把各种初始化工作都放到这个阶段执行，导致渲染完成滞后
* 包括了下面的任务
* 首屏初始化所需配置文件的读写操作
* 首屏列表大数据的读取
* 首屏渲染的大量计算
* 更加优化的开发方式，应该是从功能上梳理出哪些是首屏渲染必要的初始化功能
* 哪些是App启动必要的初始化功能，哪些是只需要在对应功能开始使用时才需要初始化**

**这个阶段的提速**
* 包括了首屏渲染的任务[功能级别的启动优化]
* main()函数执行后优化思路是：main()函数开始执行后到首屏渲染完成前只处理首屏相关的业务，其他非首屏业务的初始化、监听注册、配置文件读取等都放到首屏渲染完成后去做。
* [方法级别的启动优化：检查首屏渲染完成前主线程上有哪些耗时方法，将没有必要的耗时方法滞后或者异步执行，通常，耗时较长的方法主要发生在计算大量数据的情况下，具体的表现就是加载、编辑、存储图片和文件等资源]
* 比如在使用的ReactiveCocoa框架（iOS上的响应式编程框架），每创建一个信号都有6毫秒的耗时，这样稍不注意各种信号的创建就都放在了首屏渲染完成前，导致App的启动速度大幅变慢。

---

**首屏渲染完成后**
* 这个阶段就是从渲染完成时开始，到didFinishLaunchingWithOptions方法作用域结束时结束。
* 这个阶段任务时完成非首屏其他业务服务模块的初始化、监听的注册、配置文件的读取等
* 这个阶段用户已经能看到App的首页信息了，所以优化的优先级排在最后

**App启动速度的监控手段第一种方法，使用Time Profiler，定时抓取主线程上的方法调用堆栈，计算一段时间里各个方法的耗时**
* 优点：能快速集成到App中，虽然精度不高，但是够用。一般间隔时间设置为0.01秒；
* 缺点：定时抓取的时间设置的太长，会漏掉一些方法，从而导致检查出来的耗时不精确
* 缺点：定时抓取的时间设置的太短，抓取堆栈这个方法本身调用过多也会影响整体耗时，导致结果不准确。
**第二种方法，对objc_msgSend方法进行hook来掌握所有方法的执行耗时**
* 优点：非常精确
* 缺点：只能针对Objective-C的方法；对于c方法和block可以使用libffi的ffi_call来达成hook，但维护工具门槛高。

```
---------------------------

## 总结

```

- app启动速度方案讨论总结：在做具体的事情之前，先要知道，你可以在两个阶段去优化启动速度，一个是执行main函数前，一个是执行main函数后到applicationWillFinishLaunching作用域结束前，就这两个阶段去优化，好了，如果叫我去优化app的启动速度，我会先从两个方面入手，一个减少，一个是调整，减少有4个减少，减少动态库的数量，减少objc类的数目，减少category的数据，减少+load方法使用；调整有3个调整，调整applicationWillFinishLaunching方法中可以延后执行的代码，调整app图片的大小，调整用dispatchonce()代替所有的__attribute__((constructor))函数；其中调整纯代码方式而不是storyboard加载首页UI。
- 先说结论，t(App总启动时间) = t1(main()之前的加载时间) + t2(main()之后的加载时间)。
- t1 = 系统dylib(动态链接库)和自身App可执行文件的加载；
- t2 = main方法执行之后到AppDelegate类中的- (BOOL)Application:(UIApplication *)Application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法执行结束前这段时间，主要是构建第一个界面，并完成渲染展示。刘汶追加：main 到 didFinishLaunching 结束或者第一个 ViewController 的viewDidAppear 都是作为 main 之后启动时间的一个度量指标。

---

## 优化的目标

- 应该在400ms内完成main()函数之前的加载
- 整体过程耗时不能超过20秒，否则系统会kill掉进程，App启动失败

---

## 研究的事

- 今天研究的是怎么提高app的启动速度，启动速度的重要性要说一说，比如现在用户很急着用你app里面的一个功能，如果和竞品相比，你的速度是他的几倍，你说他会用谁的app呢，肯定是你的。谈到启动速度，ios，有分成两种，一种是冷启动，一种是热启动，先说热启动，热启动就是app已经打开过一次了，没有杀掉进程，重新打开，不需要加载过多的资源，因为原本已经加载了一次了。再说冷启动，就是一个app，完全从新打开，就像电脑重启一样了，所有资源都必须加载一次。那说到冷启动，就要说说这个过程中的几步了，大致分为执行main方法之前，执行main方法到didfinishlaunch方法之间，最后就是didfinishlaunch这个方法的作用域内，主要从这3个阶段来优化启动速度，所以必须先了解，这3个阶段，都有做什么事，这三个阶段都把时间花在做什么身上了。

---

## 第一部分：卡顿分析

### 第一阶段：pre-main阶段

执行main方法之前，主要会做几件事，分别是加载app内的可执行文件，就是.o文件的合集；然后就是加载动态链接库，执行rebase指针调整和bind符号绑定；然后是对objc运行时的初始处理，包括objc相关类的注册、category注册、selector唯一性检查等；最后一个件事是初始化，包括了执行+load（）方法、attribute（constructor）修饰的函数的调用，创建c++静态全局变量。

### 第二阶段：main函数执行后

那执行main函数之后呢，有会把时间花在哪里呢，先说说这个阶段界定的界线，其实是从main函数执行开始，到appdelegate的didfinishlaunchingwithoptions方法里首屏渲染相关方法执行完成，这里说的首屏渲染相关方法执行完成，具体是哪些代码，还要斟酌一下。文中提到，首页的业务代码都要在这个阶段执行完成。所以这个阶段的时间会花在首屏初始化所需配置文件的读写操作；首屏列表大数据的读取；首屏渲染的大量计算等；追加：从main()函数开始至applicationWillFinishLaunching结束，我们统一称为main()函数之后的部分。刘汶追加：main()函数之后耗时的影响因素；执行main()函数的耗时；执行applicationWillFinishLaunching的耗时；rootViewController及其childViewController的加载、view及其subviews的加载。

### 第三阶段：首屏渲染完成后

最后的阶段就是首屏渲染完成后的阶段，这个阶段会把时间花在哪里呢，这个阶段的界线是从渲染完成时开始，到didfinishlaunchingwithoptions方法作用域结束时结束。需要提到，这个阶段用户已经能够看到app的首页信息了，所以优化的优先级排在最后。注意一点：那些会卡住主线程的方法还是需要最优先处理的，不然还是会影响到用户后面的交互操作。

---

## 第二部分：卡顿解决方案

- 上面3个阶段把时间都安排在哪里，都做了说明了，现在开始要说说，在这3个阶段，你都可以做什么事情，把花的时间减少到最小了。

### pre-mian解决方案

- 在执行main函数之前，我做什么可以减少花在启动上的时间呢，第一个因为这个阶段是会加载动态库的，所以减少动态库加载就是一个方法，文中建议在使用动态库的数量较多时，尽量将多个动态库进行合并，现在苹果公司可以支持6个非系统动态库合并为一个；第二个优化的方案是减少加载启动后不会去使用的类或者方法，这个怎么去查看哪些不用，且怎么延迟加载是个问题呢；第三个优化方案是把+load方法的内容放到首屏渲染完成后再执行，或者使用+initialize（）方法替换掉+load方法。我们说说+load方法的时间占用，在一个+load方法里面，进行运行时方法替换操作会带来4毫秒的消耗。文中说到不要小看这4毫秒，积少成多。第四个优化方法是控制c++全局变量的数量。main()函数之前耗时的影响因素：动态库加载越多，启动越慢。ObjC类越多，启动越慢；C的constructor函数越多，启动越慢；C++静态对象越多，启动越慢；ObjC的+load越多，启动越慢

### mian函数执行后解决方案

- 再说说执行mian函数之后，你能怎么做，减少启动时间，这个阶段主要是通过梳理功能初始化时机来优化，比如从功能上梳理出哪些是首屏渲染必要的初始化功能，哪些是app启动必要的初始化功能，哪些是只需要在对应功能开始使用时才需要初始化。通过梳理之后，将这些初始化功能放到合适的阶段执行就完成了这个阶段的优化了。优化的思路是：在main函数执行后到首屏渲染完成前只处理首屏相关的业务，其他非首屏业务的初始化，监听注册，配置文件读取等都放到首屏渲染完成后去做。这里我有个疑问，这个阶段的界线我还是不是很明确，没有说具体是哪个方法里面，只说是main函数执行后，首屏渲染前去优化，到底是tmd哪里。在说说这个阶段的思路，经过功能方法的优化，进一步做的，就是检查首屏渲染前主线程上有哪些耗时方法，将没必要的耗时方法滞后或者异步执行。文中提到通常情况下，耗时较长的方法主要发生在计算大量数据的情况下，具体的表现就是加载、编辑、存储图片和文件等资源。

### 首屏渲染完成后

最后一个阶段是，首屏渲染完成后，这个阶段好像文中没有提到具体的优化方案。

## 最后

优化的内容都已经说了，具体就是去操作了，操作的方法文中是没有提到，给你一个思路，自己去找答案，下一个要说的是如何去测测自己app的启动速度，大致还有两种方法。第一种检测启动速度的方法是定时抓取主线程上的方法调用堆栈，计算一段时间里各个方法的耗时，这种定时抓取主线程调用栈的方法精准度不够高，但是够用。第二种方法是对objc_msgSend方法进行hook来掌握所有方法的执行耗时；说说这个方法的优缺点，hook objc_msgSend这种方式的优点是非常精确，缺点是只能针对objective-c的方法。文中提到，对于c方法和block，可以使用libffi和fii_call来达成hook，但缺点是编写维护相关工具门槛高。综上，如果对于检查结果精准度要求高的话，我比较推荐你使用hook objc_msgSend方式来检查启动方法的执行耗时。文中分享的查找app调用方法的时间的项目文件，移入到自己的app时，有报错，所以现在开始寻找其他大的平台的优化启动速度方法。

---

## 实践的方法1，查看耗时，通过xcode自带的功能，就可以看到启动的耗时

- Xcode的菜单中选择Project→Scheme→Edit Scheme...，然后找到 Run → Environment Variables →+，添加name为DYLD_PRINT_STATISTICS value为1的环境变量。
- 在Xcode运行App时，会在console中得到一个报告。例如，我在WiFi管家中加入以上设置之后，会得到这样一个报告：

```
Total pre-main time:  94.33 milliseconds (100.0%)
         dylib loading time:  61.87 milliseconds (65.5%)
        rebase/binding time:   3.09 milliseconds (3.2%)
            ObjC setup time:  10.78 milliseconds (11.4%)
           initializer time:  18.50 milliseconds (19.6%)
           slowest intializers :
             libSystem.B.dylib :   3.59 milliseconds (3.8%)
   libBacktraceRecording.dylib :   3.65 milliseconds (3.8%)
                    GTFreeWifi :   7.09 milliseconds (7.5%)

```

如何解读

- main()函数之前总共使用了94.33ms
- 在94.33ms中，加载动态库用了61.87ms，指针重定位使用了3.09ms，ObjC类初始化使用了10.78ms，各种初始化使用了18.50ms。
- 在初始化耗费的18.50ms中，用时最多的三个初始化是libSystem.B.dylib、libBacktraceRecording.dylib以及GTFreeWifi。

---

启动速度优化，昨天试了打开自己的app，启动是别人的3倍慢，支付宝2秒，我的要6、7秒，这个速度，我也是醉了。启动速度刻不容缓啊。还是先进行最简单的，进行二进制重排来试试，先记录优化前的数据为：
Total pre-main time: 645.65 milliseconds (100.0%)
dylib loading time:  76.62 milliseconds (11.8%)
rebase/binding time:  68.39 milliseconds (10.5%)
ObjC setup time:  66.08 milliseconds (10.2%)
initializer time: 434.55 milliseconds (67.3%)
slowest intializers :
libSystem.B.dylib :  15.12 milliseconds (2.3%)
libMainThreadChecker.dylib :  51.17 milliseconds (7.9%)
xbb : 651.71 milliseconds (100.9%)

开始二进制重排优化启动速度
Total pre-main time: 675.35 milliseconds (100.0%)
dylib loading time: 162.44 milliseconds (24.0%)
rebase/binding time:  69.21 milliseconds (10.2%)
ObjC setup time:  49.99 milliseconds (7.4%)
initializer time: 393.69 milliseconds (58.2%)
slowest intializers :
libSystem.B.dylib :   4.74 milliseconds (0.7%)
libMainThreadChecker.dylib :  34.57 milliseconds (5.1%)
xbb : 636.58 milliseconds (94.2%)

1.这样像上面做的是从工具入手，利用工具达到启动速度优化，下面就从代码层角度去实心。

- ------------------app的启动过程【腾讯wifi管家】
- 解析Info.plist
    - 加载相关信息，例如如闪屏
    - 沙箱建立、权限检查
- Mach-O加载
    - 如果是胖二进制文件，寻找合适当前CPU类别的部分
    - 加载所有依赖的Mach-O文件（递归调用Mach-O加载的方法）
    - 定位内部、外部指针引用，例如字符串、函数等
    - 执行声明为__attribute__((constructor))的C函数
    - 加载类扩展（Category）中的方法
    - C++静态对象加载、调用ObjC的 +load 函数
- 程序执行
    - 调用main()
    - 调用UIApplicationMain()
    - 调用applicationWillFinishLaunching

main()函数之后的任务

![https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/OQG6vP.jpg](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/OQG6vP.jpg)

启动时间段T1-T2.jpg

![https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/SpU9Gg.jpg](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/SpU9Gg.jpg)

启动时间段T3.jpg

![https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/92Dhde.jpg](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/92Dhde.jpg)