```swift
public init(config: Config) throws {
        self.config = config
        let url: URL
        if let directory = config.directory {
            url = directory
        } else {
            url = try config.fileManager.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
        }
        let cacheName = "com.onevcat.Kingfisher.ImageCache.\(config.name)"
        directoryURL = config.cachePathBlock(url, cacheName)
        metaChangingQueue = DispatchQueue(label: cacheName)
        try prepareDirectory()
        maybeCachedCheckingQueue.async {
            do {
                self.maybeCached = Set()
                try config.fileManager.contentsOfDirectory(atPath: self.directoryURL.path).forEach { fileName in
                    self.maybeCached?.insert(fileName)
                }
            } catch {
                // Just disable the functionality if we fail to initialize it properly. This will just revert to
                // the behavior which is to check file existence on disk directly.
                self.maybeCached = nil
            }
        }
    }
```