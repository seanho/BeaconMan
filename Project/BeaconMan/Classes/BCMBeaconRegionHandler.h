@import Foundation;
@import CoreLocation;
#import "BCMBeaconNotification.h"

typedef void (^BCMBeaconRegionEnterBlock)(CLBeaconRegion *region);
typedef void (^BCMBeaconRegionExitBlock)(CLBeaconRegion *region);

@interface BCMBeaconRegionHandler : NSObject

@property (nonatomic, readonly) CLBeaconRegion *region;

- (id)initWithBeaconRegion:(CLBeaconRegion *)region enter:(BCMBeaconRegionEnterBlock)enter exit:(BCMBeaconRegionExitBlock)exit;
- (BOOL)matchesMajorAndMinor:(CLBeaconRegion *)region;

- (void)addNotification:(BCMBeaconNotification *)notification;

- (void)handleEnter:(CLLocationManager *)manager;
- (void)handleExit:(CLLocationManager *)manager delayAfter:(NSInteger)delayInSeconds;
- (void)handleRanging:(CLLocationManager *)manager beacon:(CLBeacon *)beacon;

@end
