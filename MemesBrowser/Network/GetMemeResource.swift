import Foundation

struct GetMemeResource: Resource {
    let fileName: String
    
    var url: NSURL {
        return MemesBackend.shared.appendEndpoint("/\(fileName)")
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String : AnyObject]? {
        return nil
    }
    
    var behaviour: Behaviour {
        return .sendJSON
    }
    
    var parse: NSData -> NSData? {
        return parseData()
    }
}
