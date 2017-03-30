import Foundation

/**
 WebService that provides cache functionality. Every get request is getting 
 cached on disk. In order to make it work you need to configure `CacheStorage`
 first. Otherwise results will not be cached.
 */
final class CachedWebService: WebServiceProtocol {
    private let webService: WebServiceProtocol
    
    init(webService: WebServiceProtocol) {
        self.webService = webService
    }
    
    func load<R : Resource>(resource: R, result: (Result<R> -> Void)?) {
        guard CacheStorage.shared != nil && resource.method == .get else {
            // Access the resource as usual.
            webService.load(resource, result: result)
            return
        }
        
        let cacheKey = resource.url.path!.stringByReplacingOccurrencesOfString("/", withString: "-")
        
        // Load from cache only if this is GET request.
        if let data = CacheStorage.shared.load(cacheKey) {
            if let cache = resource.parse(data) {
                print("Did access cached data for \(resource.url.path!) resource.")
                result?(.Success(cache))
            }
        }
        
        // Create resource with the same parameters as the original one
        // but it will return data instead of the type of object
        // specified in original resource.
        // This data will be used for caching.
        let cachedResource = CacheResource(url: resource.url,
                                           headers: resource.headers,
                                           parameters: resource.parameters,
                                           method: resource.method,
                                           behaviour: resource.behaviour)
        
        // Load the cached resource, get result data, store it and convert
        // to the final type the resource expects.
        webService.load(cachedResource, result: { cachedResult in
            switch cachedResult {
            case .Success(let cachedData):
                // Cache new data
                CacheStorage.shared.store(cachedData, key: cacheKey)
                print("Did download and cached new data for \(resource.url.path!) resource.")
                // Notify about the success
                result?(.Success(resource.parse(cachedData!)))
                
            case .Failure(let error):
                result?(.Failure(error))
            }
        })
    }
    
    func cancel() {
        webService.cancel()
    }
}

extension WebServiceProtocol {
    
    func cached() -> CachedWebService {
        return CachedWebService(webService: self)
    }
}

private struct CacheResource: Resource {
    
    var url: NSURL
    var headers: [String : String]?
    var parameters: [String : AnyObject]?
    var method: HTTPMethod
    var behaviour: Behaviour
    var parse: NSData -> NSData?
    
    init(url: NSURL,
         headers: [String: String]?,
         parameters: [String: AnyObject]?,
         method: HTTPMethod,
         behaviour: Behaviour) {
        
        self.url = url
        self.headers = headers
        self.parameters = parameters
        self.method = method
        self.behaviour = behaviour
        self.parse = { d in d }
    }
}
