#import "MainViewController.h"
#import "BCMBeaconManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"];
    CLBeaconRegion *region1 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:2991 identifier:@"2991"];
    CLBeaconRegion *region2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:2994 identifier:@"2994"];
    
    [[BCMBeaconManager defaultManager] registerRegion:region1 enter:nil exit:nil];
    [[BCMBeaconManager defaultManager] registerRegion:region2 enter:nil exit:nil];
    
    [[BCMBeaconManager defaultManager] notifyRegion:region1
                                                      repeat:NO
                                                  usingBlock:^(CLBeacon *beacon) {
                                                      NSLog(@"Pantry");
                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Pantry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                      [alert show];
                                                  }];
    
    [[BCMBeaconManager defaultManager] notifyRegion:region2
                                                      repeat:NO
                                                  usingBlock:^(CLBeacon *beacon) {
                                                      NSLog(@"Toilet");
                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Toilet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                      [alert show];
                                                  }];
}

- (NSString *)formatProximity:(CLProximity)proximity
{
    if (proximity == CLProximityUnknown)
    {
        return @"Unknown Proximity";
    }
    else if (proximity == CLProximityImmediate)
    {
        return @"Immediate";
    }
    else if (proximity == CLProximityNear)
    {
        return @"Near";
    }
    else if (proximity == CLProximityFar)
    {
        return @"Far";
    }
    else
    {
        return @"";
    }
}

@end
