```swift
public var preferCacheOriginalData: Bool = false
```

/// 在序列化图像时是否应该优先使用原始数据。

/// 如果 "true"，将首先检查并使用输入的原始数据，除非数据为 "nil"。

/// 在这种情况下，序列化将回到从图像创建数据。