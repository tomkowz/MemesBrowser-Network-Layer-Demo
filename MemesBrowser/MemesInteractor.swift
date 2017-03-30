import Foundation

final class MemesInteractor {
    
    func getMemes(completion: ([MemeInfoItem] -> Void)) {
        WebService().cached().repeated().load(GetAllMemesInfoResource(), result: { result in
            var items = [MemeInfoItem]()
            switch result {
            case .Success(let memeInfoItems):
                items = memeInfoItems ?? items
            case .Failure(let error):
                print("Did fail loading list of memes. Error: \(error.localizedDescription).")
            }
            
            completion(items)
        })
    }    
}
