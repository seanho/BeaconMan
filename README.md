# BeaconMan

[![Version](http://cocoapod-badges.herokuapp.com/v/BeaconMan/badge.png)](http://cocoadocs.org/docsets/BeaconMan)
[![Platform](http://cocoapod-badges.herokuapp.com/p/BeaconMan/badge.png)](http://cocoadocs.org/docsets/BeaconMan)

## Installation

BeaconMan is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "BeaconMan"


## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

## Sample

```objective-c
// register for a beacon region
CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"TestBeacon"];
[[BCMBeaconManager defaultManager] registerRegion:region enter:^{...} exit:^{...}];

// listen for beacon when it becomes very close and repeat the event every 15 seconds
[[BCMBeaconManager defaultManager] notifyRegionImmediate:region
                                                  repeat:YES
                                                interval:15
                                              usingBlock:^(CLBeacon *beacon) {
                                                  ...
                                              }];
```

## Author

Sean Ho, seanho@thoughtworks.com

## License

BeaconMan is available under the MIT license. See the LICENSE file for more info.

