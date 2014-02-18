@import Foundation;
@import CoreLocation;

typedef void (^BCMBeaconNotificationNotifyBlock)(CLBeacon *beacon);
typedef BOOL (^BCMBeaconNotificationPredicateBlock)(CLBeacon *beacon);

@interface BCMBeaconNotification : NSObject

@property (nonatomic, copy) BCMBeaconNotificationNotifyBlock notify;
@property (nonatomic, copy) BCMBeaconNotificationPredicateBlock predicate;
@property (nonatomic, readwrite) BOOL repeat;
@property (nonatomic, readonly) BOOL notified;

+ (BCMBeaconNotification *)notificationWithNotify:(BCMBeaconNotificationNotifyBlock)notify repeat:(BOOL)repeat usingPredicate:(BCMBeaconNotificationPredicateBlock)predicate;
- (void)notifyIfNeeded:(CLBeacon *)beacon;

@end
