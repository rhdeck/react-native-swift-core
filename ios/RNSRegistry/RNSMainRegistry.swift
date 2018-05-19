import Foundation
public typealias cbtype = (Any) -> Bool
open class RNSMainRegistry {
    private  var events:[String: [String: cbtype]] = [:]
    public  var data: [String: Any] = [:]
     private  static var main:RNSMainRegistry?
    init() {
        print("Making a new rnsregistry.main")
    }
    public static func getMain() -> RNSMainRegistry {
        if let m = RNSMainRegistry.main { return m }
        RNSMainRegistry.main = RNSMainRegistry()
        return RNSMainRegistry.main!
    }
    public func addEvent(type:String, key:String, callback:@escaping cbtype) -> String {
        if events[type] == nil { events[type] = [:] }
        events[type]?[key] = callback
        return key
    }
    public func addEvent(type: String, callback: @escaping cbtype) -> String {
        let key = UUID().uuidString
        return addEvent(type:type, key: key, callback: callback)
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
        print("Triggerevent:" + type)
        //print(events)
        guard let es = events[type] else { return false }
        var ret:Bool = true
        es.forEach() { k, cb in
            if !ret { return }
            if !cb(data) { ret = false }
        }
        print("Finished triggerevent" + type)
        return ret
    }
}
