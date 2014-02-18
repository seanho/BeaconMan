#import <Kiwi/Kiwi.h>
#import "BCMBeaconRegionHandler.h"
#import "BCMBeaconRegionHandlerRegistry.h"

SPEC_BEGIN(BCMBeaconRegionHandlerRegistryTest)

describe(@"BCMBeaconRegionHandlerRegistry", ^{
    __block BCMBeaconRegionHandlerRegistry *registry;
    
    beforeEach(^{
        registry = [[BCMBeaconRegionHandlerRegistry alloc] init];
    });
    
    describe(@"addHandler", ^{
        it(@"should add handler by region", ^{
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"];
            CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Test"];
            
            BCMBeaconRegionHandler *handler = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region enter:nil exit:nil];

            [registry addHandler:handler];
            
            [[[registry handlersForRegion:region] should] contain:handler];
        });
        
        it(@"should add multiple handlers by region", ^{
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"];
            CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Test"];
            
            BCMBeaconRegionHandler *handler1 = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region enter:nil exit:nil];
            BCMBeaconRegionHandler *handler2 = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region enter:nil exit:nil];
            
            [registry addHandler:handler1];
            [registry addHandler:handler2];
            
            [[[registry handlersForRegion:region] should] containObjects:handler1, handler2, nil];
        });
    });
    
    describe(@"removeHandlersForRegion", ^{
        it(@"should remove all handlers for region", ^{
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"];
            CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Test"];
            
            BCMBeaconRegionHandler *handler1 = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region enter:nil exit:nil];
            BCMBeaconRegionHandler *handler2 = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region enter:nil exit:nil];
            
            [registry addHandler:handler1];
            [registry addHandler:handler2];
            
            [registry removeHandlersForRegion:region];
            [[[registry handlersForRegion:region] should] beEmpty];
        });
        
        it(@"should not remove handler for different region", ^{
            NSUUID *uuid1 = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"];
            CLBeaconRegion *region1 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid1 identifier:@"Test"];
            NSUUID *uuid2 = [[NSUUID alloc] initWithUUIDString:@"67542266-18D1-4FE4-B4A1-23F8195B9D80"];
            CLBeaconRegion *region2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid2 identifier:@"Test2"];
            
            BCMBeaconRegionHandler *handler1 = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region1 enter:nil exit:nil];
            BCMBeaconRegionHandler *handler2 = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region2 enter:nil exit:nil];
            
            [registry addHandler:handler1];
            [registry addHandler:handler2];
            
            [registry removeHandlersForRegion:region1];
            [[[registry handlersForRegion:region2] shouldNot] beEmpty];
        });
    });
    
    describe(@"handlersForRegion", ^{
        it(@"should return empty array for unknown region", ^{
            NSUUID *uuid1 = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"];
            CLBeaconRegion *region1 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid1 identifier:@"Test"];
            NSUUID *uuid2 = [[NSUUID alloc] initWithUUIDString:@"67542266-18D1-4FE4-B4A1-23F8195B9D80"];
            CLBeaconRegion *region2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid2 identifier:@"Test2"];
            
            BCMBeaconRegionHandler *handler = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region1 enter:nil exit:nil];
            
            [registry addHandler:handler];
            
            [[[registry handlersForRegion:region1] shouldNot] beEmpty];
            [[[registry handlersForRegion:region2] should] beEmpty];
        });
    });
    
    describe(@"enumerateHandlersInRegion", ^{
        it(@"should enumerate handlers and execute block for each of them", ^{
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"];
            CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Test"];
            
            BCMBeaconRegionHandler *handler1 = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region enter:nil exit:nil];
            BCMBeaconRegionHandler *handler2 = [[BCMBeaconRegionHandler alloc] initWithBeaconRegion:region enter:nil exit:nil];
            
            [registry addHandler:handler1];
            [registry addHandler:handler2];
            
            __block BOOL foundHandler1 = NO;
            __block BOOL foundHandler2 = NO;
            [registry enumerateHandlersInRegion:region usingBlock:^(BCMBeaconRegionHandler *handler) {
                if (handler == handler1) foundHandler1 = YES;
                if (handler == handler2) foundHandler2 = YES;
            }];
            
            [[theValue(foundHandler1) should] beYes];
            [[theValue(foundHandler2) should] beYes];
        });
    });
});

SPEC_END