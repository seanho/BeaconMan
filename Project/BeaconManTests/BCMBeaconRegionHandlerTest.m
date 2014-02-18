#import <Kiwi/Kiwi.h>
#import "BCMBeaconRegionHandler.h"

SPEC_BEGIN(BCMBeaconRegionHandlerTest)

describe(@"BCMBeaconRegionHandler", ^{
    describe(@"matchesMajorAndMinor", ^{
        __block CLBeaconRegion *region;
        __block CLBeaconRegion *regionWithMajor;
        __block CLBeaconRegion *regionWithMajorMinor;
        __block BCMBeaconRegionHandler *handler;
        __block BCMBeaconRegionHandler *handlerWithMajor;
        __block BCMBeaconRegionHandler *handlerWithMajorMinor;
        
        beforeEach(^{
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"];
            
            region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Test"];
            regionWithMajor = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 identifier:@"Test"];
            regionWithMajorMinor = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:25 identifier:@"Test"];
            
            handler = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region enter:nil exit:nil];
            handlerWithMajor = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:regionWithMajor enter:nil exit:nil];
            handlerWithMajorMinor = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:regionWithMajorMinor enter:nil exit:nil];
        });
        
        it(@"should match region with only UUID", ^{
            [[theValue([handler matchesMajorAndMinor:region]) should] beYes];
            [[theValue([handlerWithMajor matchesMajorAndMinor:region]) should] beNo];
            [[theValue([handlerWithMajorMinor matchesMajorAndMinor:region]) should] beNo];
        });
        
        it(@"should match region with UUID and Major", ^{
            [[theValue([handler matchesMajorAndMinor:regionWithMajor]) should] beYes];
            [[theValue([handlerWithMajor matchesMajorAndMinor:regionWithMajor]) should] beYes];
            [[theValue([handlerWithMajorMinor matchesMajorAndMinor:regionWithMajor]) should] beNo];
        });
        
        it(@"should match region with UUID, Major and Minor", ^{
            [[theValue([handler matchesMajorAndMinor:regionWithMajorMinor]) should] beYes];
            [[theValue([handlerWithMajor matchesMajorAndMinor:regionWithMajorMinor]) should] beYes];
            [[theValue([handlerWithMajorMinor matchesMajorAndMinor:regionWithMajorMinor]) should] beYes];
        });
    });
});

SPEC_END