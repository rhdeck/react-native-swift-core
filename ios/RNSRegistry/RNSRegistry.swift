import Foundation
@objc(RNSRegistry)
class RNSRegistry: RCTEventEmitter {
    static var savedEventKeys:[String] = []
    override init() {
        super.init()
        RNSRegistry.savedEventKeys.forEach() { k in
            RNSMainRegistry.main.removeEvent(key: k)
        }
        RNSRegistry.savedEventKeys = []
    }
    @objc func setData(_ key: String, data: Any?, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        RNSMainRegistry.main.data[key] = data
        success(true)
    }
    @objc func removeData(_ key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        RNSMainRegistry.main.data.removeValue(forKey: key)
        success(true)
    }
    @objc func addEvent(_ type: String, key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        let k = RNSMainRegistry.main.addEvent(type: type, key: key) { data in
            self.sendEvent(withName: "RNSRegistry", body: ["type": type, "key": key, "data": data]);
            return true
        }
        RNSRegistry.savedEventKeys.append(k)
        success(true)
    }
    @objc func removeEvent(_ key: String, success: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        RNSMainRegistry.main.removeEvent(key: key)
        success(true)
    }
    override func supportedEvents() -> [String]! {
        return ["RNSRegistry"]
    }
    override class func requiresMainQueueSetup() -> Bool {
        return false;
    }
}
