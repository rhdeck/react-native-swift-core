import Foundation
@objc(RNSRegistry)
class RNSRegistry: RCTEventEmitter {
    static var savedEventKeys:[String] = []
    override init() {
        super.init()
        if RNSRegistry.savedEventKeys.count > 0 {
                RNSRegistry.savedEventKeys.forEach() { k in
                RNSMainRegistry.removeEvent(key: k)
            }
        }
        RNSRegistry.savedEventKeys = []
    }
    @objc func setData(_ key: String, data: Any?, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        if let d = data {
            RNSMainRegistry.setData(key: key, value: d)
        } else {
            RNSMainRegistry.removeData(key: key)
        }
        success(true)
    }
    @objc func removeData(_ key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        RNSMainRegistry.removeData(key: key)
        success(true)
    }
    @objc func getData(_ key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        guard let ret = RNSMainRegistry.getData(key: key) else { reject("no_data", "No data at key " + key, nil); return }
        success(ret)
    }
    @objc func addEvent(_ type: String, key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        let k = RNSMainRegistry.addEvent(type: type, key: key) { data in
            self.sendEvent(withName: "RNSRegistry", body: ["type": type, "key": key, "data": data]);
            return true
        }
        RNSRegistry.savedEventKeys.append(k)
        success(true)
    }
    @objc func removeEvent(_ key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        RNSMainRegistry.removeEvent(key: key)
        success(true)
    }
    override func supportedEvents() -> [String]! {
        return ["RNSRegistry"]
    }
    override class func requiresMainQueueSetup() -> Bool {
        return true;
    }
}
