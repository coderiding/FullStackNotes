### iOS面试题

##### 157.给一个任意类型数组，要求写一个函数，交换数组中的两个元素
```
func swap(_ nums: inout [Int], _ p: Int, _ q: Int) { 
    let temp = nums[p] 
    nums[p] = nums[q] 
    nums[q] = temp  
} 

// 任意类型的数组
func swap<T>(_ nums: inout [T], _ p: Int, _ q: Int) { 
    let temp = nums[p] 
    nums[p] = nums[q] 
    nums[q] = temp  
} 

// 考察了Swift的泛型和Tuple的性质
func swap<T>(_ nums: inout [T], _ p: Int, _ q: Int) { 
    (nums[p], nums[q]) = (nums[q], nums[p]) 
}
```

##### 156.以下代码会打印出什么？
``` 
protocol Pizzeria {  
  func makePizza(_ ingredients: [String]) 
  func makeMargherita() 
}  

extension Pizzeria {  
  func makeMargherita() {  
    return makePizza(["tomato", "mozzarella"])  
  } 
} 

struct Lombardis: Pizzeria {  
  func makePizza(_ ingredients: [String]) {  
    print(ingredients) 
  }  
  func makeMargherita() { 
    return makePizza(["tomato", "basil", "mozzarella"])  
  } 
} 

let lombardis1: Pizzeria = Lombardis() 
let lombardis2: Lombardis = Lombardis()  
lombardis1.makeMargherita() 
lombardis2.makeMargherita() 
```

* 答案：打印出如下两行 
* 在Lombardis的代码中，重写了makeMargherita的代码，所以永远调用的是Lombardis 中的 makeMargherita。 
``` 
["tomato", "basil", "mozzarella"] 
["tomato", "basil", "mozzarella"] 
```

##### 155.以下函数会打印出什么？ 
``` 
var car = "Benz"  
let closure = { [car] in  
  print("I drive \(car)") 
}  
car = "Tesla"  
closure() 
```

* 答案：因为 clousre 已经申明将 car 复制进去了（[car]），此时clousre 里的 car 是个局部变量，不再与外面的 car有关，所以会打印出"I drive Benz"。

##### 154.精简以下代码 
``` 
func divide(dividend: Double?, by divisor: Double?) -> Double? {  
  if dividend == nil {  
    return nil  
  }   
  if divisor == nil {  
    return nil  
  }  
  if divisor == 0 {  
    return nil 
  }   
  return dividend! / divisor! 
} 
```

* 这题考察的是 guard let 语句以及 optional chaining，最佳答案是 
``` 
func divide(dividend: Double?, by divisor: Double?) -> Double? {  
    guard let dividend = dividend, let divisor = divisor, divisor != 0 else { 
        return nil 
    } 
     
    return dividend / divisor 
} 
```

##### 153.实现一个函数，输入是任一整数，实现返回 + 6, + 8等任何整数 的操作呢？只能定义一次方法？
``` 
// 利用 Swift 的 Currying 特性： 
func add(_ num: Int) -> (Int) -> Int { 
  return { val in 
    return num + val 
  } 
} 

let addTwo = add(2), addFour = add(4), addSix = add(6), addEight = add(8) 
```

##### 152.Swift 中定义常量和 Objective-C 中定义常量有什么区别？ 
* 首先第一个区别，OC中用 const 来表示常量，而 Swift 中用 let 来判断是不是常量。 
* 上面的区别更进一步说，OC中 const 表明的常量类型和数值是在 compilation time 时确定的；而 Swift 中 let 只是表明常量（只能赋值一次），其类型和值既可以是静态的，也可以是一个动态的计算方法，它们在 runtime 时确定的。 

##### 143.Swift 到底是面向对象还是函数式的编程语言？ 
* Swift 既是面向对象的，又是函数式的编程语言。 
* 说 Swift 是 Object-oriented，是因为 Swift 支持类的封装、继承、和多态，从这点上来看与 Java 这类纯面向对象的语言几乎毫无差别。 
* 说 Swift 是函数式编程语言，是因为 Swift 支持 map, reduce, filter, flatmap 这类去除中间状态、数学函数式的方法，更加强调运算结果而不是中间过程。 

##### 151.以下代码会打印出什么？ 
``` 
protocol Pizzeria { 
  func makePizza(_ ingredients: [String]) 
} 

extension Pizzeria { 
  func makeMargherita() { 
    return makePizza(["tomato", "mozzarella"]) 
  } 
} 

struct Lombardis: Pizzeria { 
  func makePizza(_ ingredients: [String]) { 
    print(ingredients) 
  } 
  func makeMargherita() { 
    return makePizza(["tomato", "basil", "mozzarella"]) 
  } 
} 

let lombardis1: Pizzeria = Lombardis() 
let lombardis2: Lombardis = Lombardis() 
lombardis1.makeMargherita() 
lombardis2.makeMargherita() 
```


* 这时候打印出如下结果： 
* 因为lombardis1 是 Pizzeria，而 makeMargherita() 有默认实现，这时候我们调用默认实现。 
```
["tomato", "mozzarella"] 
["tomato", "basil", "mozzarella"]
```

##### 150.以下函数会打印出什么？ 
``` 
var car = "Benz"  
let closure = { 
  print("I drive \(car)") 
}  
car = "Tesla"  
closure() 
```

* 答案：此时 closure 没有申明复制拷贝 car，所以clousre 用的还是全局的 car 变量，此时将会打印出 "I drive Tesla" 

##### 149.下面代码有什么问题 ?
``` 
public class Node { 
  public var value: Int 
  public var prev: Node? 
  public var post: Node? 

  public init(_ value: Int) { 
    self.value = value 
  } 
} 
```

* 答案：应该在 var prev 或者 var post 前面加上 weak。 
* 原因：表面上看，以上代码毫无问题。但是我这样一写，问题就来了： 
``` 
let head = Node(0) 
let tail = Node(1) 
head.post = tail 
tail.prev = head 
```
* 此时，head 和 tail 互相指向，形成循环引用（retain cycle）。

##### 148.Swift 中 struct 和 class 什么区别？举个应用中的实例 
* struct 是值类型，class 是引用类型。

* 此时 a 的 val 也被改成了 2，因为 a 和 b 都是引用类型，本质上它们指向同一内存。解决这个问题的方法就是使用 struct： 
``` 
class A { 
  var val = 1 
} 

var a = A() 
var b = a 
b.val = 2 
```

* 此时 A 是struct，值类型，b 和 a 是不同的东西，改变 b 对于 a 没有影响。 
``` 
struct A { 
  var val = 1 
} 

var a = A() 
var b = a 
b.val = 2 
```

##### 147.实现一个函数，输入是任一整数，输出要返回输入的整数 + 2
```
func addTwo(_ num: Int) -> Int { 
    return num + 2 
} 

func add(_ num: Int) -> (Int) -> Int { 
  return { val in 
    return num + val 
  } 
}
```

##### 146.map 、filter、reduce 的作用?

##### 145.dynamic的作用?

##### 144.下面的代码会不会崩溃，说出原因?
```
var mutableArray = [1,2,3] 
for _ in mutableArray { 
    mutableArray.removeLast() 
} 
```

##### 143.如何解决引用循环？

##### 142.inout 的作用？

##### 141.代码混淆常见的几种方式？代码混淆会出现什么问题？系统SDK的代码能进行混淆吗？
* 对类名和方法名进行混淆
* 给需要混淆的代码加上前缀
* 混淆太多会被苹果拒绝

##### 140.全日志埋点会遇到什么问题？
* IO磁盘读写过多导致APP运行不流畅。

##### 139.引入第三方库的时候需要注意什么？
* 看是否有影响耗时操作的代码，影响启动速度，比如使用了+load方法
* 看是否依赖了第三方的库，有时候会和你使用的库有冲突，比如版本的冲突
* 非大神的底层库，不使用pod方式引入，因为修改的可能性很大，尤其是一些UI控件的库

---

##### 138.static的作用？
* static修饰的函数是一个内部函数，只能在本文件中调用，其他文件不能调用
* static修饰的全部变量是一个内部变量，只能在本文件中使用，其他文件不能使用
* static修饰的局部变量只会初始化一次，并且在程序退出时才会回收内存

---

##### 137.线程和进程的区别？
* 一个应用程序对应一个进程，一个进程帮助程序占据一块存储空间
* 要想在进程中执行任务，就必须开启线程，一条线程就代表一个任务
* 一个进程中允许开启多条线程，也就是同时执行多个任务

---

##### 136.堆和栈的区别？
* 堆空间的内存是动态分配的，一般存放对象，并且需要手动释放内存
* 栈空间的内存由系统自动分配，一般存放局部变量等，不需要手动管理内存

---

##### 135.ViewController的didReceiveMemoryWarning是在什么时候调用的？默认的操作是什么？
* 当应用程序接收到系统的内容警告时，就有可能调用控制器的didRece…Warning方法
* 它的默认做法是：
* 当控制器的view不在窗口上显示时，就会直接销毁，并且调用viewDidUnload方法

---

##### 134.怎么理解MVC，在Cocoa中MVC是怎么实现的？
* M：Model，模型，封装数据
* V：View，视图界面，负责展示数据
* C：Controller，控制器，负责提供数据（Model）给界面（View）

---

##### 133.self.跟self->什么区别？
* self.是调用get方法或者set放
* self是当前本身，是一个指向当前对象的指针
* self->是直接访问成员变量

---

##### 132.id、nil代表什么？
* id类型的指针可以指向任何OC对象
* nil代表空值（空指针的值， 0）

---

##### 131.如何对iOS设备进行性能测试?
* Timer Profile

---

##### 130.怎么介绍一个项目
* 项目的价值（可以加些“老板”关键字）
* 项目的模块
* 我做的是哪个模块

---

##### 129.如果在网络数据处理过程中,发现一处比较卡,一般怎么解决
* 检查网络请求操作是否被放在主线程了
* 看看异步请求的数量是否太多了（子线程数量）
* 数据量是否太大？如果太大，先清除一些不必要的对象（看不见的数据、图片）
* 手机CPU使用率和内存问题

---

##### 128.SDWebImage具体如何实现
* 利用NSOperationQueue和NSOperation下载图片, 还使用了GCD的一些函数(解码GIF图片)
* 利用URL作为key，NSOperation作为value
* 利用URL作为key，UIImage作为value

---

##### 127.APP需要加载超大量的数据，给服务器发送请求，但是服务器卡住了如何解决？
* 设置请求超时
* 给用户提示请求超时
* 根据用户操作再次请求数据

---

##### 126.你实现过一个框架或者库以供别人使用么？如果有，请谈一谈构建框架或者库时候的经验；如果没有，请设想和设计框架的public的API，并指出大概需要如何做、需要注意一些什么方面，来使别人容易地使用你的框架。
* 提供给外界的接口功能是否实用、够用
* 别人使用我的框架时，能不能根据类名、方法名就猜出接口的具体作用
* 别人调用接口时，提供的参数是否够用、调用起来是否简单
* 别人使用我的框架时，要不要再导入依赖其他的框架

---

##### 125.有些图片加载的比较慢怎么处理?你是怎么优化程序的性能的?
* 图片下载放在异步线程
* 图片下载过程中使用占位图片
* 如果图片较大，可以考虑多线程断点下载

---

##### 124.SIP是什么？
* SIP（Session Initiation Protocol），会话发起协议
* SIP是建立VOIP连接的 IETF 标准，IETF是全球互联网最具权威的技术标准化组织
* 所谓VOIP，就是网络电话，直接用互联网打电话，不用耗手机话费

---

##### 123.客户端安全性处理方式？
* 网络数据传输(敏感数据[账号\密码\消费数据\银行卡账号], 不能明文发送)
* 协议的问题(自定义协议, 游戏代练)
* 本地文件存储(游戏的存档)
* 源代码

---

##### 122.IOS7之前,后台执行内容有几种形式,都是什么
* 一般的应用在进入后台的时候可以获取一定时间来运行相关任务，也就是说可以在后台运行一小段时间(10S左右)。
	* 后台播放音乐
	* 后台GPS跟踪
	* 后台voip支持

---

##### 121.NSRunLoop的实现机制,及在多线程中如何使用
* NSRunLoop是IOS消息机制的处理模式
	* 1.NSRunLoop的主要作用：控制NSRunLoop里面线程的执行和休眠，在有事情做的时候使当前NSRunLoop控制的线程工作，没有事情做让当前NSRunLoop的控制的线程休眠。
	* 2.NSRunLoop 就是一直在循环检测，从线程start到线程end，检测inputsource(如点击，双击等操作)异步事件，检测timesource同步事件，检测到输入源会执行处理函数，首先会产生通知，corefunction向线程添加runloop observers来监听事件，意在监听事件发生时来做处理。
	* 3.runloopmode是一个集合，包括监听：事件源，定时器，以及需通知的runloop observers

* 只有在为你的程序创建次线程的时候，才需要运行run loop。对于程序的主线程而言，run loop是关键部分。Cocoa提供了运行主线程run loop的代码同时也会自动运行run loop。IOS程序UIApplication中的run方法在程序正常启动的时候就会启动run loop。如果你使用xcode提供的模板创建的程序，那你永远不需要自己去启动run loop
* 在多线程中，你需要判断是否需要run loop。如果需要run loop，那么你要负责配置run loop并启动。你不需要在任何情况下都去启动run loop。比如，你使用线程去处理一个预先定义好的耗时极长的任务时，你就可以毋需启动run loop。Run loop只在你要和线程有交互时才需要

---

##### 120.如何渲染自定义格式字符串的UILabel
* 通过NSAttributedString类

---

