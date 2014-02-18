#import <Kiwi/Kiwi.h>
#import "BCMBeaconNotification.h"

SPEC_BEGIN(BCMBeaconNotificationTest)

describe(@"BCMBeaconRegionHandlerRegistry", ^{
    describe(@"notifyIfNeeded", ^{
        __block BCMBeaconNotification *notification;
        __block CLBeacon *beacon;
        __block NSUInteger notifyCounter;
        
        beforeEach(^{
            beacon = [CLBeacon mock];
            notifyCounter = 0;
            
            notification = [[BCMBeaconNotification alloc] init];
            notification.notify = ^(CLBeacon *beacon){
                notifyCounter++;
            };
        });
        
        it(@"should notify repeatedly if repeat flag is true", ^{
            notification.repeat = YES;
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(1)];
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(2)];
        });
        
        it(@"should notify only once if repeat flag is false", ^{
            notification.repeat = NO;
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(1)];
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(1)];
        });
        
        it(@"should notify if predicate pass", ^{
            notification.predicate = ^(CLBeacon *beacon) {
                return YES;
            };
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(1)];
        });
        
        it(@"should not notify if predicate fail", ^{
            notification.predicate = ^(CLBeacon *beacon) {
                return NO;
            };
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(0)];
        });
        
        it(@"should notify only once within time interval", ^{
            notification.interval = 1;
            notification.repeat = YES;
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(1)];
            
            [NSThread sleepForTimeInterval:2.0];
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(2)];
        });
        
        it(@"should notify only once within time interval", ^{
            notification.interval = 10;
            notification.repeat = YES;
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(1)];
            
            [notification notifyIfNeeded:beacon];
            
            [[theValue(notifyCounter) should] equal:theValue(1)];
        });
    });
});

SPEC_END