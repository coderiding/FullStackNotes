### 题目1（来源《出一套iOS高级题》J_Knight_）

关联对象有什么应用，系统如何管理关联对象？其被释放的时候需要手动将其指针置空么？

### 题目2（来源《出一套iOS高级题》J_Knight_）

讲一下对象，类对象，元类，跟元类结构体的组成以及他们是如何相关联的？为什么对象方法没有保存的对象结构体里，而是保存在类对象的结构体里？

### 题目3（来源《出一套iOS高级题》J_Knight_）

class_ro_t 和 class_rw_t 的区别？

解答：class_ro_t只读，存储方法列表、属性列表、协议列表、iva指针等类的初始化信息，存储的方法、协议、属性是一维数组。

class_rw_t可读可写，存储分类方法，存储class_ro_t所有信息，存储的方法、协议、属性是二维数组，提供给runtime动态插入方法用

### 题目4（来源《出一套iOS高级题》J_Knight_）

iOS 中内省的几个方法？class方法和objc_getClass方法有什么区别?

### 题目5（来源《出一套iOS高级题》J_Knight_）

在运行时创建类的方法objc_allocateClassPair的方法名尾部为什么是pair（成对的意思）？

### 题目6 （来源《找一个靠谱的iOS》sunnyxx的技术博客）

@property 的本质是什么？ivar、getter、setter 是如何生成并添加到这个类中的

### 题目7 （来源《找一个靠谱的iOS》sunnyxx的技术博客）

@protocol 和 category 中如何使用 @property

### 题目8（来源《找一个靠谱的iOS》sunnyxx的技术博客）

runtime 如何实现 weak 属性

### [※※※]题目9 （来源《找一个靠谱的iOS》sunnyxx的技术博客）

objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？

### [※※※※]题目10 （来源《找一个靠谱的iOS》sunnyxx的技术博客）

一个objc对象的isa的指针指向什么？有什么作用？

### [※※※※]题目11（来源《找一个靠谱的iOS》sunnyxx的技术博客）

runtime如何通过selector找到对应的IMP地址？（分别考虑类方法和实例方法）

### [※※※※]题目12（来源《找一个靠谱的iOS》sunnyxx的技术博客）

使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？

### [※※※※※]题目13（来源《找一个靠谱的iOS》sunnyxx的技术博客）

_objc_msgForward函数是做什么的，直接调用它将会发生什么？

### [※※※※※]题目14（来源《找一个靠谱的iOS》sunnyxx的技术博客）

runtime如何实现weak变量的自动置nil？

### [※※※※※]题目15（来源《找一个靠谱的iOS》sunnyxx的技术博客）

能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？

### [※※※※※]题目16（来源《找一个靠谱的iOS》sunnyxx的技术博客）

IB中User Defined Runtime Attributes如何使用？