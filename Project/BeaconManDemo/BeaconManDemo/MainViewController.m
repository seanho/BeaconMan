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
    
    [[BCMBeaconManager defaultManager] registerRegion:region1];
    [[BCMBeaconManager defaultManager] registerRegion:region2];
    
    [[BCMBeaconManager defaultManager] notifyRegionImmediate:region1
                                                      repeat:YES
                                                    interval:15
                                                  usingBlock:^(CLBeacon *beacon) {
                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Pantry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                      [alert show];
                                                  }];
    
    [[BCMBeaconManager defaultManager] notifyRegionImmediate:region2
                                                      repeat:YES
                                                    interval:15
                                                  usingBlock:^(CLBeacon *beacon) {
                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Toilet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                      [alert show];
                                                  }];
}

@end
