import UIKit
import ReactNativeSwiftRegistry
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RCTBridgeDelegate {
  var ranAtStart = false
  #if DEBUG
   func InitializeFlipper(application: UIApplication) {
    guard let client = FlipperClient.shared() else { return }
    let layoutDescriptorMapper = SKDescriptorMapper()
    client.add(FlipperKitLayoutPlugin(rootNode: application, with: layoutDescriptorMapper))
    client.add(FKUserDefaultsPlugin(suiteName: nil))
    client.add(FlipperKitReactPlugin())
    client.add(FlipperKitNetworkPlugin(networkAdapter: SKIOSNetworkAdapter()))
  }
  #endif
  public func runAtStart() {
    //No guaranteed thread
    guard !ranAtStart else { return }
    ranAtStart = true
    let namespace = (Bundle.main.infoDictionary!["CFBundleExecutable"] as! String).replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: " ", with: "_")
    guard let classes = Bundle.main.infoDictionary!["RNSRClasses"] as? [String] else { return }
    classes.forEach() { c in
      if let cl  = NSClassFromString(c)  {
        cl.runOnStart?()
      } else {
        let fqn =  namespace + "." + c
        if let cl = NSClassFromString(fqn)  {
          cl.runOnStart?()
        }
      }
    }
  }
  var window: UIWindow?
  var cachedLaunchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil
  //MARK: Lifecycle Management
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    runAtStart()
    cachedLaunchOptions = launchOptions

    #if DEBUG
    InitializeFlipper(application: application);
    #endif
    let _ = RNSMainRegistry.triggerEvent(type: "app.didFinishLaunchingWithOptions.start", data: [:])
    let w = UIWindow(frame: UIScreen.main.bounds)
    let rvc = UIViewController()
    let bridge = RCTBridge(delegate: self, launchOptions: launchOptions)
    rvc.view = RCTRootView(bridge: bridge!, moduleName: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, initialProperties: nil)
    if #available(iOS 13.0, *) {
      rvc.view.backgroundColor = .systemBackground
    } else {
      rvc.view.backgroundColor = .white
    }
    w.rootViewController = rvc
    w.makeKeyAndVisible()
    self.window = w
    let _ = RNSMainRegistry.addEvent(type: "app.reset", key: "core") { data in
        DispatchQueue.main.async {
          let rvc = UIViewController()
          guard let bridge = RCTBridge(delegate: self, launchOptions: launchOptions) else { return }
          rvc.view = RCTRootView(bridge: bridge, moduleName: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, initialProperties: nil)
         if #available(iOS 13.0, *) {
            rvc.view.backgroundColor = .systemBackground
          } else {
            rvc.view.backgroundColor = .white
          }
          self.window?.rootViewController = rvc
        }
        return true
    }
    let _ = RNSMainRegistry.triggerEvent(type: "app.didFinishLaunchingWithOptions", data: launchOptions ?? [:])
    return true
  }
  func applicationWillResignActive(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.willresignactive", data: [:])
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.didenterbackground", data: [:])
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.willenterforeground", data: [:])
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.didbecomeactive", data: [:])
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    let _ = RNSMainRegistry.triggerEvent(type: "app.willterminate", data: [:])
  }
  //MARK:Shortcut Management
  public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    runAtStart()
    RNSMainRegistry.setData(key: "shortcuttriggered", value: shortcutItem.type)
    RNSMainRegistry.setData(key: shortcutItem.type, value: shortcutItem.userInfo ?? [:])
    let ret = RNSMainRegistry.triggerEvent(type: shortcutItem.type, data: shortcutItem.userInfo ?? [:])
      completionHandler(ret)
  }
  //MARK:URL Management
  public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    runAtStart()
    RNSMainRegistry.setData(key: "app.url", value:url)
    RNSMainRegistry.setData(key: "app.urlinfo", value: options)
    let ret = RNSMainRegistry.triggerEvent(type: "app.openedurl", data: url)
    return ret
  }
  //MARK:Notification Management
  public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    runAtStart()
    let _ = RNSMainRegistry.triggerEvent(type: "app.didRegisterForRemoteNotifications", data: deviceToken)
  }
  public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    runAtStart()
    let _ = RNSMainRegistry.triggerEvent(type: "app.didRegisterUserNotificationSettings", data: notificationSettings)
  }
  public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    runAtStart()
    let _ = RNSMainRegistry.triggerEvent(type: "app.didReceiveRemoteNotification", data: userInfo)
  }
  public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    runAtStart()
    let _ = RNSMainRegistry.triggerEvent(type: "app.didFailToRegisterForRemoteNotifications", data: error)
  }
  public func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    runAtStart()
    let _ = RNSMainRegistry.triggerEvent(type: "app.didReceiveLocalNotification", data: notification)
  }
  public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    runAtStart()
    let _ = RNSMainRegistry.triggerEvent(type: "app.handleEventsForBackgroundURLSession", data: ["identifier": identifier, "completionHandler": completionHandler])
  }
  func sourceURL(for bridge: RCTBridge!)->URL! {
    let tempLocation:URL?
    if(_isDebugAssertConfiguration()) {
      tempLocation = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
    } else {
      tempLocation = Bundle.main.url(forResource:"main", withExtension:"jsbundle")
    }
    RNSMainRegistry.setData(key: "sourceURL", value: tempLocation?.absoluteString ?? "")
    let _ = RNSMainRegistry.triggerEvent(type: "app.getSourceURL",data: ["bridge":bridge])
    let urlString = RNSMainRegistry.getData(key: "sourceURL") as? String
    return URL(string: urlString ?? "")
  }
}
//Helper to give the runOnStart hint for AnyClass
@objc(startable)
class startable:NSObject {
  @objc class func runOnStart() {}
}
