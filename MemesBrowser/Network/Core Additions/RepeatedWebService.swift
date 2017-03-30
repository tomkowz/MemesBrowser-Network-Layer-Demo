import Foundation

/** 
 A WebService that supports repeatition of accessing a resource.
 By specifying `maxAttempts` you can tell how many times the request can
 be repeated when failed.
 */
final class RepeatedWebService: WebServiceProtocol {
    private var currentAttempt: Int
    private let maxAttempts: Int
    private let webService: WebServiceProtocol
    
    init(webService: WebServiceProtocol, maxAttempts: Int) {
        self.webService = webService
        self.maxAttempts = maxAttempts
        self.currentAttempt = 0
    }
    
    func load<R: Resource>(resource: R, result: (Result<R> -> Void)?) {
        // Increment current attempt indicator
        currentAttempt += 1
        print("Did start \(currentAttempt) attempt of accessing \(resource.dynamicType) resource.")
        
        webService.load(resource, result: { currentResult in
            switch currentResult {
            case .Success(_):
                // Report success
                result?(currentResult)
                
            case .Failure(_):
                print("Did fail \(self.currentAttempt) attempt of accessing \(resource.dynamicType) resource.")
                // If that's not the last attempt, repeat the request,
                // otherwise report failure
                if self.currentAttempt < self.maxAttempts {
                    self.load(resource, result: result)
                } else {
                    result?(currentResult)
                }
            }
        })
    }
    
    func cancel() {
        webService.cancel()
    }
}

extension WebServiceProtocol {
    
    // Convenience method to create repeatable web service.
    func repeated(maxAttempts: Int = 3) -> RepeatedWebService {
        return RepeatedWebService(webService: self, maxAttempts: maxAttempts)
    }
}
