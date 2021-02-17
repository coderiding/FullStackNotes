# KVO常用语法

## 注册

```
// keyPath 就是要观察的属性值   
  // options 给你观察键值变化的选择   
  // context 方便传输你需要的数据  
  // NSKeyValueObservingOptionNew 
  // NSKeyValueObservingOptionOld  
  -(void)addObserver:(NSObject *)anObserver    
         forKeyPath:(NSString *)keyPath    
            options:(NSKeyValueObservingOptions)options    
            context:(voidvoid *)context  

// 添加监听，动态观察tableview的contentOffset的改变 
[tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil]; 
```

## 监听

```
//change 里存储了一些变化的数据，比如变化前的数据，变化后的数据；如果注册时context不为空，这里context就能接收到。   
  -(void)observeValueForKeyPath:(NSString *)keyPath    
                      ofObject:(id)object   
                        change:(NSDictionary *)change    
                       context:(voidvoid *)context  

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{ 
    if ([keyPath isEqualToString:@"contentOffset"]) 
    { 
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue]; 
         
        if (offset.y <= 0 && -offset.y >= 20) { 
             
            CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, -offset.y); 
             
            _introView.frame = newFrame; 
             
            if (-offset.y <= 200) 
            { 
                _tableView.contentInset = UIEdgeInsetsMake(-offset.y, 0, 0, 0); 
            } 
        } else { 
             
            CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, 64); 
            _introView.frame = newFrame; 
            _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0); 
        } 
    } 
}  
```

## 不监听{怎么实现，是和监听方法一致吗}
```
+ ( BOOL ) automaticallyNotifiesObserversForKey: ( NSString * ) key{   
    // 设置link属性非自动监听，一般用在手动实现KVO的时候 
    if ([ key isEqualToString:@"link" ]) {   
        return NO ;    
    }   
   
    return [ super automaticallyNotifiesObserversForKey:key ];    
} 
```

## 移除
```
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;  
```