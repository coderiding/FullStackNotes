# kVO底层实现机制

* 当某个类的对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的 setter 方法。 派生类在被重写的 setter 方法实现真正的通知机制，就如前面手动实现键值观察那样。这么做是基于设置属性会调用 setter 方法，而通过重写就获得了 KVO 需要的通知机制。当然前提是要通过遵循 KVO 的属性设置方式来变更属性值，如果仅是直接修改属性对应的成员变量，是无法实现 KVO 的。 同时派生类还重写了 class 方法以“欺骗”外部调用者它就是起初的那个类。然后系统将这个对象的 isa 指针指向这个新诞生的派生类，因此这个对象就成为该派生类的对象了，因而在该对象上对 setter 的调用就会调用重写的 setter，从而激活键值通知机制。此外，派生类还重写了 dealloc 方法来释放资源。

## 派生类 NSKVONotifying_Person 剖析：
* 在这个过程，被观察对象的 isa 指针从指向原来的 Person 类，被 KVO 机制修改为指向系统新创建的子类 NSKVONotifying_Person 类，来实现当前类属性值改变的监听。
* 所以当我们从应用层面上看来，完全没有意识到有新的类出现，这是系统“隐瞒”了对 KVO 的底层实现过程，让我们误以为还是原来的类。但是此时如果我们创建一个新的名为 NSKVONotifying_Person 的类()，就会发现系统运行到注册 KVO 的那段代码时程序就崩溃，因为系统在注册监听的时候动态创建了名为 NSKVONotifying_Person 的中间类，并指向这个中间类了。  因而在该对象上对 setter 的调用就会调用已重写的 setter，从而激活键值通知机制。这也是 KVO 回调机制，为什么都俗称 KVO 技术为黑魔法的原因之一吧：内部神秘、外观简洁。
* 子类 setter 方法剖析： KVO 在调用存取方法之前总是调用 willChangeValueForKey:，通知系统该 keyPath 的属性值即将变更。 当改变发生后，didChangeValueForKey: 被调用，通知系统该 keyPath 的属性值已经变更。 之后，observeValueForKey:ofObject:change:context: 也会被调用。 重写观察属性的 setter 方法这种方式是在运行时而不是编译时实现的。 KVO 为子类的观察者属性重写调用存取方法的工作原理在代码中相当于： 

```

- (void)setName:(NSString *)newName 
{ 
    [self willChangeValueForKey:@"name"];    // KVO 在调用存取方法之前总调用 
    [super setValue:newName forKey:@"name"]; // 调用父类的存取方法 
    [self didChangeValueForKey:@"name"];     // KVO 在调用存取方法之后总调用 
} 

```

* 总结： KVO 的本质就是监听对象的属性进行赋值的时候有没有调用 setter 方法 

* 系统会动态创建一个继承于 Person 的 NSKVONotifying_Person
* person 的 isa 指针指向的类 Person 变成 NSKVONotifying_Person，所以接下来的 person.age = newAge 的时候，他调用的不* 是 Person 的 setter 方法，而是 NSKVONotifying_Person（子类）的 setter 方法
* 重写NSKVONotifying_Person的setter方法：[super setName:newName]
* 通知观察者告诉属性改变。