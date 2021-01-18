### 题目22（来源《道长的 Swift 面试题》故胤道长）

Swift 中定义常量和 Objective-C 中定义常量有什么区别？

一般人会觉得没有差别，因为写出来好像也确实没差别。

OC是这样定义常量的：

```swift
const int number = 0;
```

Swift 是这样定义常量的：

```swift
let number = 0
```

### 题目23（来源《道长的 Swift 面试题》故胤道长）

Swift 中 struct 和 class 什么区别？举个应用中的实例

- struct 是值类型，class 是引用类型。看过WWDC的人都知道，struct 是苹果推荐的，原因在于它在小数据模型传递和拷贝时比 class 要更安全，在多线程和网络请求时尤其好用。我们来看一个简单的例子：

```swift
class A {
  var val = 1
}

var a = A()
var b = a
b.val = 2
```

此时 a 的 val 也被改成了 2，因为 a 和 b 都是引用类型，本质上它们指向同一内存。解决这个问题的方法就是使用 struct：

```swift
struct A {
  var val = 1
}

var a = A()
var b = a
b.val = 2
```

此时 A 是struct，值类型，b 和 a 是不同的东西，改变 b 对于 a 没有影响。

### 题目：extension与category比较