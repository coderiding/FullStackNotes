```swift
public func image(with data: Data, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
    return KingfisherWrapper.image(data: data, options: options.imageCreatingOptions)
}
```

/// 从提供的数据中获取反序列化的图像。

///

/// - 参数。

参数： /// - data: 图像应被反序列化的数据。

/// - options: 反序列化的选项。选项：反序列化的选项。

/// - 返回：反序列化的图像，如果没有有效的图像，则返回 "nil"。反序列化的图像，如果没有有效的图像，则返回`nil`。

///可以反序列化。