#import "BCMBeaconNotification.h"

@interface BCMBeaconNotification ()
@property (nonatomic, readwrite) BOOL notified;
@end

@implementation BCMBeaconNotification

+ (BCMBeaconNotification *)notificationWithNotify:(BCMBeaconNotificationNotifyBlock)notify repeat:(BOOL)repeat usingPredicate:(BCMBeaconNotificationPredicateBlock)predicate
{
    BCMBeaconNotification *notification = [[BCMBeaconNotification alloc] init];
    notification.notify = notify;
    notification.repeat = repeat;
    notification.predicate = predicate;
    return notification;
}

- (void)notifyIfNeeded:(CLBeacon *)beacon
{
    if (self.repeat || !self.notified)
    {
        if (self.predicate && !self.predicate(beacon)) return;
        if (self.notify)
        {
            self.notify(beacon);
            self.notified = YES;
        }
    }
}

@end
