import Foundation
public typealias cbtype = (Any) -> Bool
open class RNSMainRegistry {
    private  var events:[String: [String: cbtype]] = [:]
    public  var data: [String: Any] = [:]
    public static var main:RNSMainRegistry = RNSMainRegistry()
    public func addEvent(type:String, key:String, callback:cbtype) -> String {
        return key
    }
    public func addEvent(type: String, callback: cbtype) -> String {
        let key = UUID().uuidString
        return key
    }
    public func removeEvent(type: String, key: String) {
        events[type]?.removeValue(forKey: key)
    }
    func removeEvent(key: String) {
        events.forEach() { (arg) in
            self.removeEvent(type: arg.key, key: key)
        }
    }
    public func triggerEvent(_ type: String, data: Any) -> Bool {
        guard let es = events[type] else { return false }
        var ret:Bool = true
        es.forEach() { k, cb in
            if !ret { return }
            if !cb(data) { ret = false }
        }
        return ret
    }
}
