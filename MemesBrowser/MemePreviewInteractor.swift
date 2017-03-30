import UIKit

final class MemePreviewInteractor {
    
    func getMeme(fileName: String, completion: (UIImage? -> Void)) {
        WebService().cached().repeated().load(GetMemeResource(fileName: fileName), result: { result in
            var image: UIImage? = nil
            switch result {
            case .Success(let data):
                if let data = data {
                    image = UIImage(data: data)
                }
                
            case .Failure(let error):
                print("Did fail loading single meme. Error: \(error.localizedDescription).")
            }
            
            completion(image)
        })
    }
}
