import Foundation

protocol WebServiceNotificationCenterDelegate: class {
    /// Notifies about new http code being returned.
    func webServiceDidReceiveErrorCode(code: Int)
}

/// The class is a notification center used to observe http codes (error) returned by
/// WebService's attempt of accessing a resource.
/// You can set easily set up observe and wait for e.g. 401 being received by the app.
final class WebServiceNotificationCenter {
    
    private class Observer {
        weak var observer: WebServiceNotificationCenterDelegate?
        
        init(observer: WebServiceNotificationCenterDelegate) {
            self.observer = observer
        }
    }
    
    static var shared: WebServiceNotificationCenter! = WebServiceNotificationCenter()

    private var observers = [Int: [Observer]]()
    
    /// Registers observer for specific http code.
    func addObserver(observer: WebServiceNotificationCenterDelegate, code: Int) {
        let wrappedObserver = Observer(observer: observer)
        if observers[code] == nil {
            observers[code] = [wrappedObserver]
        } else {
            observers[code]?.append(wrappedObserver)
        }
    }
    
    /// Removes the observer if found.
    func removeObserver(observer: WebServiceNotificationCenterDelegate) {
        for (code, wrappedObservers) in observers {
            var indexes = [Int]()
            var index = 0
            for wrappedObserver in wrappedObservers {
                if wrappedObserver.observer === observer ||
                    wrappedObserver.observer == nil {
                    indexes.append(index)
                    index += 1
                }
            }
            
            indexes.reverse().forEach({ observers[code]?.removeAtIndex($0) })
        }
    }
    
    /// Posts notification with specific http code.
    func postNotification(code: Int) {
        observers[code]?.forEach({ $0.observer?.webServiceDidReceiveErrorCode(code) })
    }
}
