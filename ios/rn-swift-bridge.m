#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>
@interface RCT_EXTERN_MODULE(RNSRegistry, RCTEventEmitter)
RCT_EXTERN_METHOD(setData:(NSString *)key data:(Any *)data success:(RCTPromiseResolveBlock)success reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(removeData:(NSString *)key success:(RCTPromiseResolveBlock)success reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(getData:(NSString *)key success:(RCTPromiseResolveBlock)success reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(addEvent:(NSString *)type key:(NSString *)key success:(RCTPromiseResolveBlock)success reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(removeEvent:(NSString *)key success:(RCTPromiseResolveBlock)success reject:(RCTPromiseRejectBlock)reject);
@end