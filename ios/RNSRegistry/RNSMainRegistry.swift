import Foundation
public typealias cbtype = (Any) -> Bool
var events:[String: [String: cbtype]] = [:]
var data:[String: Any] = [:]
var q = DispatchQueue(label: "RNSQueue")
open class RNSMainRegistry {
    public class func addEvent(type: String, key: String, callback: @escaping cbtype) -> String {
        q.sync() {
            if events[type] == nil { events[type] = [:] }
            events[type]?[key] = callback
        }
        return key
    }
    public class func removeEvent(type: String, key: String) {
        let _ = q.sync() {
            events[type]?.removeValue(forKey: key)
        }
    }
    public class func removeEvent(key: String) {
        let _ = q.sync() {
            events.keys.forEach() { k in
                events[k]?.removeValue(forKey: key)
            }
        }
    }
    public class func removeEvents(type: String) {
        let _ = q.sync() {
            guard let e = events[type] else { return }
            e.keys.forEach() { k in
                events[type]?.removeValue(forKey: k)
            }
            events[type] = nil
        }
    }
    public class func triggerEvent(type: String, data: Any) -> Bool {
        return q.sync() {
            guard let es = events[type] else { return false }
            for thisKey:String in es.keys {
                guard let cb = es[thisKey] else { continue }
                if !cb(data) { return false }
            }
            return true
        }
    }
    public class func setData(key: String, value: Any) {
        let _ = q.sync() {
            data[key] = value
        }
    }
    public class func getData(key: String) -> Any? {
        return q.sync() {
            return data[key]
        }
    }
    public class func removeData(key: String) {
        let _ = q.sync() {
            data.removeValue(forKey: key)
        }
    }
}
