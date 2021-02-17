# iOS手势Gesture语法

## 手势类型
```
UIPanGestureRecognizer （拖动） 
UIPinchGestureRecognizer （捏合） 
UIRotationGestureRecognizer （旋转） 
UITapGestureRecognizer （点按） 
UILongPressGestureRecognizer （长按） 
UISwipeGestureRecognizer （轻扫）   
```

## UITapGestureRecognizer 点击
```
// MARK :UITapGestureRecognizer 的介绍 
func introduceTapGestureRecognizer() { 
    // 初始化 
    let NwTapGestureRecongnizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureClick)) 
    // 点击几次触发事件 
    NwTapGestureRecongnizer.numberOfTapsRequired = 2 
    // 几根手指点击触发事件 
    NwTapGestureRecongnizer.numberOfTouchesRequired = 2 
    // 手势的添加 
    NwImageView.addGestureRecognizer(NwTapGestureRecongnizer) 
} 
// TODO : tapGestureClick 的事件 
func tapGestureClick() -> Void { 
    print(" 被点击了") 
}
```

## UIPinchGestureRecognizer 捏合
```
// MARK : UIPinchGestureRecognizer 捏合手势的介绍 
func introducePinchGestureRecognizer() -> Void { 
     // 初始化 
    let NwPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchGestureClick(_ :))) 
    // 设置缩放比值 
    NwPinchGestureRecognizer.scale = 2 
    // 手势添加 
    NwImageView.addGestureRecognizer(NwPinchGestureRecognizer) 
} 
// TODO : pinchGestureClick 的事件 
func pinchGestureClick(_ pinchGesture : UIPinchGestureRecognizer) -> Void { 
    // 获取缩放比率 
    let velocityValue = pinchGesture.velocity 
    print(" 我的捏合速率是" + "\(velocityValue)") 
} 
```

## UILongPressGestureRecognizer 长按
```
// MARK : UILongPressGestureRecognizer 长按手势的介绍 
func introduceLongPressGestureRecognizer() -> Void { 
    // 初始化 
    let NwLongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressGestureClick)) 
    // 设置几次长按触发事件 
    NwLongPressGestureRecognizer.numberOfTapsRequired = 2 
    // 设置几个手指长按 
    NwLongPressGestureRecognizer.numberOfTouchesRequired = 2 
    // 设置长按的时间间隔 
    NwLongPressGestureRecognizer.minimumPressDuration = 0.4 
    // 设置长按期间可移动的距离 
    NwLongPressGestureRecognizer.allowableMovement = 20 
    // 添加手势 
    NwImageView.addGestureRecognizer(NwLongPressGestureRecognizer) 
} 
// TODO : longPressGestureClick  
func longPressGestureClick() -> Void { 
    print(" 长按手势点击") 
} 
```

## UISwipeGestureRecognizer 轻扫
```
// MARK : UISwipeGestureRecognizer  轻扫手势 
func introduceSwipeGestureRecognizer() -> Void { 
    // 初始化 
    let NwSwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeGestureClick)) 
    // 设置几个手指轻扫触发 
    NwSwipeGestureRecognizer.numberOfTouchesRequired = 2 
    /** 
     设置轻扫的方向 
     UISwipeGestureRecognizerDirection 方向 
     left : 向左 
     right : 向右 
     up : 向上 
     down : 向下 
     */ 
    NwSwipeGestureRecognizer.direction = .left 
    // 添加手势 
    NwImageView.addGestureRecognizer(NwSwipeGestureRecognizer) 
} 
func swipeGestureClick() -> Void { 
    print(" 轻扫触发") 
     
} 
```

## UIPanGestureRecognizer 拖拽
```
// MARK : UIPanGestureRecognizer 拖拽手势  
func introducePanGestureRecognizer() -> Void { 
    // 初始化 
   let NwPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureClick(_ :))) 
   // 设置最多几个手指和最少几个手指触发 
   NwPanGestureRecognizer.maximumNumberOfTouches = 2 
   NwPanGestureRecognizer.minimumNumberOfTouches = 1 
   // 设置将某个对象拖拽到那个点 
   NwPanGestureRecognizer.setTranslation(CGPoint.init(x: 100, y: 100), in: NwImageView) 
   // 添加手势 
   NwImageView.addGestureRecognizer(NwPanGestureRecognizer) 
} 
// TODO : panGestureClick 拖拽手势 
func panGestureClick(_ panGesture:UIPanGestureRecognizer) -> Void { 
   // 获取用户拖拽的点 
   let panPoint =  panGesture.translation(in: NwImageView) 
   print(panPoint.x + panPoint.y) 
   // 获取拖拽速率 
   let panVelocity = panGesture.velocity(in: NwImageView) 
   print(panVelocity) 
    
} 
```

