import Foundation

/// Storage with a cache of GET requests.
final class CacheStorage {
    static var shared: CacheStorage!
    
    private let baseUrl: NSURL
    
    init(baseUrl: NSURL) {
        self.baseUrl = baseUrl
        createDirectoryForBaseUrl()
    }
    
    private func createDirectoryForBaseUrl() {
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(baseUrl,
                                                                    withIntermediateDirectories: true,
                                                                    attributes: nil)
        } catch {
            print("Couldn't create directory for cache storage.")
        }
    }
    
    func store(data: NSData?, key: String) {
        if let data = data {
            data.writeToURL(urlForKey(key), atomically: true)
        } else {
            delete(key)
        }
    }
    
    func load(key: String) -> NSData? {
        return NSData(contentsOfURL: urlForKey(key))
    }
    
    func delete(key: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(urlForKey(key))
        } catch {
            print("Couldn't remove cache for key: \(key).")
        }
    }
    
    private func urlForKey(key: String) -> NSURL {
        return baseUrl.URLByAppendingPathComponent(key)!
    }
}
