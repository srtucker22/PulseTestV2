//
//  SearchViewController.m
//  Geolocations
//
//  Created by Héctor Ramos on 8/16/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Parse/Parse.h>

#import "SearchViewController.h"
#import "GeoPointAnnotation.h"
#import "GeoQueryAnnotation.h"

enum PinAnnotationTypeTag {
    PinAnnotationTypeTagGeoPoint = 0,
    PinAnnotationTypeTagGeoQuery = 1
};

@interface SearchViewController ()
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CLLocationDistance radius;
@end

@implementation SearchViewController
@synthesize location = _location;
@synthesize radius = _radius;
@synthesize mapView = _mapView;


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"self.location %f %f", self.location.coordinate.latitude, self.location.coordinate.longitude);
    [self.mapView setRegion:MKCoordinateRegionMake(self.location.coordinate, MKCoordinateSpanMake(0.05, 0.05))];
    [self configureOverlay];
    
    [self.navigationController setToolbarHidden:YES];
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoPointAnnotationIdentifier = @"RedPinAnnotation";
    static NSString *GeoQueryAnnotationIdentifier = @"PurplePinAnnotation";
    
    if ([annotation isKindOfClass:[GeoQueryAnnotation class]]) {
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[mapView
                                dequeueReusableAnnotationViewWithIdentifier:GeoQueryAnnotationIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:GeoQueryAnnotationIdentifier];
            annotationView.tag = PinAnnotationTypeTagGeoQuery;
            annotationView.canShowCallout = YES;
            annotationView.pinColor = MKPinAnnotationColorPurple;
            annotationView.animatesDrop = YES;
            annotationView.draggable = NO;
        }
        
        return annotationView;
    } else if ([annotation isKindOfClass:[GeoPointAnnotation class]]) {
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[mapView
                                dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:GeoPointAnnotationIdentifier];
            annotationView.tag = PinAnnotationTypeTagGeoPoint;
            annotationView.canShowCallout = YES;
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.animatesDrop = YES;
            annotationView.draggable = NO;
        }
        
        return annotationView;
    } 
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    NSLog(@"here3");
    
    if (![view isKindOfClass:[MKPinAnnotationView class]] || view.tag != PinAnnotationTypeTagGeoQuery) {
        return;
    }
    
    if (MKAnnotationViewDragStateStarting == newState) {
        [self.mapView removeOverlays:[self.mapView overlays]];
    } else if (MKAnnotationViewDragStateNone == newState && MKAnnotationViewDragStateEnding == oldState) {
        MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)view;
        GeoQueryAnnotation *geoQueryAnnotation = (GeoQueryAnnotation *)pinAnnotationView.annotation;
        self.location = [[CLLocation alloc] initWithLatitude:geoQueryAnnotation.coordinate.latitude longitude:geoQueryAnnotation.coordinate.longitude];
        [self configureOverlay];
    }
}

#pragma mark - SearchViewController

- (void)setInitialLocation:(PFGeoPoint *)aLocation {
    self.location = [[CLLocation alloc] initWithLatitude:aLocation.latitude longitude:aLocation.longitude];
    self.radius = 1000;
}


#pragma mark - ()

- (void)configureOverlay {
    if (self.location) {
        [self.mapView removeAnnotations:[self.mapView annotations]];        
        [self.mapView removeOverlays:[self.mapView overlays]];
                
        GeoQueryAnnotation *annotation = [[GeoQueryAnnotation alloc] initWithCoordinate:self.location.coordinate radius:self.radius];
        [self.mapView addAnnotation:annotation];
        
        [self updateLocations];
    }
}

- (void)updateLocations {
    
    CGFloat kilometers = self.radius/1000.0f;

    PFQuery *query = [PFQuery queryWithClassName:@"Pulses"];
    [query setLimit:1000];
    [query whereKeyExists:@"location"];
    [query whereKey:@"location"
       nearGeoPoint:[PFGeoPoint geoPointWithLatitude:self.location.coordinate.latitude
                                           longitude:self.location.coordinate.longitude]
   withinKilometers:kilometers];
    [query whereKey:@"userId" equalTo:[[PFUser currentUser] objectId]];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                GeoPointAnnotation *geoPointAnnotation = [[GeoPointAnnotation alloc]
                                                          initWithObject:object];
                [self.mapView addAnnotation:geoPointAnnotation];
            }
        }
    }];
}

@end
