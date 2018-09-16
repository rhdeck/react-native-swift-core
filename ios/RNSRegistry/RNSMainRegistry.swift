import Foundation
public typealias cbtype = (Any) -> Bool
var events:[String: [String: cbtype]] = [:]
var data:[String: Any]?
var q = DispatchQueue(label: "RNSQueue")
var savedData:[String: Any]?
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
            if(data == nil) { data = loadData()}
            data![key] = value
        }
    }
    public class func getData(key: String) -> Any? {
        return q.sync() {
            if(data == nil) { data = loadData()}
            return data![key]
        }
    }
    public class func removeData(key: String) {
        let _ = q.sync() {
            if(data == nil) { data = loadData()}
            data!.removeValue(forKey: key)
        }
    }
    public class func saveData(key: String, value: Any) {
        var d = loadData()
        d[key] = value
        savedData = d
        let _ = saveDataFile()
    }
    public class func removeSavedData(key: String) {
        var d = loadData()
        d.removeValue(forKey: key)
        savedData = d
        let _ = saveDataFile()
    }
    public class func flushData() {
        savedData = [:]
        saveDataFile()
    }
}
func getFileURL() -> URL {
    return try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.localDomainMask, appropriateFor: nil, create: true).appendingPathComponent("rnsmr.json")
}
func saveDataFile() -> Bool {
    guard let data = try? JSONSerialization.data(withJSONObject: loadData()) else { return false }
    guard let _ = try? data.write(to: getFileURL()) else { return false }
    return true
}
func loadData() -> [String:Any] {
    if let d = savedData { return d }
    let fileURL = getFileURL()
    guard
        FileManager.default.fileExists(atPath: fileURL.path),
        let data:Data = try? Data(contentsOf: fileURL),
        let d:[String:Any] = try? JSONSerialization.jsonObject(with: data) as! [String : Any]
    else { savedData = [:] ; return savedData! }
    savedData = d
    return d
}
