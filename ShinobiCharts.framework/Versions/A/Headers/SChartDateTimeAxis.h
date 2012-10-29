//
//  SChartDateTimeAxis.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SChartDateRange;
@class SChartDateFrequency;

/** 
 An SChartDateTimeAxis is a subclass of SChartAxis designed to work with data points that use NSDate. 
 
  The frequency values for tick marks are expected to be SChartDateFrequency objects.
 */
@interface SChartDateTimeAxis : SChartAxis {
    BOOL hideMinorTicksOverride;
    double previousFreq;
    BOOL usePreviousAnchorPoint;
    BOOL previousFirstMajorTickWasOverAlternate;
    NSNumber *previousFirstMajorTick;
    double refDate;
    BOOL refDateInitialised;
    NSCalendar *cal;
}

#pragma mark - 
#pragma mark Initialisation
/** @name Initialisation */
/** Init with a NSDate specific range */
- (id)initWithRange:(SChartDateRange *)range;

#pragma mark - 
#pragma mark Internal: Tickmark Config
- (BOOL)checkTickFrequencyIsValid:(SChartDateFrequency *)frequency;
- (void)updateTickLabelConfiguration;

-(void)setRefDate:(double)ref;

@end
