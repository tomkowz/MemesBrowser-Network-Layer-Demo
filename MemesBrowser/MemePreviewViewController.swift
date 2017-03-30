import UIKit

final class MemePreviewViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var spinner: UIActivityIndicatorView!
    @IBOutlet private var messageLabel: UILabel!
    
    var input: MemePreviewInput!
    
    private let interactor = MemePreviewInteractor()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = input.title
        messageLabel.text = ""
        spinner.startAnimating()
        
        interactor.getMeme(input.fileName, completion: { [weak self] image in
            dispatch_async(dispatch_get_main_queue()) {
                self?.spinner.stopAnimating()
                self?.imageView.image = image
                
                if image == nil {
                    self?.messageLabel.text = "Couldn't access image."
                }
            }
        })
    }
}
