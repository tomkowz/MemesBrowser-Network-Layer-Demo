import UIKit

extension UIStoryboard {
    
    func get<A: UIViewController>(type: A.Type) -> A {
        return get(String(type)) as! A
    }
    
    func get(name: String) -> UIViewController {
        return instantiateViewControllerWithIdentifier(name)
    }

}

extension UIStoryboard {
    
    private static func sb() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static func getMemePreviewViewController() -> MemePreviewViewController! {
        return sb().get(MemePreviewViewController)
    }
}
