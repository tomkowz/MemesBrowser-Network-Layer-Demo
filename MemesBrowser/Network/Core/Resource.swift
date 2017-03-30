import Foundation

typealias JSONDictionary = [String: AnyObject]

/// Protocol that represents an endpoint.
protocol Resource: ResourceDescriptor {
    associatedtype A
    /// Parses response data and return Optional(A).
    var parse: NSData -> A? { get }
}

/// Available HTTP methods for a resource.
enum HTTPMethod: String {
    case get, post, put, delete
}

/// Represents behaviour of a resource, specifically how request should 
/// be build and how parameters should be encoded.
/// It is used in `WebServiceRequestBuilder`.
enum Behaviour {
    /// Body of a request will be a `NSData`.
    case sendFile
    
    /// Sends `JSONDictionary`. Fine to be default even if no params in the request.
    case sendJSON
    
    /// Encodes parameters into url, like normal parametrized GET.
    case encodedGet
}

/// Represents couple of properties that are used to build a network request.
protocol ResourceDescriptor {
    /// Full url of the endpoint.
    var url: NSURL { get }
    
    /// Headers set for the request.
    var headers: [String: String]? { get }
    
    /// Method of the request.
    var method: HTTPMethod { get }
    
    /// Parameters set for the request.
    var parameters: [String: AnyObject]? { get }
    
    /// Behaviour of the request (parameters encoding).
    var behaviour: Behaviour { get }
}

/// JSON Support
extension Resource {
    
    /// Basic JSON headers. You can use it if you set `Request.behaviour` to `.sendJSON`.
    func jsonHeaders() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
}

/// Parsing Support
extension Resource {
    
    /// Simple "parser" that just return data it gets.
    func parseData() -> (NSData -> NSData?) {
        return { data in data }
    }
    
    /// Simple "parser" that always return nil.
    /// You want to use this if you're not expecting anything to be returned 
    /// and generic type is `Void?`.
    func doNotParse() -> (NSData -> A?) {
        return { data in nil }
    }
}
