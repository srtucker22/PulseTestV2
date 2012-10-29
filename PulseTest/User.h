//
//  User.h
//  CrazyApp
//
//  Created by Simon Tucker on 10/24/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <CoreLocation/CoreLocation.h>

#import <Parse/Parse.h>

@interface User : NSObject <CLLocationManagerDelegate>

+ (id)sharedUser;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) PFObject *locationObject;

@property int currentPulse;

@property (readwrite) NSArray *brightnessValues;

-(NSInteger)getPulseScore;
@end
