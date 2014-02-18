#import "BCMBeaconManager.h"
#import "BCMBeaconRegionHandlerRegistry.h"

#define DEFAULT_STOP_RANGING_DELAY 15

@interface BCMBeaconManager ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) BCMBeaconRegionHandlerRegistry *handlerRegistry;
@end

@implementation BCMBeaconManager

+ (BCMBeaconManager *)defaultManager
{
    static BCMBeaconManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BCMBeaconManager alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        _handlerRegistry = [[BCMBeaconRegionHandlerRegistry alloc] init];
    }
    return self;
}

- (void)registerRegion:(CLBeaconRegion *)region enter:(BCMBeaconRegionEnterBlock)enter exit:(BCMBeaconRegionExitBlock)exit
{
    BCMBeaconRegionHandler *handler = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region enter:enter exit:exit];
    
    [self.handlerRegistry addHandler:handler];
    [self.locationManager startMonitoringForRegion:region];
}

- (void)unregisterRegion:(CLBeaconRegion *)region
{
    [self.locationManager stopMonitoringForRegion:region];
    [self.handlerRegistry removeHandlersForRegion:region];
}

- (void)notifyRegion:(CLBeaconRegion *)region repeat:(BOOL)repeat usingBlock:(BCMBeaconNotificationNotifyBlock)block
{
    BCMBeaconNotification *notification = [BCMBeaconNotification notificationWithNotify:block
                                                                               repeat:repeat
                                                                       usingPredicate:^BOOL(CLBeacon *beacon) {
                                                                           return beacon.proximity != CLProximityUnknown;
                                                                       }];
    [self addNotification:notification toHandlersInRegion:region];
}

- (void)notifyRegionImmediate:(CLBeaconRegion *)region repeat:(BOOL)repeat usingBlock:(BCMBeaconNotificationNotifyBlock)block
{
    BCMBeaconNotification *notification = [BCMBeaconNotification notificationWithNotify:block
                                                                               repeat:repeat
                                                                       usingPredicate:^BOOL(CLBeacon *beacon) {
                                                                           return beacon.proximity == CLProximityImmediate;
                                                                       }];
    [self addNotification:notification toHandlersInRegion:region];
}

- (void)notifyRegionNear:(CLBeaconRegion *)region repeat:(BOOL)repeat usingBlock:(BCMBeaconNotificationNotifyBlock)block
{
    BCMBeaconNotification *notification = [BCMBeaconNotification notificationWithNotify:block
                                                                               repeat:repeat
                                                                       usingPredicate:^BOOL(CLBeacon *beacon) {
                                                                           return beacon.proximity == CLProximityNear;
                                                                       }];
    [self addNotification:notification toHandlersInRegion:region];
}

- (void)notifyRegionFar:(CLBeaconRegion *)region repeat:(BOOL)repeat usingBlock:(BCMBeaconNotificationNotifyBlock)block
{
    BCMBeaconNotification *notification = [BCMBeaconNotification notificationWithNotify:block
                                                                               repeat:repeat
                                                                       usingPredicate:^BOOL(CLBeacon *beacon) {
                                                                           return beacon.proximity == CLProximityFar;
                                                                       }];
    [self addNotification:notification toHandlersInRegion:region];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        [self.handlerRegistry enumerateHandlersInRegion:(CLBeaconRegion *)region usingBlock:^(BCMBeaconRegionHandler *handler) {
            [handler handleEnter:manager];
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        [self.handlerRegistry enumerateHandlersInRegion:(CLBeaconRegion *)region usingBlock:^(BCMBeaconRegionHandler *handler) {
            [handler handleExit:manager delayAfter:DEFAULT_STOP_RANGING_DELAY];
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CLBeacon *beacon = [beacons lastObject];
    
    [self.handlerRegistry enumerateHandlersInRegion:(CLBeaconRegion *)region usingBlock:^(BCMBeaconRegionHandler *handler) {
        [handler handleRanging:manager beacon:beacon];
    }];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
}

#pragma mark - Private Methods

- (void)addNotification:(BCMBeaconNotification *)notification toHandlersInRegion:(CLBeaconRegion *)region
{
    [self.handlerRegistry enumerateHandlersInRegion:region usingBlock:^(BCMBeaconRegionHandler *handler) {
        [handler addNotification:notification];
    }];
}

@end
