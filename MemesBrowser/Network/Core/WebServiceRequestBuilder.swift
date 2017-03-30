import Foundation

final class WebServiceRequestBuilder {
    
    /// Creates request that contains query params.
    static func build<R: Resource>(resource: R) -> NSMutableURLRequest {
        
        // Set default parameters for a request
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        let timeoutInterval = 3.0
        
        switch resource.behaviour {
        case .sendFile:
            let request = NSMutableURLRequest(URL: resource.url)
            request.HTTPBody = resource.parameters?["data"] as? NSData
            return request
            
        case .sendJSON:
            let request = NSMutableURLRequest(URL: resource.url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
            if let params = resource.parameters {
                request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
            }
            return request
            
        case .encodedGet:
            let components = NSURLComponents(URL: resource.url, resolvingAgainstBaseURL: true)!
            
            if let params = resource.parameters {
                var query = ""
                
                params.forEach { key, value in
                    query = query + key + "=" + "\(value)" + "&"
                }
                
                components.query = query
            }
            
            return NSMutableURLRequest(URL: resource.url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        }
    }
}