## UIRotationGestureRecognizer 旋转
```
// MARK : UIRotationGestureRecognizer 旋转手势 
func introduceRotationGestureRecognizer() -> Void { 
     // 初始化 
    let NwRotationGestureRecognizer = UIRotationGestureRecognizer.init(target: self, action: #selector(rotationGestureClick(_ :))) 
    // 设置旋转的弧度 
    NwRotationGestureRecognizer.rotation = 2 
    // 添加手势 
    NwImageView.addGestureRecognizer(NwRotationGestureRecognizer) 
} 
// TODO : rotationGestureClick 旋转手势的触发 
func rotationGestureClick(_ rotationGesture:UIRotationGestureRecognizer) -> Void { 
    let rotationVelocity = rotationGesture.velocity 
    print(rotationVelocity) 
} 
```

## UIGestureRecognizerDelegate
```
// 手指触摸屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch; 
// 开始进行手势识别时调用的方法，返回NO则结束，不再触发手势 
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer; 
// 是否支持多时候触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer; 
// 下面这个两个方法也是用来控制手势的互斥执行的 
// 这个方法返回YES，第一个手势和第二个互斥时，第一个会失效 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0); 
// 这个方法返回YES，第一个和第二个互斥时，第二个会失效 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0); 


// MARK : 各个手势的代理事件 
// TODO : 控制是否允许手势的触发 
func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool { 
     return true 
} 

// TODO : 是否允许多个手势同时触发 
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { 
     return true 
} 

// TODO : 两个手势挥斥的时候，第一个失效，执行第二个 
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool { 
     return true 
} 

// TODO : 两个手势挥斥的时候，第一个执行，第二个失效 
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool { 
     return true 
} 

// TODO : 手指触摸屏幕，开始手势的识别 
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool { 
     return true 
} 

// TODO : 手指触摸屏幕，开始手势的识别 
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool { 
    return true 
} 

```

## 手势状态
```

typedef NS_ENUM(NSInteger, UIGestureRecognizerState) { 
  // 尚未识别是何种手势操作（但可能已经触发了触摸事件），默认状态 
       UIGestureRecognizerStatePossible,  
  // 手势已经开始，此时已经被识别，但是这个过程中可能发生变化，手势操作尚未完成 
       UIGestureRecognizerStateBegan,     
  // 手势状态发生转变 
       UIGestureRecognizerStateChanged, 
  // 手势识别操作完成（此时已经松开手指）    
       UIGestureRecognizerStateEnded,      
// 手势被取消，恢复到默认状态 
       UIGestureRecognizerStateCancelled,   
  // 手势识别失败，恢复到默认状态 
       UIGestureRecognizerStateFailed,    
// 手势识别完成，同UIGestureRecognizerStateEnded  
       UIGestureRecognizerStateRecognized  
       UIGestureRecognizerStateEnded  
}; 

```

## 手势属性
```
// 设置代理，具体的协议后面会说 
@property(nullable,nonatomic,weak) id <UIGestureRecognizerDelegate> delegate;  
// 设置手势是否有效 
@property(nonatomic, getter=isEnabled) BOOL enabled; 
// 获取手势所在的view 
@property(nullable, nonatomic,readonly) UIView *view;  
// 获取触发触摸的点 
-(CGPoint)locationInView:(nullable UIView*)view;  
// 设置触摸点数 
-(NSUInteger)numberOfTouches;  
// 获取某一个触摸点的触摸位置 
-(CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(nullable UIView*)view; 
// 这个方法中第一个参数是需要时效的手势，第二个是生效的手势。 
-(void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer; 
// 获取到的是手指移动后，在相对坐标中的偏移量 
-(CGPoint)translationInView:(nullable UIView *)view; 
```

