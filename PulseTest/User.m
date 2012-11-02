//
//  User.m
//  CrazyApp
//
//  Created by Simon Tucker on 10/24/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "User.h"
#import "PulseCalculator.h"
@implementation User

@synthesize locationManager=_locationManager;
@synthesize locationObject;

@synthesize currentPulse;

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

-(void)queryPulses:(void (^)(NSArray *pulses, NSError *error))handler
{
    PFQuery *query = [PFQuery queryWithClassName:@"Pulses"];
    [query whereKey:@"userId" equalTo:[[PFUser currentUser] objectId]];
    [query orderByAscending:@"createdAt"];
    [query setLimit:1000];
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
    geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
    
}

- (CLLocationManager *)locationManager {
    if (_locationManager != nil) {
        return _locationManager;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDelegate:self];
    [_locationManager setPurpose:@"Your current location is used to store when and where you are taking your pulse for your personal record."];
    
    return _locationManager;
}

-(void)setPulseScore:(NSArray *)brightnessValues completionHandler:(void (^)(NSInteger pulse, NSError *error))handler
{
    NSArray *smoothedScores = [PulseCalculator smoothScores:brightnessValues alpha:.3];
    NSInteger pulseValue = [PulseCalculator pulseScore:smoothedScores interval:[[NSUserDefaults standardUserDefaults] integerForKey:@"timerLength"]];
    currentPulse = pulseValue;
    handler(pulseValue,nil);
}

-(void)savePulse{
    NSLog(@"saving");
    locationObject = [PFObject objectWithClassName:@"Pulses"];
    
    if(geoPoint)
        [locationObject setObject:geoPoint forKey:@"location"];
    
    [locationObject setObject:[NSNumber numberWithInt:currentPulse] forKey:@"pulse"];
    [locationObject setObject:[[PFUser currentUser] objectId] forKey:@"userId"];
    [locationObject saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
        }else{
            NSLog(@"%@",error);
        }
    }];
}

@end
