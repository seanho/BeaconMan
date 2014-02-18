@import Foundation;
#import "BCMBeaconRegionHandler.h"

@interface BCMBeaconRegionHandlerRegistry : NSObject

- (void)addHandler:(BCMBeaconRegionHandler *)handler;
- (void)removeHandlersForRegion:(CLBeaconRegion *)region;
- (NSArray *)handlersForRegion:(CLBeaconRegion *)region;
- (void)enumerateHandlersInRegion:(CLBeaconRegion *)region usingBlock:(void(^)(BCMBeaconRegionHandler *handler))block;

@end
