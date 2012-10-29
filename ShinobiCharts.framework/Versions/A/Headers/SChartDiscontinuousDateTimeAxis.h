//
//  SChartDiscontinuousDateTimeAxis.h
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SChartDateTimeAxis;
@class SChartTimePeriod, SChartRepeatedTimePeriod;

/**
 * An SChartDiscontinuousDateTimeAxis is a subclass of SChartDateTimeAxis
 * designed to work with NSDates, skipping over specified time periods.
 */

@interface SChartDiscontinuousDateTimeAxis : SChartDateTimeAxis

/**
 * Adds an `SChartTimePeriod` to the list of date-periods to skip over.
 * You must reload the chart when new skips are added.
 *
 * @param period A new time period to exclude
 */
- (void) addExcludedTimePeriod:(SChartTimePeriod *)period;

/**
 * Adds an `SChartRepeatedTimePeriod` to the skipping algorithm. This causes
 * the axis to skip over a time period repeatedly, anchored at a certain
 * starting point.
 *
 * This starting date may be anywhere, including outside the current axis
 * range. The axis will calculate the correct in-range start for you.
 *
 * You must reload the chart when new skips are added.
 *
 * @param period A new repeat-time period to exclude
 */
- (void) addExcludedRepeatedTimePeriod:(SChartRepeatedTimePeriod *)period;

/**
 * Removes a single, previously added, skip period.
 *
 * You must reload the chart when skips are removed.
 *
 * @param period The same, or an equivalent time period to remove from the exclusions
 */
- (void) removeExcludedTimePeriod:(SChartTimePeriod *)period;

/**
 * Removes a repeated time period/the multiple skips caused by one repeated
 * time period.
 *
 * You must reload the chart when skips are removed.
 *
 * @param period The same, or an equivalent repeat-time period to remove from the exclusions
 */
- (void) removeExcludedRepeatedTimePeriod:(SChartRepeatedTimePeriod *)period;

/**
 * Returns an array of the skipping time periods previously given to the axis.
 *
 * Note that you must copy this array if you wish to iterate over it and call
 * any of the single-add or single-remove methods mentioned in this class.
 */
- (NSArray *) excludedTimePeriods;

/**
 * Returns an array of the repeat-skip time periods previously given to the
 * axis.
 *
 * Note that you must copy this array if you wish to iterate over it and call
 * any of the repeat-add or repeat-remove methods mentioned in this class.
 */
- (NSArray *) excludedRepeatedTimePeriods;

@end
