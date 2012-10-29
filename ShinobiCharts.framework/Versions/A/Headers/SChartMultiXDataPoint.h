//
//  SChartMultiXDataPoint.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SChartData;
@class SChartDataPoint;

@interface SChartMultiXDataPoint : SChartDataPoint <SChartData>

#pragma mark -
#pragma mark Data

/** A dictionary of values for this data point. */
@property (nonatomic, retain) NSMutableDictionary *xValues;

@end
