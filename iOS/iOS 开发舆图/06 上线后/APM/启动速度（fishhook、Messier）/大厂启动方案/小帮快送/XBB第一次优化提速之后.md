```objectivec
//相比第一次没有优化前
阶段2耗时：mian方法到didFinishLaunchingWithOptions方法的耗时--0.512035
阶段3耗时：didFinishLaunchingWithOptions方法内部的耗时--0.341064

//第一次优化之后
阶段2耗时：mian方法到didFinishLaunchingWithOptions方法的耗时--0.545832，晕，这里怎么时间还长了
阶段3耗时：didFinishLaunchingWithOptions方法内部的耗时--0.252466，这里的时间断了0.09s
```