```swift
func image(with data: Data, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage?
public func image(with data: Data, options: KingfisherOptionsInfo?) -> KFCrossPlatformImage? {
    return image(with: data, options: KingfisherParsedOptionsInfo(options))
}
```

/// 从提供的序列化数据中获取图像。

///

/// - 参数。

参数： /// - data: 图像应被反序列化的数据。

/// - options.选项：用于反序列化的解析选项。用于反序列化的解析选项。

/// - Returns: 反序列化的图像，如果没有有效的图像，则返回`nil`。

///可以反序列化。