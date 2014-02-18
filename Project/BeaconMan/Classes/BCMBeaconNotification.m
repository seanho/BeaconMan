#import "BCMBeaconNotification.h"

@interface BCMBeaconNotification ()
@property (nonatomic, readwrite) BOOL notified;
@property (nonatomic, strong) NSDate *notifiedAt;
@end

@implementation BCMBeaconNotification

+ (BCMBeaconNotification *)notificationWithNotify:(BCMBeaconNotificationNotifyBlock)notify usingPredicate:(BCMBeaconNotificationPredicateBlock)predicate
{
    BCMBeaconNotification *notification = [[BCMBeaconNotification alloc] init];
    notification.notify = notify;
    notification.predicate = predicate;
    return notification;
}

- (void)notifyIfNeeded:(CLBeacon *)beacon
{
    if (self.repeat || !self.notified)
    {
        if (self.predicate && !self.predicate(beacon)) return;
        if (self.interval > 0.0f && self.notifiedAt && [self.notifiedAt timeIntervalSinceNow] > -self.interval) return;
        
        if (self.notify)
        {
            self.notified = YES;
            self.notifiedAt = [NSDate date];
            self.notify(beacon);
        }
    }
}

@end
