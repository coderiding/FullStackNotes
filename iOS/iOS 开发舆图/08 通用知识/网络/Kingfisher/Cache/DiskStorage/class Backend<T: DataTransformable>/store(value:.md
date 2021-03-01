```swift
func store(
            value: T,
            forKey key: String,
            expiration: StorageExpiration? = nil) throws
        {
            let expiration = expiration ?? config.expiration
            // The expiration indicates that already expired, no need to store.
            guard !expiration.isExpired else { return }
            
            let data: Data
            do {
                data = try value.toData()
            } catch {
                throw KingfisherError.cacheError(reason: .cannotConvertToData(object: value, error: error))
            }
            let fileURL = cacheFileURL(forKey: key)
            do {
                try data.write(to: fileURL)
            } catch {
                throw KingfisherError.cacheError(
                    reason: .cannotCreateCacheFile(fileURL: fileURL, key: key, data: data, error: error)
                )
            }
            let now = Date()
            let attributes: [FileAttributeKey : Any] = [
                // The last access date.
                .creationDate: now.fileAttributeDate,
                // The estimated expiration date.
                .modificationDate: expiration.estimatedExpirationSinceNow.fileAttributeDate
            ]
            do {
                try config.fileManager.setAttributes(attributes, ofItemAtPath: fileURL.path)
            } catch {
                try? config.fileManager.removeItem(at: fileURL)
                throw KingfisherError.cacheError(
                    reason: .cannotSetCacheFileAttribute(
                        filePath: fileURL.path,
                        attributes: attributes,
                        error: error
                    )
                )
            }
            maybeCachedCheckingQueue.async {
                self.maybeCached?.insert(fileURL.lastPathComponent)
            }
        }
```