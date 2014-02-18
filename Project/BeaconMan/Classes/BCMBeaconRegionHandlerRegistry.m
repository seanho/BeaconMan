#import "BCMBeaconRegionHandlerRegistry.h"

@interface BCMBeaconRegionHandlerRegistry ()
@property (nonatomic, strong) NSMutableDictionary *groupedHandlers;
@end

@implementation BCMBeaconRegionHandlerRegistry

- (id)init
{
    if (self == [super init])
    {
        _groupedHandlers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addHandler:(BCMBeaconRegionHandler *)handler
{
    CLBeaconRegion *region = handler.region;
    
    NSString *identifier = [self regionIdentifier:region];
    NSMutableArray *handlers = self.groupedHandlers[identifier];
    
    if (handlers)
    {
        [handlers addObject:handler];
    }
    else
    {
        self.groupedHandlers[identifier] = [NSMutableArray arrayWithObject:handler];
    }
}

- (void)removeHandlersForRegion:(CLBeaconRegion *)region
{
    NSString *identifier = [self regionIdentifier:region];
    NSArray *handlersToRemove = [self handlersForRegion:region];
    
    [(NSMutableArray *)self.groupedHandlers[identifier] removeObjectsInArray:handlersToRemove];
}

- (NSArray *)handlersForRegion:(CLBeaconRegion *)region
{
    NSString *identifier = [self regionIdentifier:region];
    NSArray *handlers = self.groupedHandlers[identifier];
    
    return [handlers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        BCMBeaconRegionHandler *handler = (BCMBeaconRegionHandler *)evaluatedObject;
        return [handler matchesMajorAndMinor:(CLBeaconRegion *)region];
    }]];
}

- (void)enumerateHandlersInRegion:(CLBeaconRegion *)region usingBlock:(void(^)(BCMBeaconRegionHandler *handler))block
{
    NSArray *handlers = [self handlersForRegion:region];
    
    [handlers enumerateObjectsUsingBlock:^(BCMBeaconRegionHandler *handler, NSUInteger idx, BOOL *stop) {
        if (block) block(handler);
    }];
}

#pragma mark - Private Methods

- (NSString *)regionIdentifier:(CLBeaconRegion *)region
{
    return [region.proximityUUID UUIDString];
}

@end
