//
//  User.m
//  CrazyApp
//
//  Created by Simon Tucker on 10/24/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize locationManager=_locationManager;

@synthesize locationObject;

@synthesize currentPulse;

@synthesize brightnessValues;

static User *sharedUser = nil;

-(id)init{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

+ (id)sharedUser {
    @synchronized(self) {
        if (sharedUser == nil)
            sharedUser = [[self alloc] init];
    }
    return sharedUser;
}

-(void)querySaves:identifier completionHandler:(void (^)(NSArray *pulses, NSError *error))handler
{
    PFQuery *query = [PFQuery queryWithClassName:@"Pulse"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
            if (!error)
            {
                handler(objects, nil);
            }else
            {
                handler(nil, error);
            }
         }];
}

#pragma mark - CLLocationManagerDelegate

/**
 Conditionally enable the Search/Add buttons:
 If the location manager is generating updates, then enable the buttons;
 If the location manager is failing, then disable the buttons.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    CLLocation *location = _locationManager.location;
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    
    if(!locationObject)
        locationObject = [PFObject objectWithClassName:@"Pulse"];
    
    [locationObject setObject:geoPoint forKey:@"location"];
    [locationObject setObject:[NSNumber numberWithInt:currentPulse] forKey:@"pulse"];
    [locationObject saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
        }else{
            NSLog(@"%@",error);
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
}

- (CLLocationManager *)locationManager {
    if (_locationManager != nil) {
        return _locationManager;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDelegate:self];
    [_locationManager setPurpose:@"Your current location is used to demonstrate PFGeoPoint and Geo Queries."];
    
    return _locationManager;
}

-(NSInteger)getPulseScore
{
    float localMin = 100000000;
    float localMax = -100000000;
    float previousVal = -100000000;
    
    NSMutableArray *localMins = [[NSMutableArray alloc] init];
    NSMutableArray *localMaxes = [[NSMutableArray alloc] init];
    
    for(NSNumber *value in brightnessValues)
    {
        float val = [value floatValue];
        if(previousVal>=0)
        {
            if(val>previousVal)
            {
                if(localMin==previousVal){
                    [localMins addObject:[NSNumber numberWithFloat:localMin]];
                }
                localMax=val;
            }else
                if(val<previousVal)
                {
                    if(localMax==previousVal){
                        [localMaxes addObject:[NSNumber numberWithFloat:localMax]];
                    }
                    localMin=val;
                }
        }else
        {
            if(val<localMin)
            {
                localMin = val;
            }
            if(val>localMax)
            {
                localMax = val;
            }
        }
        previousVal = val;
    }
    NSLog(@"the local maxes %@", localMaxes);
    NSLog(@"the local mins %@", localMins);
    
    NSLog(@"local maxes and mins count %i %i",localMaxes.count, localMins.count);
    
    [[User sharedUser] setCurrentPulse:localMins.count*2/3];
    [[[User sharedUser] locationManager] startUpdatingLocation];
    
    return localMins.count*6/5;
}
@end
