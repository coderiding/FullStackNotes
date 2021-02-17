# KVO的keypath一定是属性么

* KVC 支持实例变量
* KVO 只能手动支持手动设定实例变量的KVO实现监听
* 就是除了属性之外，还支持监听实例变量，但是要想监听实例变量就必须要手动实现KVO，这个可以做一道面试题，什么情况用到收到实现KVO的场景？

---

* 首先，KVO 兼容是 API 的一部分。如果类的所有者不保证某个属性兼容 KVO，我们就不能保证 KVO 正常工作。苹果文档里有 KVO 兼容属性的文档。例如，NSProgress 类的大多数属性都是兼容 KVO 的。 当做出改变以后，有些人试着放空的 -willChange 和 -didChange 方法来强制 KVO 的触发。KVO 通知虽然会生效，但是这样做破坏了有依赖于 NSKeyValueObservingOld 选项的观察者。详细来说，这影响了 KVO 对观察键路径 (key path) 的原生支持。KVO 在观察键路径 (key path) 时依赖于 NSKeyValueObservingOld 属性。  我们也要指出有些集合是不能被观察的。KVO 旨在观察关系 (relationship) 而不是集合。我们不能观察 NSArray，我们只能观察一个对象的属性——而这个属性有可能是 NSArray。举例说，如果我们有一个 ContactList 对象，我们可以观察它的 contacts 属性。但是我们不能向要观察对象的 -addObserver:forKeyPath:... 传入一个 NSArray。  相似地，观察 self 不是永远都生效的。而且这不是一个好的设计。