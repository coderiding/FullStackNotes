```swift
public func data(with image: KFCrossPlatformImage, original: Data?) -> Data? {
    if preferCacheOriginalData {
        return original ??
            image.kf.data(
                format: original?.kf.imageFormat ?? .unknown,
                compressionQuality: compressionQuality
            )
    } else {
        return image.kf.data(
            format: original?.kf.imageFormat ?? .unknown,
            compressionQuality: compressionQuality
        )
    }
}
```

/// - 参数。

/// - image: 需要序列化的图像。

/// - original：刚刚下载的原始数据。刚刚下载的原始数据。

/// 如果图像是从缓存中获取的，而不是从下载的数据中获取的。

///下载后，它将是`nil`。

/// - 返回。要存储到磁盘的数据对象，如果没有有效的数据对象，则返回`nil`。

///数据可以序列化。

///

/// - 注意。

/// 只有当 "original "包含有效的PNG、JPEG和GIF格式的数据时，"image "才会出现。

/// 转换为相应的数据类型。否则，如果提供了 "原件"，但它并不是：

/// 如果 "original "为 "nil"，输入的 "image "将被编码为PNG数据。