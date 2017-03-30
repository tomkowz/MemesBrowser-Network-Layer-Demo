import Foundation

final class MemesBackend: BackendConfiguration {
    static var shared: MemesBackend!
    
    private (set) var baseUrl: NSURL
    var defaults: NSUserDefaults
    
    init(defaults: NSUserDefaults) {
        self.baseUrl = NSURL(string: "http://213.32.69.32/m/api")!
        self.defaults = defaults
    }
}
