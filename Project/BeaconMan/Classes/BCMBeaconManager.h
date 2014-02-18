@import Foundation;
@import CoreLocation;
#import "BCMBeaconRegionHandler.h"
#import "BCMBeaconNotification.h"

@interface BCMBeaconManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, readonly) CLLocationManager *locationManager;

+ (BCMBeaconManager *)defaultManager;

- (void)registerRegion:(CLBeaconRegion *)region enter:(BCMBeaconRegionEnterBlock)enter exit:(BCMBeaconRegionExitBlock)exit;
- (void)unregisterRegion:(CLBeaconRegion *)region;

- (void)notifyRegion:(CLBeaconRegion *)region repeat:(BOOL)repeat usingBlock:(BCMBeaconNotificationNotifyBlock)block;
- (void)notifyRegionImmediate:(CLBeaconRegion *)region repeat:(BOOL)repeat usingBlock:(BCMBeaconNotificationNotifyBlock)block;
- (void)notifyRegionNear:(CLBeaconRegion *)region repeat:(BOOL)repeat usingBlock:(BCMBeaconNotificationNotifyBlock)block;
- (void)notifyRegionFar:(CLBeaconRegion *)region repeat:(BOOL)repeat usingBlock:(BCMBeaconNotificationNotifyBlock)block;

@end
