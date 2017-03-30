import Foundation

/// Simple asynchronous operation.
public class AsyncOperation: NSOperation {
    
    public override var asynchronous: Bool {
        return true
    }
    
    private var _cancelled: Bool
    public override var cancelled: Bool {
        get { return _cancelled }
        set { update({ self._cancelled = newValue }, key: "isCancelled") }
    }
    
    private var _executing: Bool
    public override var executing: Bool {
        get { return _executing }
        set { update({ self._executing = newValue }, key: "isExecuting") }
    }
    
    private var _finished: Bool
    public override var finished: Bool {
        get { return _finished }
        set { update({ self._finished = newValue }, key: "isFinished") }
    }
    
    private var _ready: Bool
    public override var ready: Bool {
        get { return _ready }
        set { update({ self._ready = newValue }, key: "isReady") }
    }
    
    private func update(change: Void -> Void, key: String) {
        willChangeValueForKey(key)
        change()
        didChangeValueForKey(key)
    }
    
    public override init() {
        _ready = true
        _executing = false
        _finished = false
        _cancelled = false
        super.init()
        name = "AsyncOperation"
    }
    
    public override func start() {
        guard self.executing == true else { return }
        self.ready = false
        self.executing = true
        self.finished = false
        self.cancelled = false
        print("Did start \(self.dynamicType) operation.")
    }
    
    public func finish() {
        print("Did finish \(self.dynamicType) operation.")
        self.executing = false
        self.finished = true
    }
    
    public override func cancel() {
        print("Did cancel \(self.dynamicType) operation.")
        self.executing = false
        self.cancelled = true
    }
}
