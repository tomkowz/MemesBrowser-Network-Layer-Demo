import Foundation

/// Represents a backend object with basic attributes.
protocol BackendConfiguration {
    static var shared: Self! { get set }
    
    /// Base url of the backend's API.
    var baseUrl: NSURL { get }
    
    /// Used for storing e.g. authorization token if any.
    var defaults: NSUserDefaults { get }
}

/// Resource Building Support
extension BackendConfiguration {
    
    /// Creates new url. baseUrl + /endpoint
    func appendEndpoint(endpoint: String) -> NSURL {
        return self.baseUrl.URLByAppendingPathComponent(endpoint)!
    }
}

/// Auth Token Support
extension BackendConfiguration {
    
    func authToken() -> String? {
        return defaults.valueForKey(authTokenKey()) as? String
    }
    
    func setAuthToken(token: String) {
        defaults.setValue(token, forKey: authTokenKey())
        print("Did set authentication token to: \(token).")
    }
    
    func deleteAuthToken() {
        defaults.removeObjectForKey(authTokenKey())
        print("Did delete authentication token.")
    }
    
    private func authTokenKey() -> String {
        return "\(self.dynamicType)_AuthTokenKey"
    }
}
