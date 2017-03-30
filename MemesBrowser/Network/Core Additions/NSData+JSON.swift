import Foundation

/// Useful extension for implementing Resource's `parse` property.
extension NSData {
    
    func toJSON() -> JSONDictionary? {
        let converted = try? NSJSONSerialization.JSONObjectWithData(self, options: [])
        return converted as? JSONDictionary
    }
    
    func toJSONArray() -> [JSONDictionary]? {
        let converted = try? NSJSONSerialization.JSONObjectWithData(self, options: [])
        return converted as? [JSONDictionary]
    }
}