##### 119.怎么解决缓存池满的问题(cell)
* ios中不存在缓存池满的情况，因为通常我们ios中开发，对象都是在需要的时候才会创建，有种常用的说话叫做懒加载，还有在UITableView中一般只会创建刚开始出现在屏幕中的cell，之后都是从缓存池里取，不会在创建新对象。缓存池里最多也就一两个对象，缓存池满的这种情况一般在开发java中比较常见，java中一般把最近最少使用的对象先释放。

---

##### 118.你实现过多线程的Core Data么？NSPersistentStoreCoordinator，NSManagedObjectContext和NSManagedObject中的哪些需要在线程中创建或者传递？你是用什么样的策略来实现的？
* CoreData是对SQLite数据库的封装
* CoreData中的NSManagedObjectContext在多线程中不安全
* 如果想要多线程访问CoreData的话，最好的方法是一个线程一个NSManagedObjectContext
* 每个NSManagedObjectContext对象实例都可以使用同一个NSPersistentStoreCoordinator实例，这是因为NSManagedObjectContext会在便用NSPersistentStoreCoordinator前上锁

---

##### 117.简单描述下客户端的缓存机制？
* 缓存可以分为：内存数据缓存、数据库缓存、文件缓存
* 每次想获取数据的时候
* 先检测内存中有无缓存
* 再检测本地有无缓存(数据库\文件)
* 最终发送网络请求
* 将服务器返回的网络数据进行缓存（内存、数据库、文件）， 以便下次读取

---

##### 116.如果后期需要增加数据库中的字段怎么实现，如果不使用CoreData呢？

* 编写SQL语句来操作原来表中的字段
	* 增加表字段
	* ALTER TABLE 表名 ADD COLUMN 字段名 字段类型;
* 删除表字段
	* ALTER TABLE 表名 DROP COLUMN 字段名;
* 修改表字段
	* ALTER TABLE 表名 RENAME COLUMN 旧字段名 TO 新字段名;

---

##### 115.Block内部的实现原理
* Objective-C是对C语言的扩展，block的实现是基于指针和函数指针

---

##### 114.NSNotification和KVO的区别和用法是什么？什么时候应该使用通知，什么时候应该使用KVO，它们的实现上有什么区别吗？如果用protocol和delegate（或者delegate的Array）来实现类似的功能可能吗？如果可能，会有什么潜在的问题？如果不能，为什么？（虽然protocol和delegate这种东西面试已经面烂了…）
* 通知比较灵活(1个通知能被多个对象接收, 1个对象能接收多个通知), 
* 代理比较规范，但是代码多(默认是1对1)
* KVO性能不好(底层会动态产生新的类)，只能监听某个对象属性的改变, 不推荐使用(1个对象的属性能被多个对象监听,  1个对象能监听多个对象的其他属性)

---

##### 113.是否使用Core Text或者Core Image等？如果使用过，请谈谈你使用Core Text或者Core Image的体验。

* CoreText
	* 随意修改文本的样式
	* 图文混排(纯C语言)
	* 国外:Niumb
* Core Image(滤镜处理)
	* 能调节图片的各种属性(对比度, 色温, 色差等)

--

##### 112.runtime实现的机制是什么,怎么用，一般用于干嘛. 你还能记得你所使用的相关的头文件或者某些方法的名称吗？
* 运行时机制，runtime库里面包含了跟类、成员变量、方法相关的API，比如获取类里面的所有成员变量，为类动态添加成员变量，动态改变类的方法实现，为类动态添加新的方法等 需要导入<objc/message.h> <objc/runtime.h>
	* runtime，运行时机制，它是一套C语言库
	* 实际上我们编写的所有OC代码，最终都是转成了runtime库的东西，比如类转成了runtime库里面的结构体等数据类型，方法转成了runtime库里面的C语言函数，平时调方法都是转成了objc_msgSend函数（所以说OC有个消息发送机制）
	* 因此，可以说runtime是OC的底层实现，是OC的幕后执行者
	* 有了runtime库，能做什么事情呢？runtime库里面包含了跟类、成员变量、方法相关的API，比如获取类里面的所有成员变量，为类动态添加成员变量，动态改变类的方法实现，为类动态添加新的方法等
	* 因此，有了runtime，想怎么改就怎么改

---

##### 111.什么是动态，举例说明
* 在程序运行过程才执行的操作

---

##### 110.简单描述下对单利模式设计的理解？
* 节省内存资源，一个应用就一个对象。

---

##### 109.不用中间变量,用两种方法交换A和B的值

```

A = A + B
B = A - B
A = A - B
或者
A = A^B;
B = A^B;
A = A^B;

```

---

##### 108.Foundation对象与Core Foundation对象有什么区别
* Foundation对象是OC的，Core Foundation对象是C对象
* 数据类型之间的转换
	* ARC:__bridge_retained、__bridge_transfer
	*  非ARC: __bridge

---

##### 107.是否可以把比较耗时的操作放在NSNotificationCenter中
* 如果在异步线程发的通知，那么可以执行比较耗时的操作；
* 如果在主线程发的通知，那么就不可以执行比较耗时的操作

---

##### 106.KVO内部实现原理
* KVO是基于runtime机制实现的
* 当某个类的对象第一次被观察时， 系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的 setter 方法。 
派生类在被重写的 setter 方法实现真正的通知机制（Person NSKVONotifying_Person）

---

##### 105.自动释放池底层怎么实现
* 自动释放池以栈的形式实现:当你创建一个新的自动释放池时，它将被添加到栈顶。当一个对象收到发送autorelease消息时,它被添加到当前线程的处于栈顶的自动释放池中,当自动释放池被回收时,它们从栈中被删除, 并且会给池子里面所有的对象都会做一次release操作.

---

##### 104.什么情况下会发生内存泄漏和内存溢出？
* 当程序在申请内存后，无法释放已申请的内存空间(例如一个对象或者变量使用完成后没有释放,这个对象一直占用着内存)，一次内存泄露危害可以忽略，但内存泄露堆积后果很严重，无论多少内存,迟早会被占光。内存泄露会最终会导致内存溢出！
* 当程序在申请内存时，没有足够的内存空间供其使用，出现out of memory；比如申请了一个int,但给它存了long才能存下的数，那就是内存溢出。

---

##### 103.怎么保证多人开发进行内存泄露的检查
* 使用Analyze进行代码的静态分析
* 为避免不必要的麻烦, 多人开发时尽量使用ARC

---

##### 102.http协议的实现

---

##### 101.Socket的实现原理及Socket之间是如何通信的

---

##### 100.在异步线程中下载很多图片,如果失败了,该如何处理?请结合RunLoop来谈谈解决方案.(提示:在异步线程中启动一个RunLoop重新发送网络请求,下载图片)
* 重新下载图片
* 下载完毕, 利用RunLoop的输入源回到主线程刷新UIImageVIUew

---

##### 99.既然提到GCD，那么问一下在使用GCD以及block时要注意些什么？它们两是一回事儿么？block在ARC中和传统的MRC中的行为和用法有没有什么区别，需要注意些什么？

* block的使用注意：
* block的内存管理
* 防止循环retian
	* 非ARC（MRC）：__block
	* ARC：__weak\__unsafe_unretained

---

##### 98.你用过NSOperationQueue么？如果用过或者了解的话，你为什么要使用NSOperationQueue，实现了什么？请描述它和GCD的区别和类似的地方（提示：可以从两者的实现机制和适用范围来描述）。
* GCD是纯C语言的API，NSOperationQueue是基于GCD的OC版本封装
* GCD只支持FIFO的队列，NSOperationQueue可以很方便地调整执行顺序、设置最大并发数量
* NSOperationQueue可以在轻松在Operation间设置依赖关系，而GCD需要写很多的代码才能实现
* NSOperationQueue支持KVO，可以监测operation是否正在执行（isExecuted）、是否结束（isFinished），是否取消（isCanceld）
* GCD的执行速度比NSOperationQueue快
* 任务之间不太互相依赖：GCD
* 任务之间有依赖\或者要监听任务的执行情况：NSOperationQueue

---

##### 97.GCD内部怎么实现的?
* iOS和OS X的核心是XNU内核，GCD是基于XNU内核实现的
* GCD的API全部在libdispatch库中
* GCD的底层实现主要有Dispatch Queue和Dispatch Source
	* Dispatch Queue ：管理block(操作)
	* Dispatch Source ：处理事件

---

##### 96.列举cocoa中常见对几种多线程的实现，并谈谈多线程安全的几种解决办法及多线程安全怎么控制？
* 只在主线程刷新访问UI
* 如果要防止资源抢夺，得用synchronized进行加锁保护
* 如果异步操作要保证线程安全等问题, 尽量使用GCD(有些函数默认就是安全的)

---

##### 95.用NSOpertion和NSOpertionQueue处理A,B,C三个线程,要求执行完A,B后才能执行C,怎么做？

```

// 创建队列
NSOperationQueue *queue = [[NSOperationQueue alloc] init];

// 创建3个操作
NSOperation *a = [NSBlockOperation blockOperationWithBlock:^{
	NSLog(@”operation1---“);
}];
NSOperation *b = [NSBlockOperation blockOperationWithBlock:^{
	NSLog(@”operation1---“);
}];
NSOperation *c = [NSBlockOperation blockOperationWithBlock:^{
	NSLog(@”operation1---“);
}];

// 添加依赖
[c addDependency:a];
[c addDependency:b];

// 执行操作
[queue addOperation:a];
[queue addOperation:b];
[queue addOperation:c];

```

---

##### 94.网络图片处理问题中怎么解决一个相同的网络地址重复请求的问题？
* 利用字典（图片地址为key，下载操作为value）

---

##### 93.线程间怎么通信？
* performSelector:onThread:withObject:waitUntilDone:
* NSMachPort

---

##### 92.多线程的底层实现？
* 首先搞清楚什么是线程、什么是多线程
* Mach是第一个以多线程方式处理任务的系统，因此多线程的底层实现机制是基于Mach的线程
* 开发中很少用Mach级的线程，因为Mach级的线程没有提供多线程的基本特征，线程之间是独立的
* 开发中实现多线程的方案
	* C语言的POSIX接口：#include <pthread.h>
	* OC的NSThread
	* C语言的GCD接口（性能最好，代码更精简）
	* OC的NSOperation和NSOperationQueue（基于GCD）

---

---------------最近更新20200223日

##### 91.看下面的方法执行完之后 ViewController 会被销毁吗，ViewController 的 view 会被销毁吗?为什么?

```

- (void)addViewController { 
	UIViewController *viewController = [[UIViewContrnller alloc] init];
	[self.view addSubview: viewController.view]; 
}

```

* 【答案】view被引用，vc没被引用，所以VC被销毁，view不销毁。
* 详细解释：
	* vc引用view，view对vc无引用。 vc在view在，view在与vc可不在。vc为局部变量，方法结束后直接销毁；vc.view被添加在self.view上，所以不会被销毁.

---

##### 90.有没有办法通过提供的ipa包然后判断出是支持ipad还是iphone，还是都支持。

把IPA解压，包内容的info.plist有个UIDeviceFamily，值=1是iPhone，=2是iPad，=1,2是都支持

```

/usr/libexec/PlistBuddy -c 'Print :UIDeviceFamily' xxx.app/Info.plist

```

---

##### 89.如果你一直在用GitLab开发，现在公司要切换到GitHub开发，可以两个邮箱不一样，你自己的提交记录，GitHub无法识别，签到数据也没了，请问如何让GitHub能够识别你整个仓库中所有的提交记录。

要达到
* 提交要保留提交记录
* changelog要保留
* 组内成员要保留

解决方案

```

git push --mirror ......

// 操作
// 假如我们原有的仓库为git@codehub.devcloud.huaweicloud.com:project.git

```

* 1. 从原地址克隆一份裸版本库

```

$ git clone --bare git@codehub.devcloud.huaweicloud.com:project.git

```

* 2. 在新目录创建git___空___项目
	* 这一步是为了让旧项目有镜像
	* 假如新仓库地址为git@codehub.devcloud.huaweicloud.com:leaderProject.git

* 3. 镜像推送代码到新仓库
	* 进入旧git目录，推送即可

```

$ cd project
$ git push --mirror git@codehub.devcloud.huaweicloud.com:leaderProject.git

```

---

##### 88.如图label1在containerView上，containerView、label2在cell.contentView上，问题：label1与label2的字数不固定，需求是，无论label2字数多少，label1都不能被拉伸或者压缩
* 需要给label1设置一下优先级，设置平行的的Content compression resistance priority。

---

