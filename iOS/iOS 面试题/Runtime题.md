### 【题目1】 关联对象有什么应用，系统如何管理关联对象？其被释放的时候需要手动将其指针置空么？（来源《出一套iOS高级题》J_Knight_）

### 【题目2】 讲一下对象，类对象，元类，跟元类结构体的组成以及他们是如何相关联的？为什么对象方法没有保存的对象结构体里，而是保存在类对象的结构体里？（来源《出一套iOS高级题》J_Knight_）

### 【题目3】 class_ro_t 和 class_rw_t 的区别？（来源《出一套iOS高级题》J_Knight_）

解答：class_ro_t只读，存储方法列表、属性列表、协议列表、iva指针等类的初始化信息，存储的方法、协议、属性是一维数组。

class_rw_t可读可写，存储分类方法，存储class_ro_t所有信息，存储的方法、协议、属性是二维数组，提供给runtime动态插入方法用

### 【题目4】 iOS中内省的几个方法？class方法和objc_getClass方法有什么区别?（来源《出一套iOS高级题》J_Knight_）

### 【题目5】 在运行时创建类的方法objc_allocateClassPair的方法名尾部为什么是pair（成对的意思）？（来源《出一套iOS高级题》J_Knight_）

### 【题目6】 @property 的本质是什么？ivar、getter、setter 是如何生成并添加到这个类中的（来源《找一个靠谱的iOS》sunnyxx的技术博客）

### 【题目7】 @protocol 和 category 中如何使用 @property （来源《找一个靠谱的iOS》sunnyxx的技术博客）

### 【题目8】runtime 如何实现 weak 属性（来源《找一个靠谱的iOS》sunnyxx的技术博客）

### [※※※]题目9 objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？（来源《找一个靠谱的iOS》sunnyxx的技术博客）

### [※※※※]题目10 一个objc对象的isa的指针指向什么？有什么作用？（来源《找一个靠谱的iOS》sunnyxx的技术博客）

### [※※※※]题目11 runtime如何通过selector找到对应的IMP地址？（分别考虑类方法和实例方法）（来源《找一个靠谱的iOS》sunnyxx的技术博客）

### [※※※※]题目12 使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？（来源《找一个靠谱的iOS》sunnyxx的技术博客）

### [※※※※※]题目13 _objc_msgForward函数是做什么的，直接调用它将会发生什么？（来源《找一个靠谱的iOS》sunnyxx的技术博客）

### [※※※※※]题目14 runtime如何实现weak变量的自动置nil？（来源《找一个靠谱的iOS》sunnyxx的技术博客）

### [※※※※※]题目15 能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？（来源《找一个靠谱的iOS》sunnyxx的技术博客）

### [※※※※※]题目16 IB中User Defined Runtime Attributes如何使用？（来源《找一个靠谱的iOS》sunnyxx的技术博客）

