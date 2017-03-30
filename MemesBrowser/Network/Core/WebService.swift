import Foundation

/// Result of a WebService's attempt of accessing a resource.
enum Result<R: Resource> {
    
    /// Returns object that is associated with a Resource, or nil.
    case Success(R.A?)
    
    /// Returns error when resouce accessing did fail.
    case Failure(NSError)
}

protocol WebServiceProtocol {
    func load<R: Resource>(resource: R, result: (Result<R> -> Void)?)
    func cancel()
}

final class WebService: WebServiceProtocol {
    private var task: NSURLSessionDataTask?
    
    /// Access resource.
    func load<R: Resource>(resource: R, result: (Result<R> -> Void)?) {
        let req = WebServiceRequestBuilder.build(resource)
        req.allHTTPHeaderFields = resource.headers
        req.HTTPMethod = resource.method.rawValue
        
        print("Did start accessing \(resource.url.path!).")
        self.task = NSURLSession.sharedSession().dataTaskWithRequest(req, completionHandler: { data, response, error in
            
            guard let httpResponse = response as? NSHTTPURLResponse else {
                // Enters on "The internet connection appears to be offline." error.
                print("Did finish accessing \(resource.url.path!) with failure.")
                let theError = error ?? self.createDidNotHandleResponseCorrectlyError(0)
                result?(.Failure(theError))
                return
            }
            
            if (200..<299).contains(httpResponse.statusCode) {
                // Run parser, parse data, return it.
                print("Did finish accessing \(resource.url.path!) with success.")
                let parsed = data.flatMap(resource.parse)
                result?(.Success(parsed))
              
            } else {
                print("Did finish accessing \(resource.url.path!) with failure.")
                self.notifyAboutHTTPCode(httpResponse.statusCode)
                
                let theError = error ?? self.createDidNotHandleResponseCorrectlyError(httpResponse.statusCode)
                result?(.Failure(theError))
            }
        })
        
        task?.resume()
    }
    
    private func notifyAboutHTTPCode(code: Int) {
        // Post Notification with received error code to observers.
        WebServiceNotificationCenter.shared.postNotification(code)
    }
    
    /// Cancels accessing a resource.
    func cancel() {
        task?.cancel()
    }
}

private extension WebService {
    
    func createDidNotHandleResponseCorrectlyError(code: Int) -> NSError {
        let info = [
            NSLocalizedDescriptionKey: "Accessing resource failed with code \(code)",
            NSLocalizedFailureReasonErrorKey: "Wrong handling logic, wrong endpoing mapping, resource not available or backend bug."
        ]
        return NSError(domain: "WebService", code: code, userInfo: info)
    }
}