##### 87.在IM开发中】app 接收到一个message，上层UI刷新一次，要求考虑到CPU和电量消耗，解决短时间内接收到很多条消息的问题。怎么解决？有几种方案？
* 方案一：利用联结(在异步线程上调用dispatch_source_merge_data后，就会执行 dispatch source 事先定义好的handler）、DISPATCH_SOURCE_TYPE_DATA_ADD，将刷新UI的工作拼接起来，短时间内做尽量少次数的刷新。

* 方案二：自己实现队列、确定一个合适的时间阈值，在阈值时间到达时、主动取消息或者被动接受消息，最后刷新UI，达到消息限流的作用。举例：假设我们消息的获取都是通过长连接推送过来的，而不是主动拉取的。可以用消息队列来做，消费者定期去队列取数据进行数据展示。
或者假设前一条消息和后一条消息间隔只在0.2s以内，就可以认为是频繁收到消息。然后把这0.2s内的消息刷新相关操作，比如做个动画效果。

---

##### 86.缓存操作进行优化的措施中，有没有迎合用户“喜旧厌新”的算法技巧，可谓是缓存界的“断舍离”算法？也即：那些过去经常被访问的，将来也很可能被访问，优先级提高。那些长时间不被访问的，直接删了就好。描述下算法的实现原理。给出工作中至少两个使用场景。
* LRU彻汰策略，应用场景比如iOS的两个常用库：Lottie、YYCache

---

##### 85.用autolayout做下横竖屏适配：里面：蓝色是父视图，子视图是Label和图片，图片可拉伸。Label和图片总是相对居中显示。对图片顶端，label底端，拉伸，水平总是居中。
* 把两个子视图，包一层View，不一定是StackVIew，也可以是普通View，内部搞好约束，top、left、bottom、right。再对中间层view做水平、垂直居中操作即可。

---

##### 84.猜想dequeueReusableCellWithIdentifier的实现是怎样的，给出示例代码。注意边界条件：相邻cell的identifier相等时。你的实现中该函数的时间复杂度是多少。为什么？

```

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
   for (UITableViewCell *cell in _reusableCells) {
       if ([cell.reuseIdentifier isEqualToString:identifier]) {
           UITableViewCell *strongCell = cell;
           
           // the above strongCell reference seems totally unnecessary, but without it ARC apparently
           // ends up releasing the cell when it's removed on this line even though we're referencing it
           // later in this method by way of the cell variable. I do not like this.
           [_reusableCells removeObject:cell];

           [strongCell prepareForReuse];
           return strongCell;
       }
   }
   
   return nil;
}

```

* 时间复杂度为： O(n)
* NSArray / NSMutableArray
* containsObject:，containsObject:，indexOfObject*，removeObject: 会遍历里面元素查看是否与之匹对，所以复杂度等于或大于 O(n)。
* 这里 _reusableCells 使用的是NSMutableSet，而
* NSSet / NSMutableSet / NSCountedSet
* 这些集合类型是无序没有重复元素。这样就可以通过 hash table 进行快速的操作。比如 addObject:, removeObject:, containsObject: 都是按照 O(1) 来的。需要注意的是将数组转成 Set 时会将重复元素合成一个，同时失去排序。
* 加之 for 循环，可以得到复杂度计算结果。

---

##### 83.【hybrid-app】js与native交互中，js如何调用native方法，native如何调js方法，借助的中间foundation叫什么。给出核心步骤对应函数，重点给出前端和native需要约定联调的部分。
* native 能直接调用 js
	* [webView stringByEvaluatingJavaScriptFromString:javascriptCommand];

* js 不能直接调用 native 的方法，但是可以间接的通过一些方法来实现。可以利用 UIWebView 的 webView: shouldStartLoadWithRequest: navigationType: 代理方法来做。 WKWebView 中可以通过 webView: decidePolicyForNavigationAction: decisionHandler:

* 要想触发native 的 webView: shouldStartLoadWithRequest: navigationType方法，可以通过下面两种形式：
	* 1.创建 iframe 标签
	* 2.设置 window 的 location

* 核心步骤：
	* 1.native 加载 html，其中的 script 标签里（也就是 js 代码）， js 创建 iframe 标签，并设置它的 src 属性为 wvjbscheme://BRIDGE_LOADED，并且把回掉放到一个数组里
	* 2.在 webView: shouldStartLoadWithRequest: navigationType 方法中拦截 wvjbscheme://BRIDGE_LOADED，并加载本地（桥中）的 js
	* 3.本地（桥） js 创建隐藏的 iframe 标签并且修改 src 为  wvjbscheme://WVJB_QUEUE_MESSAGE，这样就又能在 webView: shouldStartLoadWithRequest: navigationType 拦截了。

---

##### 82.《易传·系辞上传》：“易有太极，是生两仪，两仪生四象，四象生八卦。”，这句话结合下面的几张图，与计算机数据结构中的哪个概念更为相近，描述该概念，越详细越好。问题如下：
* 六十四卦所在结构中节点数是多少？节点数是 2ˆ7-1
* 六十四卦中的任意一卦，在上述数据结构体系中对应的概念叫什么？总体是二叉树
* 六十四卦中的任意一卦的高度与深度分别是多少？高度是 0 深度是7
* “完全” 与 “满” 用哪一个，形容下面的图片更为贴切？满二叉树

---

##### 81.在开发中，我们在重连等场景中，为避免造成过度的资源消耗，我们常常把重试的时间间隔做递增处理，有时是指数级增长方式，比如第1次与第二次时间间隔为2秒，第二次与第三次时间间隔为4秒，然后是8秒，我们有时也按照1，3，5这样的规律递增。这种编程技巧的名称是什么？
* 【答案】指数退避算法。

---

##### 80.如何给view同时加上圆角和阴影？至少给出两种实现方法，使用到的API越高级越好。
* 【提示】两种方法，答案提示：UIBezierPath，和iOS11 layer有个新的方法
* 【答案】iOS11的layer是maskedCorners，CACornerMask。

---

##### 79.如何用一行代码，互换两个变量的值，且不产生第三个变量。
* a = ( a + b ) - b * ( b = a );

---

##### 78.【iOS-autolayout】一个ScrollView上有3个UILabel，每个label字数不固定，类似字数很多的那种，要求上下依次排列，当文字超出ScrollView的时候可以滑动，左右不能滚动，上下可滚动。

* 【出题人提示】就是label的宽度设置跟scrollView等宽，最底下的label底部要跟scrollView的底部约束上就可以了。
* 考察的主要是scrollView的约束问题。scrollView的约束主要是从内部撑开宽度跟高度。
* 三个label 那个，就是放了个scrollview 然后里面放三个label，从上往下边距全部约束为0，然后label 宽度与scrollview相同，最下面那个label距离底部scrollview为0。(在内部无需多放view)
	* 1.在 Scrollview 添加⼀个 ContainView
	* 2.ContentView 完全覆盖 Scrollview
	* 3.ContainView 上添加了三个 Label。View 的 bottom 和 第三个 Label 的 bottom 做约束。
	* 4.三个 Label 互相做间距和宽的约束，不约束⾼
	* 5.通过将 Scrollview 的 ContentSize 和 ContainView 的 size 保持⼀致。

```
- (void)viewDidAppear:(BOOL)animated {
       [super viewDidAppear:animated];
       [self.contentView layoutIfNeeded];
        self.scrollview.contentSize =
       CGSizeMake(CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
}

```

---

##### 77.【iOS】iPhone在无耳机状态下，通过实体按键设置静音后，以下路径比如： 微信主tab-朋友圈-点开feed流中的小视频，可以播放声音。 通过点击头像-个人朋友圈主页，点开视频无法播放声音。即使按声音增加键也无法播放。请问这个表现不一致的现象，是feature还是bug，如果是bug你觉得是代码哪里写的有问题。写出修复代码。
* [答案]：视频播放器默认静音模式下是没有声音的，但可以控制即使是静音模式下依然有声音，显然前者设置了【mx：就是设置了在静音下也能播放声音】，后者没有设置。推测前者是被提交了bug所以fix掉了，后者使用场景比较少，所以没有被注意到。

```

//忽略静音按钮
 AVAudioSession *session =[AVAudioSession sharedInstance];
 [session setCategory:AVAudioSessionCategoryPlayback error:nil];
   
```

* 完整代码：

```

- (AVAudioPlayer *)player {
  if (!_player) {
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"xxxx.wav"
    withExtension:nil];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
    AVAudioSession *autioSession = [AVAudioSession sharedInstance];
    [autioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [autioSession setActive:YES error:nil];
    [_player prepareToPlay];
  }
}

```

* 耳机场景下，统一做了处理，都可以播放视频带声音。
* 比如以下代码用于判断耳机状态，因为AVAudioSession是单例，对耳机优先处理即可。

```

- (BOOL)isHeadsetPluggedIn {  
   AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];  
   for (AVAudioSessionPortDescription* desc in [route outputs]) {  
       if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])  
           return YES;  
   }  
   return NO;  
} 

```

---

##### 76.【iOS】小地是一名中级iOS开发，他最近学会了iOS黑魔法 - Method Swizzling ，他感觉黑魔法很方便，于是他大量使用了这个技巧，并默默分享给其他同事，想大家一起成长，一起用。大风哥是团队一名高级开发，听到后，告诫小地谨慎使用。如果你是大风哥，你会怎么去告诫他。

* 黑魔法例子1：用在埋点
	* 区别于⼿动为每⼀个类编写埋点⽅法或者写⼀个基类来做统⼀的埋点，前两者在某些场景下⼯ 作量都不算⼩。可以做⼀个 UIViewController 的 Category，置换原⽣⽅法，在置换⽅法中将写⼊埋点代码，这样可以直接⼀键埋点完成。之后新增的 UIViewController 类也不需要再关⼼这些的埋点代码。

```

- (void)cyl_APOViewDidLoad {
  Class class = [self class];
  if (!([class isEqual:[UIViewController class]] || [class isEqual: [UINavigationController class]])) {
    NSLog(@"统计该⻚⾯ %@", class);
  }
}

```

* 黑魔法例子2：防止crash
	* 置换 NSDictionary 的 -setObject:forKey: 方法，用于防止 crash。 NSArray 同理。

```

- (void)cyl_safeSetObject:(id)object forKey:(id<NSCopying>)key {
  if (object && key) {
    [self safe_setObject:object forKey:key];
  }
}

```

* 黑魔法缺点
	* Method swizzling is not atomic
	* Changes behavior of un-owned code
	* Possible naming conflicts
	* Swizzling changes the method's arguments
	* The order of swizzles matters
	* Difficult to understand (looks recursive)
	* Difficult to debug
	* 其没有类似注解的东⻄，⽅法置换没有有效声明。如果滥⽤，反⽽会增加维护成本。若擅⾃使⽤未同步其他同学，会成为极⼤的项⽬隐患。尤其是⼀些封装的模块。

---

* 黑魔法错误用法1：多次hook了同一个类的同一个方法
	* 跟分类重名的表现是一样：表现为无法控制执行的先后顺序，与编译器build的顺序有关，但编译器顺序有不可控性。
	* 比如下面的实现方法，可能出现方法覆盖的问题：

```

+ (void)load {
  static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
  	Class class = [self class];
  	SEL originalSelector = @selector(viewDidLoad); SEL swizzledSelector = @selector(XK_ViewDidLoad);
  	Method originalMethod = class_getInstanceMethod(class, originalSelector);
  	Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
  	BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod),
  method_getTypeEncoding(swizzledMethod));
  	if (didAddMethod) {
  		class_replaceMethod(class, swizzledSelector, 		method_getImplementation(originalMethod),
  method_getTypeEncoding(originalMethod));
  	} else {
  		method_exchangeImplementations(originalMethod, swizzledMethod);
  	}
  });
}

```

---

* 黑魔法错误用法2：Hook了具有继承关系的相同方法

* 以下场景：
	* 如果子类并没有重写父类的方法，拿父类的implement去swizzling本来就是错误的行为。
	* A<—继承---B<—继承---C （B是A的子类，C又是B的子类）
* A 里有 test 方法，但是 B 和 C 都没有重写。
* 通常如果要对 B 或者 C 的 test 进行hook的话，很多开发者都喜欢去给 B 或者 C add A.test 的 implemention。
* 那如果先hook的C，又hook的B，似乎就形成了C与A直接打交道的局面。但是以面向对象来说，C的原实现应该是B的当前实现才合理。
* 所以不应该hook当前类没有重写的方法，这种其实直接继承(或者加category方法)就可以做了，不需要hook，需要调用原实现直接[super test]即可。

---

##### 75.小地是一名base北京的iOS程序员，他有一次要出差深圳，但想找几个能在深圳可以一起吃早餐的朋友。但他的iPhone没有越狱，于是他在北京打开Xcode修改了系统定位到深圳，成功在探探、微信、陌陌上分别找到了可以共度早餐的人。但由于连续看了三天的妇联首映，加之几夜没睡也没吃早餐，他早晨在酒店无法下床，他想故技重施，打开公司打卡软件修改位置打卡。但发现无法修改。只好请假下午去，扣了半天工资。请问：小地他怎么改的位置，为什么公司打卡软件改不了，是怎么做的？
* 【答案】使用gpx文件, Xcode 虚拟定位可修改模拟器以及真机的系统的定位。即使是从App Store下载的探探、微信、陌陌只要使用系统接口获取定位信息，就可以通过gpx模拟定位。
* 1.Xcode 中新建一个项目, 创建一个 .gpx 文件
* 2.高德获取经纬度，链接 https://lbs.amap.com/console/show/picker ， iOS 端采用的定位坐标系是 WGS-84 , 而获得的定位一般是火星坐标 GCJ-02，把 获得的坐标转化为原始坐标：WGS-84或者直接用 Google 地图获取坐标，就不需要坐标系转换了。还有一个 gpx 文件生成网站：https://www.gpxgenerator.com/ 可以直接选择坐标，然后导出 gpx 文件。
* 3.修改代码 把 Location.gpx 文件里的代码 改为 要定位的经纬度
* 4.点击 Debug--->Simulate Location --> Location 然后运行（Location 这个是新创建 gpx 的文件名）
* 钉钉也可以修改定位打卡，如果钉钉设置 Wi-Fi 打卡，公司只配置校验了 SSID，没有校验 DHCP 地址。把家里的 Wi-Fi 名称改得和公司打卡的 Wi-Fi 即可。
* 如果有一些打卡软件不能修改，那可能是因为未使用系统定位方法，或者未仅仅使用该方法作为定位依据。具体使用何种方法，可在另行讨论。但已知 iOS 定位方法有：GPS定位、基站蜂窝定位、Wi-Fi定位等多种定位方法，
* 精准度优先级可以为：
	* 首选是 GPS，
	* 然后是 GPRS（IP 和 routetrace ），蜂窝网络进行 routetrace 可以获取到第一个接入点
	* 然后是 Wi-Fi（IP 和 routetrace 和附近的 Wi-Fi 名），SSID 名的优先级比较低，主要是靠routetrace
	* 然后是附近的蓝牙设备
* 如果结合以上多种定位方法，这四个方案是同时的，组合起来命中率就很高了，取合理的定位结果交集进行反作弊也是一种思路。
* 但是在iOS13中对 Wi-Fi 定位权限进行了收紧，需要用户进行额外授权，相关的上下文可以参考下面的链接：OS13AdaptationTips-Network
* 另外，做灰产的，有一种外设，基于苹果 MFi 认证，配合配套软件直接提供修改后的坐标，Apple 的这一类产品，最初是给那些没有 GPS 模块的iPad、iPod做定位的功能弥补，让这些用户也能使用定位。但这类产品修改的也是系统定位，进而也可以间接做打卡用图。不过是需要实体的装置。这个就不在讨论范围了。

##### 74.lldb（gdb）常用的调试命令？
* breakpoint 设置断点定位到某一个函数
* n 断点指针下一步
* po打印对象

---

##### 73.如何调试BAD_ACCESS错误
* 重写object的respondsToSelector方法，现实出现EXEC_BAD_ACCESS前访问的最后一个object
* 通过 Zombie
* 设置全局断点快速定位问题代码所在行
* Xcode 7 已经集成了BAD_ACCESS捕获功能：Address Sanitizer。 用法如下：在配置中勾选✅Enable Address Sanitizer

---

##### 72.IB中User Defined Runtime Attributes如何使用？
* 它能够通过KVC的方式配置一些你在interface builder 中不能配置的属性。当你希望在IB中作尽可能多得事情，这个特性能够帮助你编写更加轻量级的viewcontroller
* [在xcode中的位置](https://raw.githubusercontent.com/codeRiding/github_pic_0001/master/Xnip2020-02-13_16-34-30.jpg?token=AHD65X3RDFLPF4UKAHSFJDS6IUFGI)

---

##### 71.IBOutlet连出来的视图属性为什么可以被设置成weak?

* 因为既然有外链那么视图在xib或者storyboard中肯定存在，视图已经对它有一个强引用了。
* 使用storyboard（xib不行）创建的vc，会有一个叫_topLevelObjectsToKeepAliveFromStoryboard的私有数组强引用所有top level的对象，所以这时即便outlet声明成weak也没关系
* 【mx：从vc中拖出的outlet是weak，那从xib拖出的oulet呢？mx补充：从xib中拖出来的outlet也是weak的】

---

##### 70.apple用什么方式实现对一个对象的KVO？
* Apple 使用了 isa 混写（isa-swizzling）来实现 KVO 。

---

##### 69.如何关闭默认的KVO的默认实现，并进入自定义的KVO实现？
* 请参考：《如何手动触发一个value的KVO》

---

##### 68.KVC和KVO的keyPath一定是属性么？
* KVC 支持实例变量，KVO 只能手动支持手动设定实例变量的KVO实现监听

---

##### 67.KVC的keyPath中的集合运算符如何使用？
* 必须用在集合对象上或普通对象的集合属性上
* 简单集合运算符有@avg， @count ， @max ， @min ，@sum，
* 格式 @"@sum.age"或 @"集合属性.@max.age"

---

##### 66.若一个类有实例变量 NSString *_foo ，调用setValue:forKey:时，可以以foo还是 _foo 作为key？

* 都可以。

---

##### 65.如何手动触发一个value的KVO
* [MX :就是在修改属性值的前后加入willChangeValueForKey和didChangeValueForKey]
* 所谓的“手动触发”是区别于“自动触发”：
* 自动触发是指类似这种场景：在注册 KVO 之前设置一个初始值，注册之后，设置一个不一样的值，就可以触发了。
* 想知道如何手动触发，必须知道自动触发 KVO 的原理：
* 键值观察通知依赖于 NSObject 的两个方法: willChangeValueForKey: 和 didChangevlueForKey: 。在一个被观察属性发生改变之前， willChangeValueForKey: 一定会被调用，这就 会记录旧的值。而当改变发生后， observeValueForKey:ofObject:change:context: 会被调用，继而 didChangeValueForKey: 也会被调用。如果可以手动实现这些调用，就可以实现“手动触发”了。
* 那么“手动触发”的使用场景是什么？一般我们只在希望能控制“回调的调用时机”时才会这么做。
* 具体做法如下：
* 如果这个 value 是 表示时间的 self.now ，那么代码如下：最后两行代码缺一不可。

```

@property (nonatomic, strong) NSDate *now;

- (void)viewDidLoad {
   [super viewDidLoad];
   
   _now = [NSDate date];
   
   [self addObserver:self forKeyPath:@"now" options:NSKeyValueObservingOptionNew context:nil];
   NSLog(@"1");
   [self willChangeValueForKey:@"now"]; // “手动触发self.now的KVO”，必写。
   NSLog(@"2");
   [self didChangeValueForKey:@"now"]; // “手动触发self.now的KVO”，必写。
   NSLog(@"4");
}

```

* 但是平时我们一般不会这么干，我们都是等系统去“自动触发”。“自动触发”的实现原理：
* 比如调用 setNow: 时，系统还会以某种方式在中间插入 wilChangeValueForKey: 、 didChangeValueForKey: 和 observeValueForKeyPath:ofObject:change:context: 的调用。
* 大家可能以为这是因为 setNow: 是合成方法，有时候我们也能看到有人这么写代码:

```

- (void)setNow:(NSDate *)aDate {
   [self willChangeValueForKey:@"now"]; // 没有必要
   _now = aDate;
   [self didChangeValueForKey:@"now"];// 没有必要
}

```

* 这完全没有必要，不要这么做，这样的话，KVO代码会被调用两次。KVO在调用存取方法之前总是调用 willChangeValueForKey: ，之后总是调用 didChangeValueForkey: 。

---

##### 64.addObserver:forKeyPath:options:context:各个参数的作用分别是什么，observer中需要实现哪个方法才能获得KVO回调？

```

// 添加键值观察
/*
1 观察者，负责处理监听事件的对象
2 观察的属性
3 观察的选项
4 上下文
*/
[self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Person Name"];

```

* observer中需要实现一下方法：

```

// 所有的 kvo 监听到事件，都会调用此方法
/*
 1. 观察的属性
 2. 观察的对象
 3. change 属性变化字典（新／旧）
 4. 上下文，与监听的时候传递的一致
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

```

---

##### 63.苹果为什么要废弃dispatch_get_current_queue？
* dispatch_get_current_queue函数的行为常常与开发者所预期的不同。 由于派发队列是按层级来组织的，这意味着排在某条队列中的块会在其上级队列里执行。 队列间的层级关系会导致检查当前队列是否为执行同步派发所用的队列这种方法并不总是奏效。dispatch_get_current_queue函数通常会被用于解决由不可以重入的代码所引发的死锁，然后能用此函数解决的问题，通常也可以用"队列特定数据"来解决。

---

##### 62.dispatch_barrier_async的作用是什么？
* 在并行队列中，为了保持某些任务的顺序，需要等待一些任务完成后才能继续进行，使用 barrier 来等待之前任务完成，避免数据竞争等问题。 dispatch_barrier_async 函数会等待追加到Concurrent Dispatch Queue并行队列中的操作全部执行完之后，然后再执行 dispatch_barrier_async 函数追加的处理，等 dispatch_barrier_async 追加的处理执行结束之后，Concurrent Dispatch Queue才恢复之前的动作继续执行。
* 打个比方：比如你们公司周末跟团旅游，高速休息站上，司机说：大家都去上厕所，速战速决，上完厕所就上高速。超大的公共厕所，大家同时去，程序猿很快就结束了，但程序媛就可能会慢一些，即使你第一个回来，司机也不会出发，司机要等待所有人都回来后，才能出发。 dispatch_barrier_async 函数追加的内容就如同 “上完厕所就上高速”这个动作。
* （注意：使用 dispatch_barrier_async ，该函数只能搭配自定义并行队列 dispatch_queue_t 使用。不能使用： dispatch_get_global_queue ，否则 dispatch_barrier_async 的作用会和 dispatch_async 的作用一模一样。 ）

---

##### 61.如何用GCD同步若干个异步调用？（如根据若干个url异步加载多张图片，然后在都下载完成后合成一张整图）
* 使用Dispatch Group追加block到Global Group Queue,这些block如果全部执行完毕，就会执行Main Dispatch Queue中的结束处理的block。

```

dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, queue, ^{ /*加载图片1 */ });
dispatch_group_async(group, queue, ^{ /*加载图片2 */ });
dispatch_group_async(group, queue, ^{ /*加载图片3 */ }); 
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 合并图片
});

```

---

##### 60.GCD的队列（dispatch_queue_t）分哪两种类型？
* 串行队列Serial Dispatch Queue
* 并行队列Concurrent Dispatch Queue

---

##### 59.使用系统的某些block api（如UIView的block版本写动画时），是否也考虑引用循环问题？
* 系统的某些block api中，UIView的block版本写动画时不需要考虑，但也有一些api 需要考虑：
* 所谓“引用循环”是指双向的强引用，所以那些“单向的强引用”（block 强引用 self ）没有问题，比如这些：

```

[UIView animateWithDuration:duration animations:^{ [self.superview layoutIfNeeded]; }]; 

[[NSOperationQueue mainQueue] addOperationWithBlock:^{ self.someProperty = xyz; }]; 

[[NSNotificationCenter defaultCenter] addObserverForName:@"someNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification notification) 
{
   self.someProperty = xyz; 
}];
                                                   
```

* 但如果你使用一些参数中可能含有 ivar 的系统 api ，如 GCD 、NSNotificationCenter就要小心一点：比如GCD 内部如果引用了 self，而且 GCD 的其他参数是 ivar，则要考虑到循环引用：

```

__weak __typeof__(self) weakSelf = self;
dispatch_group_async(_operationsGroup, _operationsQueue, ^
{
	__typeof__(self) strongSelf = weakSelf;
	[strongSelf doSomething];
	[strongSelf doSomethingElse];
} );


__weak __typeof__(self) weakSelf = self;
 _observer = [[NSNotificationCenter defaultCenter]  addObserverForName:@"testKey" object:nil queue:nil usingBlock:^(NSNotification *note) 
 {
     __typeof__(self) strongSelf = weakSelf;
     [strongSelf dismissModalViewControllerAnimated:YES];
 }];

```

---

##### 58.在block内如何修改block外部变量？
* 默认情况下，在block中访问的外部变量是复制过去的，即：写操作不对原变量生效。但是你可以加上 __block 来让其写操作生效

```

__block int a = 0;
   void (^foo)(void) = ^{ 
       a = 1; 
   };
   foo(); 
   //这里，a的值被修改为1
   
```

* 真正的原因是这样的：
* 我们都知道：Block不允许修改外部变量的值，这里所说的外部变量的值，指的是栈中指针的内存地址。__block 所起到的作用就是只要观察到该变量被 block 所持有，就将“外部变量”在栈中的内存地址放到了堆中。进而在block内部也可以修改外部变量的值。

* Block不允许修改外部变量的值。Apple这样设计，应该是考虑到了block的特殊性，block也属于“函数”的范畴，变量进入block，实际就是已经改变了作用域。在几个作用域之间进行切换时，如果不加上这样的限制，变量的可维护性将大大降低。又比如我想在block内声明了一个与外部同名的变量，此时是允许呢还是不允许呢？只有加上了这样的限制，这样的情景才能实现。于是栈区变成了红灯区，堆区变成了绿灯区。

* 我们可以打印下内存地址来进行验证：

```

__block int a = 0;
NSLog(@"定义前：%p", &a);         //栈区
void (^foo)(void) = ^{
   a = 1;
   NSLog(@"block内部：%p", &a);    //堆区
};
NSLog(@"定义后：%p", &a);         //堆区
foo();
   
2016-05-17 02:03:33.559 LeanCloudChatKit-iOS[1505:713679] 定义前：0x16fda86f8
2016-05-17 02:03:33.559 LeanCloudChatKit-iOS[1505:713679] 定义后：0x155b22fc8
2016-05-17 02:03:33.559 LeanCloudChatKit-iOS[1505:713679] block内部： 0x155b22fc8

```

* “定义后”和“block内部”两者的内存地址是一样的，我们都知道 block 内部的变量会被 copy 到堆区，“block内部”打印的是堆地址，因而也就可以知道，“定义后”打印的也是堆的地址。
* 那么如何证明“block内部”打印的是堆地址？
* 把三个16进制的内存地址转成10进制就是：
	* 定义后前：6171559672
	* block内部：5732708296
	* 定义后后：5732708296
* 中间相差438851376个字节，也就是 418.5M 的空间，因为堆地址要小于栈地址，又因为iOS中一个进程的栈区内存只有1M，Mac也只有8M，显然a已经是在堆区了。
* 这也证实了：a 在定义前是栈区，但只要进入了 block 区域，就变成了堆区。这才是 __block 关键字的真正作用。
* __block 关键字修饰后，int类型也从4字节变成了32字节，这是 Foundation 框架 malloc 出来的。这也同样能证实上面的结论。（PS：居然比 NSObject alloc 出来的 16 字节要多一倍）。

---

##### 57.使用block时什么情况会发生引用循环，如何解决？
* 一个对象中强引用了block，在block中又强引用了该对象，就会发生循环引用。

* 解决方法是将该对象使用__weak或者__block修饰符修饰之后再在block中使用。
	* id weak weakSelf = self; 或者 weak __typeof(&*self)weakSelf = self该方法可以设置宏
	* id __block weakSelf = self;
* 或者将其中一方强制制空 xxx = nil。

---

##### 56.苹果是如何实现autoreleasepool的？
* autoreleasepool 以一个队列数组的形式实现,主要通过下列三个函数完成.
	* objc_autoreleasepoolPush
	* objc_autoreleasepoolPop
	* objc_autorelease
* 看函数名就可以知道，对 autorelease 分别执行 push，和 pop 操作。销毁对象时执行release操作。

---

##### 55.BAD_ACCESS在什么情况下出现？
* 访问了悬垂指针，比如对一个已经释放的对象执行了release、访问已经释放对象的成员变量或者发消息。 死循环

---

##### 54.不手动指定autoreleasepool的前提下，一个autorealese对象在什么时刻释放？（比如在一个vc的viewDidLoad中创建）
* 分两种情况：手动干预释放时机、系统自动去释放。
	* 手动干预释放时机--指定autoreleasepool 就是所谓的：当前作用域大括号结束时释放。
	* 系统自动去释放--不手动指定autoreleasepool
* Autorelease对象出了作用域之后，会被添加到最近一次创建的自动释放池中，并会在当前的 runloop 迭代结束时释放。

---

##### 53.ARC通过什么方式帮助开发者管理内存？
* ARC相对于MRC，不是在编译时添加retain/release/autorelease这么简单。应该是编译期和运行期两部分共同帮助开发者管理内存。
* 在编译期，ARC用的是更底层的C接口实现的retain/release/autorelease，这样做性能更好，也是为什么不能在ARC环境下手动retain/release/autorelease，同时对同一上下文的同一对象的成对retain/release操作进行优化（即忽略掉不必要的操作）；ARC也包含运行期组件，这个地方做的优化比较复杂，但也不能被忽略。

---

##### 52.objc使用什么机制管理对象内存

* 通过 retainCount 的机制来决定对象是否需要释放。 每次 runloop 的时候，都会检查对象的 retainCount，如果retainCount 为 0，说明该对象没有地方需要继续使用了，可以释放掉了。

---

##### 51.猜想runloop内部是如何实现的？
* 一个线程一次只能执行一个任务，执行完成后线程就会退出。如果我们需要一个机制，让线程能随时处理事件但并不退出

用伪代码来展示下:

```

int main(int argc, char * argv[]) {
 //程序一直运行状态
 while (AppIsRunning) {
      //睡眠状态，等待唤醒事件
      id whoWakesMe = SleepForWakingUp();
      //得到唤醒事件
      id event = GetEvent(whoWakesMe);
      //开始处理事件
      HandleEvent(event);
 }
 return 0;
}

```

---

##### 50.以+ scheduledTimerWithTimeInterval...的方式触发的timer，在滑动页面上的列表时，timer会暂定回调，为什么？如何解决？
* [MX: 一个runloop下，只允许一种mode工作，timer和滑动需要在两种不同的mode下才能工作，所以timer时间源和滑动事件源需要切换mode，切换mode势必导致另一种源无法工作，这里的源，可以是消息，可以是时间，可以是用户触发的事件，就是要程序做的事，解决的办法就是通过一种mode，两种源同时可以工作，那就是NSRunLoopCommonModes，这种mode就可以满足两种源同时工作]
* RunLoop只能运行在一种mode下，如果要换mode，当前的loop也需要停下重启成新的。利用这个机制，ScrollView滚动过程中NSDefaultRunLoopMode（kCFRunLoopDefaultMode）的mode会切换到UITrackingRunLoopMode来保证ScrollView的流畅滑动：只能在NSDefaultRunLoopMode模式下处理的事件会影响ScrollView的滑动。
* 如果我们把一个NSTimer对象以NSDefaultRunLoopMode（kCFRunLoopDefaultMode）添加到主运行循环中的时候, ScrollView滚动过程中会因为mode的切换，而导致NSTimer将不再被调度。
* 同时因为mode还是可定制的，所以：
* Timer计时会被scrollView的滑动影响的问题可以通过将timer添加到NSRunLoopCommonModes（kCFRunLoopCommonModes）来解决。代码如下：

```

//将timer添加到NSDefaultRunLoopMode中
[NSTimer scheduledTimerWithTimeInterval:1.0
     target:self
     selector:@selector(timerTick:)
     userInfo:nil
     repeats:YES];
//然后再添加到NSRunLoopCommonModes里
NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
     target:self
     selector:@selector(timerTick:)
     userInfo:nil
     repeats:YES];
[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

```

---

##### 49.runloop的mode作用是什么？
* model 主要是用来指定事件在运行循环中的优先级的，分为：
	* NSDefaultRunLoopMode（kCFRunLoopDefaultMode）：默认，空闲状态
	* UITrackingRunLoopMode：ScrollView滑动时
	* UIInitializationRunLoopMode：启动时
	* NSRunLoopCommonModes（kCFRunLoopCommonModes）：Mode集合

* 苹果公开提供的 Mode 有两个：
	* NSDefaultRunLoopMode（kCFRunLoopDefaultMode）
	* NSRunLoopCommonModes（kCFRunLoopCommonModes）

---

##### 48.runloop和线程有什么关系？
* 总的说来，runloop，正如其名，loop表示某种循环，和run放在一起就表示一直在运行着的循环。实际上，runloop和线程是紧密相连的，可以这样说runloop是为了线程而生，没有线程，它就没有存在的必要。runloop是线程的基础架构部分， Cocoa 和 CoreFundation 都提供了 runloop 对象方便配置和管理线程的 runloop （以下都以 Cocoa 为例）。每个线程，包括程序的主线程（ main thread ）都有与之相应的 runloop 对象。
* runloop 和线程的关系：
	* 主线程的runloop默认是启动的。
	* iOS的应用程序里面，程序启动后会有一个如下的main()函数
	* 重点是UIApplicationMain()函数，这个方法会为main thread设置一个NSRunLoop对象，这就解释了：为什么我们的应用可以在无人操作的时候休息，需要让它干活的时候又能立马响应。

```

int main(int argc, char * argv[]) {
   @autoreleasepool {
       return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
   }
}

```

	* 对其它线程来说，runloop默认是没有启动的，如果你需要更多的线程交互则可以手动配置和启动，如果线程只是去执行一个长时间的已确定的任务则不需要。
	* 在任何一个 Cocoa 程序的线程中，都可以通过以下代码来获取到当前线程的 runloop 。
	* NSRunLoop *runloop = [NSRunLoop currentRunLoop];

---

##### 47.能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？
* 不能向编译后得到的类中增加实例变量；
* 能向运行时创建的类中添加实例变量；
* 解释下：
	* 因为编译后的类已经注册在 runtime 中，类结构体中的 objc_ivar_list 实例变量的链表 和 instance_size 实例变量的内存大小已经确定，同时runtime 会调用 class_setIvarLayout 或 class_setWeakIvarLayout 来处理 strong weak 引用。所以不能向存在的类中添加实例变量；
	* 运行时创建的类是可以添加实例变量，调用 class_addIvar 函数。但是得在调用 objc_allocateClassPair 之后，objc_registerClassPair 之前，原因同上。

---

##### 46._objc_msgForward函数是做什么的，直接调用它将会发生什么？
* _objc_msgForward是 IMP 类型，用于消息转发的：当向一个对象发送一条消息，当它并没有实现的时候，_objc_msgForward会尝试做消息转发。

* 排除掉 NSObject 做的事，剩下的就是_objc_msgForward消息转发做的几件事：
	* 调用resolveInstanceMethod:方法 (或 resolveClassMethod:)。允许用户在此时为该 Class 动态添加实现。如果有实现了，则调用并返回YES，那么重新开始objc_msgSend流程。这一次对象会响应这个选择器，一般是因为它已经调用过class_addMethod。如果仍没实现，继续下面的动作。
	* 调用forwardingTargetForSelector:方法，尝试找到一个能响应该消息的对象。如果获取到，则直接把消息转发给它，返回非 nil 对象。否则返回 nil ，继续下面的动作。注意，这里不要返回 self ，否则会形成死循环。
	* 调用methodSignatureForSelector:方法，尝试获得一个方法签名。如果获取不到，则直接调用doesNotRecognizeSelector抛出异常。如果能获取，则返回非nil：创建一个 NSlnvocation 并传给forwardInvocation:。
	* 调用forwardInvocation:方法，将第3步获取到的方法签名包装成 Invocation 传入，如何处理就在这里面了，并返回非nil。
	* 调用doesNotRecognizeSelector: ，默认的实现是抛出异常。如果第3步没能获得一个方法签名，执行该步骤。
* 上面前4个方法均是模板方法，开发者可以override，由 runtime 来调用。最常见的实现消息转发：就是重写方法3和4，吞掉一个消息或者代理给其他对象都是没问题的
* 也就是说_objc_msgForward在进行消息转发的过程中会涉及以下这几个方法：
	* resolveInstanceMethod:方法 (或 resolveClassMethod:)。
	* forwardingTargetForSelector:方法
	* methodSignatureForSelector:方法
	* forwardInvocation:方法
	* doesNotRecognizeSelector: 方法

* 第二个问题
* 一旦调用_objc_msgForward，将跳过查找 IMP 的过程，直接触发“消息转发”，
* 如果调用了_objc_msgForward，即使这个对象确实已经实现了这个方法，你也会告诉objc_msgSend：

“我没有在这个对象里找到这个方法的实现”

---

##### 45.objc中的类方法和实例方法有什么本质区别和联系？
* 类方法：
	* 类方法是属于类对象的
	* 类方法只能通过类对象调用
	* 类方法中的self是类对象
	* 类方法可以调用其他的类方法
	* 类方法中不能访问成员变量
	* 类方法中不能直接调用对象方法

* 实例方法：
	* 实例方法是属于实例对象的
	* 实例方法只能通过实例对象调用
	* 实例方法中的self是实例对象
	* 实例方法中可以访问成员变量
	* 实例方法中直接调用实例方法
	* 实例方法中也可以调用类方法(通过类名)

---

##### 44.使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？
* 在ARC下不需要。
* 在MRC下也不需要
对象的内存销毁时间表，分四个步骤：

```
// 对象的内存销毁时间表
// 根据 WWDC 2011, Session 322 (36分22秒)中发布的内存销毁时间表 

 1. 调用 -release ：引用计数变为零
     * 对象正在被销毁，生命周期即将结束.
     * 不能再有新的 __weak 弱引用， 否则将指向 nil.
     * 调用 [self dealloc] 
 2. 子类 调用 -dealloc
     * 继承关系中最底层的子类 在调用 -dealloc
     * 如果是 MRC 代码 则会手动释放实例变量们（iVars）
     * 继承关系中每一层的父类 都在调用 -dealloc
 3. NSObject 调 -dealloc
     * 只做一件事：调用 Objective-C runtime 中的 object_dispose() 方法
 4. 调用 object_dispose()
     * 为 C++ 的实例变量们（iVars）调用 destructors 
     * 为 ARC 状态下的 实例变量们（iVars） 调用 -release 
     * 解除所有使用 runtime Associate方法关联的对象
     * 解除所有 __weak 引用
     * 调用 free()
```

---

##### 43.runtime如何通过selector找到对应的IMP地址？（分别考虑类方法和实例方法）
* 每一个类对象中都有一个方法列表,方法列表中记录着方法的名称,方法实现,以及参数类型；
* 其实selector本质就是方法名称,通过这个方法名称就可以在方法列表中找到对应的方法实现.
* SEL : 类成员方法的指针，但不同于C语言中的函数指针，函数指针直接保存了方法的地址，但SEL只是方法编号。
* IMP:一个函数指针,保存了方法的地址

---

##### 42.一个objc对象的isa的指针指向什么？有什么作用？
* 指向他的类对象,从而可以找到对象上的方法

---

##### 41.一个objc对象如何进行内存布局？（考虑有父类的情况）
* 所有父类的成员变量和自己的成员变量都会存放在该对象所对应的存储空间中.
* 每一个对象内部都有一个isa指针,指向他的类对象,类对象中存放着本对象的
	* 对象方法列表（对象能够接收的消息列表，保存在它所对应的类对象中）
	* 成员变量的列表,
	* 属性列表,
* 它内部也有一个isa指针指向元对象(meta class),元对象内部存放的是类方法列表,类对象内部还有一个superclass的指针,指向他的父类对象。

---

##### 40.什么时候会报unrecognized selector的异常？
* 当调用该对象上某个方法,而该对象上没有实现这个方法的时候， 可以通过“消息转发”进行解决。
* objc是动态语言，每个方法在运行时会被动态转为消息发送，即：objc_msgSend(receiver, selector)。
* objc在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类，然后在该类中的方法列表以及其父类方法列表中寻找方法运行，如果，在最顶层的父类中依然找不到相应的方法时，程序在运行时会挂掉并抛出异常unrecognized selector sent to XXX 。但是在这之前，objc的运行时会给出三次拯救程序崩溃的机会：

* Method resolution
	* objc运行时会调用+resolveInstanceMethod:或者 +resolveClassMethod:，让你有机会提供一个函数实现。如果你添加了函数，那运行时系统就会重新启动一次消息发送的过程，否则 ，运行时就会移到下一步，消息转发（Message Forwarding）。
* Fast forwarding
	* 如果目标对象实现了-forwardingTargetForSelector:，Runtime 这时就会调用这个方法，给你把这个消息转发给其他对象的机会。 只要这个方法返回的不是nil和self，整个消息发送的过程就会被重启，当然发送的对象会变成你返回的那个对象。否则，就会继续Normal Fowarding。 这里叫Fast，只是为了区别下一步的转发机制。因为这一步不会创建任何新的对象，但下一步转发会创建一个NSInvocation对象，所以相对更快点。 
* Normal forwarding
	* 这一步是Runtime最后一次给你挽救的机会。首先它会发送-methodSignatureForSelector:消息获得函数的参数和返回值类型。如果-methodSignatureForSelector:返回nil，Runtime则会发出-doesNotRecognizeSelector:消息，程序这时也就挂掉了。如果返回了一个函数签名，Runtime就会创建一个NSInvocation对象并发送-forwardInvocation:消息给目标对象。

---

##### 39.objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？
* 该方法编译之后就是objc_msgSend()函数调用.
* [obj foo];在objc编译时，会被转意为：objc_msgSend(obj, @selector(foo));。

---

##### 38.objc中向一个nil对象发送消息将会发生什么？
* 在 Objective-C 中向 nil 发送消息是完全有效的——只是在运行时不会有任何作用:
* 如果一个方法返回值是一个对象，那么发送给nil的消息将返回0(nil)。例如：

```

Person * motherInlaw = [[aPerson spouse] mother];

```

* 如果 spouse 对象为 nil，那么发送给 nil 的消息 mother 也将返回 nil。 2. 如果方法返回值为指针类型，其指针大小为小于或者等于sizeof(void*)，float，double，long double 或者 long long 的整型标量，发送给 nil 的消息将返回0。 2. 如果方法返回值为结构体,发送给 nil 的消息将返回0。结构体中各个字段的值将都是0。 2. 如果方法的返回值不是上述提到的几种情况，那么发送给 nil 的消息的返回值将是未定义的。
* objc是动态语言，每个方法在运行时会被动态转为消息发送，即：objc_msgSend(receiver, selector)。
* objc在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类，然后在该类中的方法列表以及其父类方法列表中寻找方法运行，然后在发送消息的时候，objc_msgSend方法不会返回值，所谓的返回内容都是具体调用时执行的。 那么，回到本题，如果向一个nil对象发送消息，首先在寻找对象的isa指针时就是0地址返回了，所以不会出现任何错误。

---

##### 37.在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景？
* 可以在类的实现代码里通过 @synthesize 语法来指定实例变量的名字

```

@implementation CYLPerson 
@synthesize firstName = _myFirstName; 
@synthesize lastName = _myLastName; 
@end 

```

---

##### 36.@synthesize合成实例变量的规则是什么？假如property名为foo，存在一个名为_foo的实例变量，那么还会自动合成新变量么？
* 实例变量 = 成员变量 ＝ ivar
* 如果指定了成员变量的名称,会生成一个指定的名称的成员变量,
* 如果这个成员已经存在了就不再生成了.
* 如果是 @synthesize foo; 还会生成一个名称为foo的成员变量，也就是说：
* 如果没有指定成员变量的名称会自动生成一个属性同名的成员变量,
* 如果是 @synthesize foo = _foo; 就不会生成成员变量了.
* 假如 property 名为 foo，存在一个名为 _foo 的实例变量，那么还会自动合成新变量么？ 不会。

---

##### 35.用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题？
* 因为父类指针可以指向子类对象,使用 copy 的目的是为了让本对象的属性不受外界影响,使用 copy 无论给我传入是一个可变对象还是不可对象,我本身持有的就是一个不可变的副本.
* 如果我们使用是 strong ,那么这个属性就有可能指向一个可变对象,如果这个可变对象在外部被修改了,那么会影响该属性.
* 集合对象的内容复制仅限于对象本身，对象元素仍然是指针复制。

---

##### 34.ARC下，不显式指定任何属性关键字时，默认的关键字都有哪些？
* 对应基本数据类型默认关键字是：atomic,readwrite,assign 
* 对于普通的 Objective-C 对象：atomic,readwrite,strong

---

##### 33.@synthesize和@dynamic分别有什么作用？
* @property有两个对应的词，一个是 @synthesize，一个是 @dynamic。如果 @synthesize和 * @dynamic都没写，那么默认的就是@syntheszie var = _var;
* @synthesize 的语义是如果你没有手动实现 setter 方法和 getter 方法，那么编译器会自动为你加上这两个方法。
* @dynamic 告诉编译器：属性的 setter 与 getter 方法由用户自己实现，不自动生成。（当然对于 readonly 的属性只需提供 getter 即可）。假如一个属性被声明为 @dynamic var，然后你没有提供 @setter方法和 @getter 方法，编译的时候没问题，但是当程序运行到 instance.var = someVar，由于缺 setter 方法会导致程序崩溃；或者当运行到 someVar = var 时，由于缺 getter 方法同样会导致崩溃。编译时没问题，运行时才执行相应的方法，这就是所谓的动态绑定。

---

##### 32.weak属性需要在dealloc中置nil么？
* 不需要。
* 在ARC环境无论是强指针还是弱指针都无需在 dealloc 设置为 nil ， ARC 会自动帮我们处理

---

##### 31.@property中有哪些属性关键字？/ @property 后面可以有哪些修饰符？
* 属性可以拥有的特质分为四类:
	* 原子性--- nonatomic 特质
	* 在默认情况下，由编译器合成的方法会通过锁定机制确保其原子性(atomicity)。如果属性具备 nonatomic 特质，则不使用自旋锁。请注意，尽管没有名为“atomic”的特质(如果某属性不具备 nonatomic 特质，那它就是“原子的” ( atomic) )，但是仍然可以在属性特质中写明这一点，编译器不会报错。若是自己定义存取方法，那么就应该遵从与属性特质相符的原子性。
	* 读/写权限---readwrite(读写)、readonly (只读)
	* 内存管理语义---assign、strong、 weak、unsafe_unretained、copy
	* 方法名---getter=<name> 、setter=<name>
	*   不常用的：nonnull,null_resettable,nullable

---

##### 30.runtime 如何实现 weak 属性

* runtime 对注册的类， 会进行布局，对于 weak 对象会放入一个 hash 表中。 用 weak 指向的对象内存地址作为 key，当此对象的引用计数为0的时候会 dealloc，假如 weak 指向的对象内存地址是a，那么就会以a为键， 在这个 weak 表中搜索，找到所有以a为键的 weak 对象，从而设置为 nil。

---

##### 29.@protocol 和 category 中如何使用 @property
* 在 protocol 中使用 property 只会生成 setter 和 getter 方法声明,我们使用属性的目的,是希望遵守我协议的对象能实现该属性
* category 使用 @property 也是只会生成 setter 和 getter 方法的声明,如果我们真的需要给 category 增加属性的实现,需要借助于运行时的两个函数：
	* objc_setAssociatedObject
	* objc_getAssociatedObject

---

##### 28.@property 的本质是什么？ivar、getter、setter 是如何生成并添加到这个类中的

* @property 的本质是什么？
	* @property = ivar + getter + setter;

* ivar、getter、setter 是如何生成并添加到这个类中的?
	* “自动合成”( autosynthesis)

---

##### 27.如何让自己的类用 copy 修饰符？如何重写带 copy 关键字的 setter？
* 若想令自己所写的对象具有拷贝功能，则需实现 NSCopying 协议。如果自定义的对象分为可变版本与不可变版本，那么就要同时实现 NSCopying 与 NSMutableCopying 协议。
* 具体步骤：
	* 需声明该类遵从 NSCopying 协议
	* 实现 NSCopying 协议。该协议只有一个方法:
	* - (id)copyWithZone:(NSZone *)zone;

* 重写带 copy 关键字的 setter
```

- (void)setName:(NSString *)name {
    
    _name = [name copy];
}

```

---

##### 26.这个写法会出什么问题： @property (copy) NSMutableArray *array;

```

// .h文件
// 下面的代码就会发生崩溃
@property ( copy) NSMutableArray *mutableArray;

// .m文件
NSMutableArray *array = [NSMutableArray arrayWithObjects:@1,@2,nil];
self.mutableArray = array; //array是可变的，但是self.mutableArray是用copy修饰，是不可变的
[self.mutableArray removeObjectAtIndex:0];// 不可变的self.mutableArray没有removeObjectAtIndex方法

// 接下来就会奔溃：
 -[__NSArrayI removeObjectAtIndex:]: unrecognized selector sent to instance 0x7fcd1bc30460

```

* 两个问题：
	* 1、添加,删除,修改数组内的元素的时候,程序会因为找不到对应的方法而崩溃.因为 copy 就是复制一个不可变 NSArray 的对象；
	* 2、使用了 atomic 属性会严重影响性能 ；

* 原因：
	* atomic该属性使用了自旋锁，会在创建时生成一些额外的代码用于帮助编写多线程程序，这会带来性能问题，通过声明 nonatomic 可以节省这些虽然很小但是不必要额外开销。
	* 开发iOS程序时一般都会使用 nonatomic 属性。但是在开发 Mac OS X 程序时，使用 atomic 属性通常都不会有性能瓶颈。

---

##### 25.怎么用 copy 关键字？
* 用途：
	* NSString、NSArray、NSDictionary 等等经常使用copy关键字，是因为他们有对应的可变类型：NSMutableString、NSMutableArray、NSMutableDictionary；
	* block 也经常使用 copy 关键字，具体原因见官方文档：Objects Use Properties to Keep Track of Blocks：
* block 使用 copy 是从 MRC 遗留下来的“传统”,在 MRC 中,方法内部的 block 是在栈区的,使用 copy 可以把它放到堆区.在 ARC 中写不写都行：对于 block 使用 copy 还是 strong 效果是一样的，但写上 copy 也无伤大雅，还能时刻提醒我们：编译器自动对 block 进行了 copy 操作。如果不写 copy ，该类的调用者有可能会忘记或者根本不知道“编译器会自动对 block 进行了 copy 操作”，他们有可能会在调用之前自行拷贝属性值。这种操作多余而低效。你也许会感觉我这种做法有些怪异，不需要写依然写。如果你这样想，其实是你“日用而不知”。
* 下面做下解释： copy 此特质所表达的所属关系与 strong 类似。然而设置方法并不保留新值，而是将其“拷贝” (copy)。 当属性类型为 NSString 时，经常用此特质来保护其封装性，因为传递给设置方法的新值有可能指向一个 NSMutableString 类的实例。这个类是 NSString 的子类，表示一种可修改其值的字符串，此时若是不拷贝字符串，那么设置完属性之后，字符串的值就可能会在对象不知情的情况下遭人更改。所以，这时就要拷贝一份“不可变” (immutable)的字符串，确保对象中的字符串值不会无意间变动。只要实现属性所用的对象是“可变的” (mutable)，就应该在设置新属性值时拷贝一份。

---

##### 24.什么情况使用 weak 关键字，相比 assign 有什么不同？
* 什么情况使用 weak 关键字？
	* 在 ARC 中,在有可能出现循环引用的时候,往往要通过让其中一端使用 weak 来解决,比如: delegate 代理属性
	* 自身已经对它进行一次强引用,没有必要再强引用一次,此时也会使用 weak,自定义 IBOutlet 控件属性一般也使用 weak；当然，也可以使用strong。在下文也有论述：《IBOutlet连出来的视图属性为什么可以被设置成weak?》

* 不同点：
	* weak 此特质表明该属性定义了一种“非拥有关系” (nonowning relationship)。为这种属性设置新值时，设置方法既不保留新值，也不释放旧值。此特质同assign类似， 然而在属性所指的对象遭到摧毁时，属性值也会清空(nil out)。 而 assign 的“设置方法”只会执行针对“纯量类型” (scalar type，例如 CGFloat 或 NSlnteger 等)的简单赋值操作。
	* assign 可以用非 OC 对象,而 weak 必须用于 OC 对象

---

##### 23.风格纠错题

```

typedef enum {
    UserSex_Man,
    UserSex_Woman
}UserSex;

@interface UserModel:NSObject
@property(nonatomic,strong)NSString *name;
@property(assign,nonatomic)int age;
@property(nonatomic,assign)UserSex sex;

- (id)initUserModelWithUserName:(NSString *)name withAge:(int)age;
- (void)doLogIn;
@end

// 修改后
typedef NS_ENUM(NSInteger, CYLSex) {
     CYLSexMan,
     CYLSexWoman
};

@interface CYLUser : NSObject<NSCopying>

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) NSUInteger age;
@property (nonatomic, readwrite, assign) CYLSex sex;

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age sex:(CYLSex)sex;
- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age;
+ (instancetype)userWithName:(NSString *)name age:(NSUInteger)age sex:(CYLSex)sex;

@end

```

---

##### 22.死锁-下面代码输出什么？

```

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}

```

* 答案：输出1之后程序死锁
* 解释：dispatch_sync文档中提到：
* Calls to dispatch_sync() targeting the current queue will result in dead-lock. Use of dispatch_sync() is also subject to the same multi-party dead-lock problems that may result from the use of a mutex. Use of dispatch_async() is preferred.
* sync到当前线程的block将会引起死锁，所以只会Log出1来后主线程就进入死锁状态，不会继续执行。
* 究其原因，还要看dispatch_sync做的事，它将一个block插入到queue中，这点和async没有区别，区别在于sync会等待到这个block执行完成后才回到调用点继续执行，而这个block的执行还依仗着viewDidLoad中dispatch_sync调用的结束，所以造成了循环等待，导致死锁。

---

##### 21.不使用IB时，下面这样做有问题么？

```

- (void)viewDidLoad {
  [super viewDidLoad];
  CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
  UIView *view = [[UIView alloc] initWithFrame:frame];
  [self.view addSubview:view];
}

```

* 解释：不使用IB手动创建ViewController时，在viewDidLoad中并未进行位置的初始化，原来遇到过不少次这个小坑，当外部创建这个vc时：

```

TestViewController *vc = [[TestViewController alloc] init];
vc.view.frame = CGRectMake(0, 0, 100, 100);
//...

```

* 我们知道，ViewController的view初始化大概流程是：

```

- (UIView *)view {
  if (!_view) {
    [self loadView];
    // [MX：创建一个vc的view时，会主动调用viewDidLoad方法，所以在viewDidLoad中用到view的fram会来自window，而非你赋值的参数，导致尺寸不对]
    [self viewDidLoad]; // Edit: 这句话移动到括号内，感谢@change2hao的提醒
  }
}

```

* 所以在外部执行到vc.view.frame = CGRectMake(0, 0, 100, 100);这句话时，在赋值操作执行前，viewDidLoad就已经被调用，因而在viewDidLoad中对view frame的取值都是默认值（window的大小），而非设定值。
* 注： 使用IB加载时如上情况也会发生，只是一般在IB就已经有一个预设值了。

---

##### 20.请求很快就执行完成，但是completionBlock很久之后才设置，还能否执行呢？

```

// 当前在主线程
[request startAsync]; // 后台线程异步调用，完成后会在主线程调用completionBlock
sleep(100); // sleep主线程，使得下面的代码在后台线程完成后才能执行
[request setCompletionBlock:^{
    NSLog(@"Can I be printed?");
}];

```

* 答案：可以（有条件）
* 解释：为了方便解释，我们将其考虑成gcd的两个线性queue：main queue 和 back queue

* 当代码执行到sleep(100)时，这两个queue要执行的顺序看起来是这样的：
	* main: *— sleep ————————-> | —setCompletionBlock—>
	* back: *— network —->
* 于是网络请求很快回来，回调函数一般要执行如：

```

// 回到主线程执行回调
dispatch_async(dispatch_get_main_queue(), ^{
  if (self.completionBlock) self.completionBlock();
});

```

* 于是成了这样：
	* main: *—-sleep—-> | —setCompletionBlock—> | —invoke completionBlock—->
	* back: *

* 所以，当sleep结束后，主线程保持了调用顺序：
	* main: *—setCompletionBlock—> | —invoke completionBlock—->

* 此时，completionBlock的执行是在setCompletionBlock，之后的，所以可以正常回调。
* 注：这个解释有一个有限制条件，如果用下面的方法回调，则情况就会不同了：

```

// 回到主线程执行回调[MX:下面的代码在网络请求完成后，直接在主线程查看回调，所以可能还没有设置完回调，就开始调用回调，所以会导致self.completionBlock()回调不执行]
if (self.completionBlock) {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.completionBlock();
});

```

---

##### 19.下面的代码报错？警告？还是正常输出什么？

```

Father *father = [Father new];
BOOL b1 = [father responseToSelector:@selector(responseToSelector:)];
BOOL b2 = [Father responseToSelector:@selector(responseToSelector:)];
NSLog(@"%d, %d", b1, b2);

```

* 答案：都输出”1”(YES)
* 解释：objc中：
	* 不论是实例对象还是Class，都是id类型的对象（Class同样是对象）
	* 实例对象的isa指向它的Class（储存所有减号方法）,Class对象的isa指向元类（储存所有加号方法）
	* 向一个对象（id类型）发送消息时，都是从这个对象的isa指针指向的Class中寻找方法
* 回到题目，当像Father类发送一个实例方法（- responseToSelector）消息时：
	* 会从它的isa，也就是Father元类对象中寻找，由于元类中的方法都是类方法，所以自然找不到
	* 于是沿继承链去父类NSObject元类中寻找，依然没有
	* 由于objc对这块的设计是，NSObject的元类的父类是NSObject类（也就是我们熟悉的NSObject类），其中有所有的实例方法，因此找到了- responseToSelector
* 补充：NSObject类中的所有实例方法很可能都对应实现了一个类方法（至少从开源的代码中可以看出来），如+ resonseToSelector，但并非公开的API，如果真的是这样，上面到第2步就可以找到这个方法。
* 再补充： 非NSObject的selector这样做无效。

---

##### 18.[self class]和[super class]

```

@implementation Son : Father
- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
    }
    return self;
}
@end

```

* 答案：都输出”Son”
* 解释：objc中super是编译器标示符，并不像self一样是一个对象，遇到向super发的方法时会转译成objc_msgSendSuper(...)，而参数中的对象还是self[mx:就是最后还是从self开始查]，于是从父类开始沿继承链寻找- class这个方法，最后在NSObject中找到（若无override），此时，[self class]和[super class]已经等价了。

---

##### 17.死锁
* 死锁就是队列引起的循环等待=a等b，b又等a
* 一个比较常见的死锁例子:主队列同步

```

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
       
       NSLog(@"deallock");
    });
}

```

* 以上死锁例子解析：
	* 在主线程中运用主队列同步，也就是把任务放到了主线程的队列中。
	* 同步对于任务是立刻执行的，那么当把任务放进主队列时，它就会立马执行,只有执行完这个任务，viewDidLoad才会继续向下执行。
	* 而viewDidLoad和任务都是在主队列上的，由于队列的先进先出原则，任务又需等待viewDidLoad执行完毕后才能继续执行，viewDidLoad和这个任务就形成了相互循环等待，就造成了死锁。
	* 想避免这种死锁，可以将同步改成异步dispatch_async,或者将dispatch_get_main_queue换成其他串行或并行队列，都可以解决。

* 死锁例子2

```

dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);

dispatch_async(serialQueue, ^{
   
   	dispatch_sync(serialQueue, ^{
 
   		NSLog(@"deadlock");
  	});
});

// 解决死锁
dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);

dispatch_queue_t serialQueue2 = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);

dispatch_async(serialQueue, ^{
	dispatch_sync(serialQueue2, ^{
	  NSLog(@"deadlock");
	});
});

```

* 外面的函数无论是同步还是异步都会造成死锁。
* 这是因为里面的任务和外面的任务都在同一个serialQueue队列内，又是同步，这就和上边主队列同步的例子一样造成了死锁
* 解决方法也和上边一样，将里面的同步改成异步dispatch_async,或者将serialQueue换成其他串行或并行队列，都可以解决

---

##### 16.内存布局
* 栈(stack):方法调用，局部变量等，是连续的，高地址往低地址扩展
* 堆(heap):通过alloc等分配的对象，是离散的，低地址往高地址扩展，需要我们手动控制
* 未初始化数据(bss):未初始化的全局变量等
* 已初始化数据(data):已初始化的全局变量等
* 代码段(text):程序代码

---

##### 15.内存管理方案
* taggedPointer ：存储小对象如NSNumber。深入理解Tagged Pointer
* NONPOINTER_ISA(非指针型的isa):在64位架构下，isa指针是占64比特位的，实际上只有30多位就已经够用了，为了提高利用率，剩余的比特位存储了内存管理的相关数据内容。
* 散列表：复杂的数据结构，包括了引用计数表和弱引用表
	* 通过SideTables()结构来实现的，SideTables()结构下，有很多SideTable的数据结构。
	* 而sideTable当中包含了自旋锁，引用计数表，弱引用表。
	* SideTables()实际上是一个哈希表，通过对象的地址来计算该对象的引用计数在哪个sideTable中。
* 自旋锁：自旋锁是“忙等”的锁;适用于轻量访问。
* 引用计数表和弱引用表实际是一个哈希表，来提高查找效率。

---

##### 14.自动释放池
* 在当次runloop将要结束的时候调用objc_autoreleasePoolPop，并push进来一个新的AutoreleasePool
* AutoreleasePoolPage是以栈为结点通过双向链表的形式组合而成，是和线程一一对应的。
* 内部属性有parent，child对应前后两个结点，thread对应线程 ，next指针指向栈中下一个可填充的位置。
* AutoreleasePool实现原理？>编译器会将 @autoreleasepool {} 改写为

```

void * ctx = objc_autoreleasePoolPush;
    {}
objc_autoreleasePoolPop(ctx);

```

* objc_autoreleasePoolPush：
	* 把当前next位置置为nil，即哨兵对象,然后next指针指向下一个可入栈位置，
	* AutoreleasePool的多层嵌套，即每次objc_autoreleasePoolPush，实际上是不断地向栈中插入哨兵对象。
* objc_autoreleasePoolPop:
	* 根据传入的哨兵对象找到对应位置。
	* 给上次push操作之后添加的对象依次发送release消息。
	* 回退next指针到正确的位置。

---

##### 13.MRC（手动引用计数）和ARC(自动引用计数)
* MRC：alloc，retain，release，retainCount,autorelease,dealloc
* ARC：
	* ARC是LLVM和Runtime协作的结果
	* ARC禁止手动调用retain，release，retainCount,autorelease关键字
	* ARC新增weak，strong关键字
* 引用计数管理：
	* alloc: 经过一系列函数调用，最终调用了calloc函数，这里并没有设置引用计数为1
	* retain: 经过两次哈希查找，找到其对应引用计数值，然后将引用计数加1(实际是加偏移量)
	* release：和retain相反，经过两次哈希查找，找到其对应引用计数值，然后将引用计数减1
	* dealloc:
* 弱引用管理：
	* 添加weak变量:通过哈希算法位置查找添加。如果查找对应位置中已经有了当前对象所对应的弱引用数组，就把新的弱引用变量添加到数组当中；如果没有，就创建一个弱引用数组，并将该弱引用变量添加到该数组中。
	* 当一个被weak修饰的对象被释放后，weak对象怎么处理的？
		* 清除weak变量，同时设置指向为nil。当对象被dealloc释放后，在dealloc的内部实现中，会调用弱引用清除的相关函数，会根据当前对象指针查找弱引用表，找到当前对象所对应的弱引用数组，将数组中的所有弱引用指针都置为nil。
---

##### 12.循环引用
* 循环引用的实质：多个对象相互之间有强引用，不能释放让系统回收。
* 循环引用场景
	* 自循环引用:对象强持有的属性同时持有该对象
	* 相互循环引用(两个对象之间)
	* 多循环引用(很多个对象之间)
	
* 相互循环引用
	* 代理(delegate)循环引用属于相互循环引用
		*delegate 是iOS中开发中比较常遇到的循环引用，一般在声明delegate的时候都要使用弱引用 weak,或者assign,当然怎么选择使用assign还是weak，MRC的话只能用assign，在ARC的情况下最好使用weak，因为weak修饰的变量在释放后自动指向nil，防止野指针存在
	* NSTimer循环引用属于相互循环使用
		* 在控制器内，创建NSTimer作为其属性，由于定时器创建后也会强引用该控制器对象，那么该对象和定时器就相互循环引用了。
		* 如何解决呢？
			* 这里我们可以使用手动断开循环引用：
			* 如果是不重复定时器，在回调方法里将定时器invalidate并置为nil即可。
			* 如果是重复定时器，在合适的位置将其invalidate并置为nil即可

* 自循环引用例子

```
@property (copy, nonatomic) dispatch_block_t myBlock;
@property (copy, nonatomic) NSString *blockString;

- (void)testBlock {
    self.myBlock = ^() {
        NSLog(@"%@",self.blockString);
    };
}

// 由于block会对block中的对象进行持有操作,就相当于持有了其中的对象，而如果此时block中的对象又持有了该block，则会造成循环引用。
// 解决方案就是使用__weak修饰self即可

__weak typeof(self) weakSelf = self;

self.myBlock = ^() {
    NSLog(@"%@",weakSelf.blockString);
};

// 并不是所有block都会造成循环引用。只有被强引用了的block才会产生循环引用,而比如dispatch_async(dispatch_get_main_queue(), ^{}),[UIView animateWithDuration:1 animations:^{}]这些系统方法等或者block并不是其属性而是临时变量,即栈block

[self testWithBlock:^{
    NSLog(@"%@",self);
}];

- (void)testWithBlock:(dispatch_block_t)block {
    block();
}

// 还有一种场景，在block执行开始时self对象还未被释放，而执行过程中，self被释放了，由于是用weak修饰的，那么weakSelf也被释放了，此时在block里访问weakSelf时，就可能会发生错误(向nil对象发消息并不会崩溃，但也没任何效果)。对于这种场景，应该在block中对,对象使用__strong修饰，使得在block期间对 对象持有，block执行结束后，解除其持有。

__weak typeof(self) weakSelf = self;

self.myBlock = ^() {
    __strong __typeof(self) strongSelf = weakSelf;
    [strongSelf test];
};

```

---

##### 11.UIView与CALayer的区别？
* UIView为CALayer提供内容，以及负责处理触摸等事件，参与响应链；
* CALayer负责显示内容contents

---

##### 10.图像显示原理是什么？
* CPU:输出位图
	* Layout: UI布局，文本计算
	* Display: 绘制
	* Prepare: 图片解码
	* Commit：提交位图
* GPU:图层渲染，纹理合成
	* 渲染管线(OpenGL)
	* 顶点着色，图元装配，光栅化，片段着色，片段处理
* 把结果放到帧缓冲区(frame buffer)中
* 再由视频控制器根据vsync信号在指定时间之前去提取帧缓冲区的屏幕显示内容
* 显示到屏幕上

---

##### 9.UI卡顿掉帧原因？
* 首先要明确什么是掉帧，掉帧就是在规定时间内没有显示完该有的帧数就是掉帧，掉帧多了就会变成卡顿。
* 流畅的页面一般要在1s内显示60帧，就是达到60fps，那一帧的时间就是1000ms/60=16.7ms，每隔16.7ms要产生一帧画面，才能达到流畅，那一帧画面所用的时间由什么组成呢？
* 结论是一帧的时间是有cpu和gpu共同决定的。iOS设备的硬件时钟会发出Vsync（垂直同步信号），然后App的CPU会去计算屏幕要显示的内容，之后将计算好的内容提交到GPU去渲染。随后，GPU将渲染结果提交到帧缓冲区，等到下一个VSync到来时将缓冲区的帧显示到屏幕上。

---

##### 8.怎么解决UI卡顿掉帧？

* 在cpu层优化，把以下操作放在子线程中
	* 对象创建、调整、销毁
	* 预排版（布局计算、文本计算、缓存高度等等）
	* 预渲染（文本等异步绘制，图片解码等）
	
* 在gpu层优化
	* 减少离屏渲染
	
---

##### 7.离屏渲染的概念？
* On-Screen Rendering:当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行
* Off-Screen Rendering:离屏渲染，分为CPU离屏渲染和GPU离屏渲染两种形式。GPU离屏渲染指的是GPU在当前屏幕缓冲区外新开辟一个缓冲区进行渲染操作；离屏渲染会增加GPU的工作量，可能会导致CPU+GPU的处理时间超出16.7ms，导致掉帧卡顿
* 离屏渲染何时会触发？
	* 圆角（当和maskToBounds一起使用时）、图层蒙版、阴影，设置
	
---

##### 6.分类
* 1.分类的作用？
	* 声明私有方法，分解体积大的类文件，把framework的私有方法公开
* 2.分类的特点
	* 运行时决议，可以为系统类添加分类 。
	* 说得详细些，在运行时时期，将 Category 中的实例方法列表、协议列表、属性列表添加到主类中后（所以Category中的方法在方法列表中的位置是在主类的同名方法之前的），然后会递归调用所有类的 load 方法，这一切都是在main函数之前执行的。
* 3.分类可以添加哪些内容？
	* 实例方法，类方法，协议，属性（添加getter和setter方法，并没有实例变量，添加实例变量需要用关联对象）
* 4.如果工程里有两个分类A和B，两个分类中有一个同名的方法，哪个方法最终生效？
	* 取决于分类的编译顺序，最后编译的那个分类的同名方法最终生效，而之前的都会被覆盖掉(这里并不是真正的覆盖，因为其余方法仍然存在，只是访问不到，因为在动态添加类的方法的时候是倒序遍历方法列表的，而最后编译的分类的方法会放在方法列表前面，访问的时候就会先被访问到，同理如果声明了一个和原类方法同名的方法，也会覆盖掉原类的方法)。
* 5.如果声明了两个同名的分类会怎样？
	* 会报错，所以第三方的分类，一般都带有命名前缀
* 6.分类能添加成员变量吗？
	* 不能。只能通过关联对象(objc_setAssociatedObject)来模拟实现成员变量，但其实质是关联内容，所有对象的关联内容都放在同一个全局容器哈希表中:AssociationsHashMap,由AssociationsManager统一管理。

---

##### 5.代理
* 代理是一种设计模式，以@protocol形式体现，一般是一对一传递。
* 一般以weak关键词以规避循环引用。

---

##### 4.通知
* 使用观察者模式来实现的用于跨层传递信息的机制。传递方式是一对多的。

---

##### 3.KVO (Key-value observing)
* KVO是观察者模式的另一实现。
* 使用了isa混写(isa-swizzling)来实现KVO
* 使用setter方法改变值KVO会生效，使用setValue:forKey即KVC改变值KVO也会生效，因为KVC会去调用setter方法
* 那么通过直接赋值成员变量会触发KVO吗？
	* 不会，因为不会调用setter方法，需要加上willChangeValueForKey和didChangeValueForKey方法来手动触发才行

---

##### 2.KVC(Key-value coding)
* KVC就是指iOS的开发中，可以允许开发者通过Key名直接访问对象的属性，或者给对象的属性赋值。而不需要调用明确的存取方法。这样就可以在运行时动态地访问和修改对象的属性。而不是在编译时确定，这也是iOS开发中的黑魔法之一。很多高级的iOS开发技巧都是基于KVC实现的
* 当调用setValue：属性值 forKey：@”name“的代码时，，底层的执行机制如下：
	* 程序优先调用set<Key>:属性值方法，代码通过setter方法完成设置。注意，这里的<key>是指成员变量名，首字母大小写要符合KVC的命名规则，下同
	* 如果没有找到setName：方法，KVC机制会检查+ (BOOL)accessInstanceVariablesDirectly方法有没有返回YES，默认该方法会返回YES，如果你重写了该方法让其返回NO的话，那么在这一步KVC会执行setValue：forUndefinedKey：方法，不过一般开发者不会这么做。所以KVC机制会搜索该类里面有没有名为<key>的成员变量，无论该变量是在类接口处定义，还是在类实现处定义，也无论用了什么样的访问修饰符，只在存在以<key>命名的变量，KVC都可以对该成员变量赋值。
	* 如果该类即没有set<key>：方法，也没有_<key>成员变量，KVC机制会搜索_is<Key>的成员变量。
	* 和上面一样，如果该类即没有set<Key>：方法，也没有_<key>和_is<Key>成员变量，KVC机制再会继续搜索<key>和is<Key>的成员变量。再给它们赋值。
	* 如果上面列出的方法或者成员变量都不存在，系统将会执行该对象的setValue：forUndefinedKey：方法，默认是抛出异常。
	* 即如果没有找到Set<Key>方法的话，会按照_key，_iskey，key，iskey的顺序搜索成员并进行赋值操作。
	* 如果开发者想让这个类禁用KVC，那么重写+ (BOOL)accessInstanceVariablesDirectly方法让其返回NO即可，这样的话如果KVC没有找到set<Key>:属性名时，会直接用setValue：forUndefinedKey：方法。
* 当调用valueForKey：@”name“的代码时，KVC对key的搜索方式不同于setValue：属性值 forKey：@”name“，其搜索方式如下：
	* 首先按get<Key>,<key>,is<Key>的顺序方法查找getter方法，找到的话会直接调用。如果是BOOL或者Int等值类型， 会将其包装成一个NSNumber对象。
	* 如果上面的getter没有找到，KVC则会查找countOf<Key>,objectIn<Key>AtIndex或<Key>AtIndexes格式的方法。如果countOf<Key>方法和另外两个方法中的一个被找到，那么就会返回一个可以响应NSArray所有方法的代理集合(它是NSKeyValueArray，是NSArray的子类)，调用这个代理集合的方法，或者说给这个代理集合发送属于NSArray的方法，就会以countOf<Key>,objectIn<Key>AtIndex或<Key>AtIndexes这几个方法组合的形式调用。还有一个可选的get<Key>:range:方法。所以你想重新定义KVC的一些功能，你可以添加这些方法，需要注意的是你的方法名要符合KVC的标准命名方法，包括方法签名。
	* 如果上面的方法没有找到，那么会同时查找countOf<Key>，enumeratorOf<Key>,memberOf<Key>格式的方法。如果这三个方法都找到，那么就返回一个可以响应NSSet所的方法的代理集合，和上面一样，给这个代理集合发NSSet的消息，就会以countOf<Key>，enumeratorOf<Key>,memberOf<Key>组合的形式调用。
	* 如果还没有找到，再检查类方法+ (BOOL)accessInstanceVariablesDirectly,如果返回YES(默认行为)，那么和先前的设值一样，会按_<key>,_is<Key>,<key>,is<Key>的顺序搜索成员变量名，这里不推荐这么做，因为这样直接访问实例变量破坏了封装性，使代码更脆弱。如果重写了类方法+ (BOOL)accessInstanceVariablesDirectly返回NO的话，那么会直接调用valueForUndefinedKey:方法，默认是抛出异常。

---

##### 1.属性关键字
* 读写权限：readonly,readwrite(默认)
* 原子性:atomic(默认)，nonatomic。atomic读写线程安全，但效率低，而且不是绝对的安全，比如如果修饰的是数组，那么对数组的读写是安全的，但如果是操作数组进行添加移除其中对象的还，就不保证安全了。
* 引用计数：
	* retain/strong
	* assign：修饰基本数据类型，修饰对象类型时，不改变其引用计数，会产生悬垂指针，修饰的对象在被释放后，assign指针仍然指向原对象内存地址，如果使用assign指针继续访问原对象的话，就可能会导致内存泄漏或程序异常
	* weak：不改变被修饰对象的引用计数，所指对象在被释放后，weak指针会自动置为nil
	* copy：分为深拷贝和浅拷贝[私密链接](https://github.com/codeRiding/FAQ/blob/d07953143eeb5986f18a6d0363c0bae7a77cc766/faq2018/faq20180362.iOS%E7%9A%84oc%E5%9F%BA%E7%A1%80copy%E6%B7%B1%E6%8B%B7%E8%B4%9D%E5%92%8C%E6%B5%85%E6%8B%B7%E8%B4%9DmutableCopy.md)
		* 浅拷贝：对内存地址的复制，让目标对象指针和原对象指向同一片内存空间会增加引用计数
		* 深拷贝：对对象内容的复制，开辟新的内存空间
		* 可变对象的copy和mutableCopy都是深拷贝
		* 不可变对象的copy是浅拷贝，mutableCopy是深拷贝
		* copy方法返回的都是不可变对象
		* @property (nonatomic, copy) NSMutableArray * array;这样写有什么影响？
			* 因为copy方法返回的都是不可变对象，所以array对象实际上是不可变的，如果对其进行可变操作如添加移除对象，则会造成程序crash
		
---

### iOS面试反问技术官
* 预期使用方式
* 检查一下哪些问题你感兴趣
* 检查一下哪些是你可以自己在网上找到答案的
* 找不到的话就向面试官提问
* 绝对不要想把这个列表里的每个问题都问一遍。
* 请记住事情总是灵活的，组织的结构调整也会经常发生。 拥有一个 bug 追踪系统并不会保证高效处理 bug。CI/CD (持续集成系统) 也不一定保证交付时间会很短。

---

#### 职责
* On-call (电话值班)的计划或者规定是什么？值班或者遇到问题加班时候有加班费吗？
* 我的日常工作是什么？
* 团队里面初级和高级工程师的比例是多少？（有计划改变吗）
* 入职培训会是什么样的？
* 自己单独的开发活动和按部就班工作的比例大概是怎样的？
* 每天预期/核心工作时间是多少小时？
* 在你看来，这个工作做到什么程度算成功？
* 我入职的岗位是新增还是接替之前离职的同事？(是否有技术债需要还)？(zh)
* 入职之后在哪个项目组，项目是新成立还是已有的？(zh)

---

#### 技术
* 公司常用的技术栈是什么?
* 你们怎么使用源码控制系统？
* 你们怎么测试代码？
* 你们怎么追踪 bug?
* 你们怎么集成和部署代码改动？是使用持续集成和持续部署吗？
* 你们的基础设施搭建方法在版本管理系统里吗？或者是代码化的吗？
* 从计划到完成一项任务的工作流是什么样的？
* 你们如何准备故障恢复？
* 有标准的开发环境吗？是强制的吗？
* 你们需要花费多长时间来给产品搭建一个本地测试环境？（分钟/小时/天）
* 你们需要花费多长时间来响应代码或者依赖中的安全问题？
* 所有的开发者都可以使用他们电脑的本地管理员权限吗？
* 公司是否有技术分享交流活动？有的话，多久一次呢？(zh)
* 你们的数据库是怎么进行版本控制的？(zh)
* 业务需求有没有文档记录？是如何记录的？(zh)

---

#### 团队
* 工作是怎么组织的？
* 团队内/团队间的交流通常是怎样的？
* 如果遇到不同的意见怎样处理？
* 谁来设定优先级 / 计划？
* 如果被退回了会怎样？（“这个在预计的时间内做不完”）
* 每周都会开什么类型的会议？
* 产品/服务的规划是什么样的？（n周一发布 / 持续部署 / 多个发布流 / ...)
* 生产环境发生事故了怎么办？是否有不批评人而分析问题的文化？
* 有没有一些团队正在经历还尚待解决的挑战？
* 公司技术团队的架构和人员组成？(zh)
* 团队内开发、产品、运营哪一方是需求的主要提出方？哪一方更强势？(zh)

---

#### 公司
* 有没有会议/旅行预算？使用的规定是什么？
* 晋升流程是怎样的？要求/预期是怎样沟通的？
* 技术和管理两条职业路径是分开的吗？
* 对于多元化招聘的现状或者观点是什么？
* 有公司级别的学习资源吗？比如电子书订阅或者在线课程？
* 有获取证书的预算吗？
* 公司的成熟度如何？（早期寻找方向 / 有内容的工作 / 维护中 / ...)
* 我可以为开源项目做贡献吗？是否需要审批？
* 有竞业限制或者保密协议需要签吗？
* 你们认为公司文化中的空白是什么？
* 能够跟我说一公司处于不良情况，以及如何处理的故事吗？
* 您在这工作了多久了？您觉得体验如何？(zh)
* 大家为什么会喜欢这里？(zh)
* 公司的调薪制度是如何的？(zh)

---

#### 商业
* 你们现在盈利吗？
* 如果没有的话，还需要多久？
* 公司的资金来源是什么？谁影响或者指定高层计划或方向？
* 你们如何挣钱？
* * 什么阻止了你们挣更多的钱？
* 你们认为什么是你们的竞争优势？
* 公司未来的商业规划是怎样的？有上市的计划吗？(zh)

---

#### 远程工作
* 远程工作和办公室工作的比例是多少？
* 公司提供硬件吗？更新计划如何？
* 额外的附件和家居可以通过公司购买吗？这方面是否有预算？
* 有共享办公或者上网的预算吗？
* 多久需要去一次办公室？
* 公司的会议室是否一直为视频会议准备着？

---

#### 办公室工作
* 办公室的布局如何？（开放的 / 小隔间 / 独立办公室）
* 有没有支持/市场/或者其他需要大量打电话的团队在我的团队旁边办公？

---

#### 待遇
* 如果有奖金计划的话，奖金如何分配？
* 如果有奖金计划的话，过去的几年里通常会发百分之多少的奖金？
* 有五险一金或者其他退休养老金等福利吗？如果有的话，公司有配套的商业保险吗？

---

#### 带薪休假
* 带薪休假时间有多久？
* 病假和事假是分开的还是一起算？
* 我可以提前使用假期时间吗？也就是说应休假期是负的？
* 假期的更新策略是什么样的？也就是说未休的假期能否滚入下一周期
* 照顾小孩的政策如何？
* 无薪休假政策是什么样的？