#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface RNLocationChange : RCTEventEmitter <RCTBridgeModule, CLLocationManagerDelegate>

@end
