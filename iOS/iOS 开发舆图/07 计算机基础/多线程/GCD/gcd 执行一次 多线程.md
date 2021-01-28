static dispatch_once_t onceToken; 
dispatch_once(&onceToken, ^{ 
   // 只执行1次的代码(这里面默认是线程安全的) 
}); 