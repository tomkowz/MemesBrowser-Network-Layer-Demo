import Foundation

struct GetAllMemesInfoResource: Resource {
    
    var url: NSURL {
        return MemesBackend.shared.appendEndpoint("/memes")
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return jsonHeaders()
    }
    
    var parameters: [String : AnyObject]? {
        return nil
    }
    
    var behaviour: Behaviour {
        return .sendJSON
    }
    
    var parse: NSData -> [MemeInfoItem]? {
        return { d in (d.toJSON()?["memes"] as? [JSONDictionary])?.flatMap(MemeInfoItem.init) }
    }
}
