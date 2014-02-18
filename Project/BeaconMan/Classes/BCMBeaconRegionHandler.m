#import "BCMBeaconRegionHandler.h"

@interface BCMBeaconRegionHandler ()
@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic, copy) BCMBeaconRegionEnterBlock enter;
@property (nonatomic, copy) BCMBeaconRegionExitBlock exit;
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, strong) NSMutableArray *notificationsToRemove;
@property (nonatomic, readwrite) BOOL canStopRanging;
@end

@implementation BCMBeaconRegionHandler

- (id)initWithBeaconRegion:(CLBeaconRegion *)region enter:(BCMBeaconRegionEnterBlock)enter exit:(BCMBeaconRegionExitBlock)exit
{
    if (self = [super init])
    {
        _region = region;
        _enter = [enter copy];
        _exit = [exit copy];
        
        _notifications = [NSMutableArray array];
        _notificationsToRemove = [NSMutableArray array];
    }
    return self;
}

- (BOOL)matchesMajorAndMinor:(CLBeaconRegion *)region
{
    if (!self.region.major && !self.region.minor)
    {
        return YES;
    }
    else if (self.region.major && self.region.minor)
    {
        return [self.region.major isEqualToNumber:region.major] && [self.region.minor isEqualToNumber:region.minor];
    }
    else if (self.region.major)
    {
        return [self.region.major isEqualToNumber:region.major];
    }
    else
    {
        return [self.region.minor isEqualToNumber:region.minor];
    }
}

- (void)addNotification:(BCMBeaconNotification *)notification
{
    [self.notifications addObject:notification];
}

- (void)handleEnter:(CLLocationManager *)manager
{
    self.canStopRanging = NO;
    
    [self startRanging:manager];
}

- (void)handleExit:(CLLocationManager *)manager delayAfter:(NSInteger)delayInSeconds
{
    self.canStopRanging = YES;
    
    if (delayInSeconds > 0)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(stopRanging:) withObject:manager afterDelay:delayInSeconds];
    }
    else
    {
        [self stopRanging:manager];
    }
}

- (void)handleRanging:(CLLocationManager *)manager beacon:(CLBeacon *)beacon
{
    [self.notifications enumerateObjectsUsingBlock:^(BCMBeaconNotification *notification, NSUInteger idx, BOOL *stop) {
        [notification notifyIfNeeded:beacon];
        
        if (notification.notified && !notification.repeat)
        {
            [self.notificationsToRemove addObject:notification];
        }
    }];
    
    if (self.notificationsToRemove.count > 0)
    {
        [self.notifications removeObjectsInArray:self.notificationsToRemove];
        [self.notificationsToRemove removeAllObjects];
    }
}

#pragma mark - Private Methods

- (void)startRanging:(CLLocationManager *)manager
{
    if (![manager.rangedRegions containsObject:self.region])
    {
        [manager startRangingBeaconsInRegion:self.region];
        if (self.enter) self.enter(self.region);
    }
}

- (void)stopRanging:(CLLocationManager *)manager
{
    if ([manager.rangedRegions containsObject:self.region] && self.canStopRanging)
    {
        [manager stopRangingBeaconsInRegion:self.region];
        if (self.exit) self.exit(self.region);
        self.canStopRanging = NO;
    }
}

@end
