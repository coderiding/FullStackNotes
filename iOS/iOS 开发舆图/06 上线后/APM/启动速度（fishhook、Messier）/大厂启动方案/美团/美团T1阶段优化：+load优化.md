```objectivec
[mx思路：因为+load方法的执行时间很靠前，所以要处理这个方法内的任务，可以放到后面执行的尽量放到后面执行]

--------

目前iOS App中或多或少的都会写一些+load方法，用于在App启动执行一些操作，
+load方法在Initializers阶段被执行，但过多+load方法则会拖慢启动速度，
对于大中型的App更是如此。通过对App中+load的方法分析，
发现很多代码虽然需要在App启动时较早的时机进行初始化，但并不需要在+load这样非常靠前的位置，
完全是可以延迟到App冷启动后的某个时间节点，例如一些路由操作。其实+load也可以被当做一种启动项来处理，
所以在替换+load方法的具体实现上，我们仍然采用了上面的Kylin方式。

-----

使用示例：

// 用WMAPP_BUSINESS_INIT_AFTER_HOMELOADING声明替换+load声明即可，不需其他改动
WMAPP_BUSINESS_INIT_AFTER_HOMELOADING() { 
    // 原+load方法中的代码
}

// 在某个合适的时机触发注册到该阶段的所有方法，如冷启动结束后
[[KLNKylin sharedInstance] executeArrayForKey:@kWMAPP_BUSINESS_INITIALIZATION_AFTER_HOMELOADING_KEY]
```