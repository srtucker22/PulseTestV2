//
//  SChartInternalDataPoint.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SChartData;
@class SChartDataPoint;
@class SChartAxis;

/* Internal data points */
@interface SChartInternalDataPoint : SChartDataPoint <SChartData>

/* X values by key for series that require multiple values. */
@property (nonatomic, retain) NSMutableDictionary *xValues;

/* Y values by key for series that require multiple values. */
@property (nonatomic, retain) NSMutableDictionary *yValues;


#pragma mark -
#pragma mark Texture
@property (nonatomic, retain) UIImage *texture;

#pragma mark -
#pragma mark Radius
@property (nonatomic, assign) float radius;

@property (nonatomic, assign) float innerRadius;


#pragma mark -
#pragma mark Coords
/* The x coordinate for this data point - calculate by the relevant axis */
@property (nonatomic, assign) double xCoord;

/* The y coordinate for this data point - calculate by the relevant axis */
@property (nonatomic, assign) double yCoord;

/* X coordinates by key for series that require multiple values. */
@property (nonatomic, retain) NSMutableDictionary *xCoords;

/* Y coordinates by key for series that require multiple values. */
@property (nonatomic, retain) NSMutableDictionary *yCoords;


#pragma mark -
#pragma mark Comparing values
/* @name Comparing values */
/* Compare the X component values of these two internal data points */
-(NSComparisonResult)compareXAsNumber:(SChartInternalDataPoint*)dp;

/* Compare the Y component values of these two internal data points */
-(NSComparisonResult)compareYAsNumber:(SChartInternalDataPoint*)dp;


+(id<SChartData>)getExternalDatapointFromInternal:(id<SChartData>)datapoint
                                        withXAxis:(SChartAxis *)xAxis
                                         andYAxis:(SChartAxis *)yAxis;

@end
