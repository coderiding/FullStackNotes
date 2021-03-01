// 创建存储文件夹。

```swift
// Creates the storage folder.
func prepareDirectory() throws {
    let fileManager = config.fileManager
    let path = directoryURL.path
    guard !fileManager.fileExists(atPath: path) else { return }
    do {
        try fileManager.createDirectory(
            atPath: path,
            withIntermediateDirectories: true,
            attributes: nil)
    } catch {
        throw KingfisherError.cacheError(reason: .cannotCreateDirectory(path: path, error: error))
    }
}
```