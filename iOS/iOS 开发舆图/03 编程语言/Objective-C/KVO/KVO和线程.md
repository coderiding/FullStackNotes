# KVO和线程

* 一个需要注意的地方是，KVO 行为是同步的，并且发生与所观察的值发生变化的同样的线程上。没有队列或者 Run-loop 的处理。手动或者自动调用 -didChange... 会触发 KVO 通知。  所以，当我们试图从其他线程改变属性值的时候我们应当十分小心，除非能确定所有的观察者都用线程安全的方法处理 KVO 通知。通常来说，我们不推荐把 KVO 和多线程混起来。如果我们要用多个队列和线程，我们不应该在它们互相之间用 KVO。  KVO 是同步运行的这个特性非常强大，只要我们在单一线程上面运行（比如主队列 main queue），KVO 会保证下列两种情况的发生： 

* 首先，如果我们调用一个支持 KVO 的 setter 方法，如下所示： self.exchangeRate = 2.345; 
* KVO 能保证所有 exchangeRate 的观察者在 setter 方法返回前被通知到。 
* 其次，如果某个键被观察的时候附上了 NSKeyValueObservingOptionPrior 选项，直到 -observe... 被调用之前， exchangeRate 的 accessor 方法都会返回同样的值。