//
//  SChartRadialDataPoint.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SChartData;
@class SChartDataPoint;

/**
 In a ShinobiChart, one or more SChartRadialSeries, composed of SChartDatapoints in a SChartDataSeries, may be visualised. 
 
 Each SChartRadialDataPoint represents a simple data point in a SChartDataSeries. The radial data point is made up of a name and a value (magnitude).  
 Unlike data points in non-radial Shinobi Charts, an SChartRadialDataPoint can have only one value. The translation of these objects onto a chart is handled internally.
 */

@interface SChartRadialDataPoint : SChartDataPoint <SChartData>

#pragma mark -
#pragma mark Data
/** @name Representing real data for a series */
/** The name of this data point */
@property (nonatomic, retain) NSString *name;

/** The value or magnitude of data point.
 
 All radial data points have a single value. */
@property (nonatomic, retain) NSNumber *value;

@end
