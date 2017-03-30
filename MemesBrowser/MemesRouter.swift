import UIKit

final class MemesRouter: Router {
    
    func presentPreview(fileName: String, title: String) {
        let input = MemePreviewInput(fileName: fileName, title: title)
        let vc = UIStoryboard.getMemePreviewViewController()
        vc.input = input
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
}
