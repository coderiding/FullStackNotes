# KVO 监听例子

## 监听 ScrollView 的 contentOffSet 属性
```
[scrollview addObserver:self  
             forKeyPath:@“contentOffset“                     
                options:NSKeyValueObservingOptionNew  
                context:nil];  
```