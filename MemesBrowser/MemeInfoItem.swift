import Foundation

struct MemeInfoItem {
    let fileName: String
}

extension MemeInfoItem {
    
    init?(json: JSONDictionary) {
        guard let fileName = json["filename"] as? String else { return nil }
        self.fileName = fileName
    }
}

extension MemeInfoItem {
    
    func toJSON() -> JSONDictionary {
        return ["filename": fileName]
    }
}
