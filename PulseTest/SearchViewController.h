//
//  SearchViewController.h
//  Geolocations
//
//  Created by Héctor Ramos on 8/16/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SearchViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

- (void)setInitialLocation:(CLLocation *)aLocation;

@end
