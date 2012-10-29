//
//  SChartDiscontinuousAxis.h
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SChartNumberAxis;

typedef struct SChartNumberSkip {
    double start, end;
} SChartNumberSkip;

/**
 * An SChartDiscontinuousNumberAxis is a subclass of SChartNumberAxis,
 * designed to allow skipping over given ranges.
 */
@interface SChartDiscontinuousNumberAxis : SChartNumberAxis

/**
 * Add an SChartNumberSkip with a start and end, to the list of ranges to skip
 *
 * An SChartNumberSkip is defined as follows:
 *
 * <code>typedef struct {<br>
 *     double start, end;<br>
 * } SChartNumberSkip;</code>
 *
 * You must reload the chart when adding new skips.
 *
 * @param skip The `SChartNumberSkip` to add to the exclusions
 */
- (void)    addSkip:(SChartNumberSkip)skip;

/**
 * Remove a previously added SChartNumberSkip from the list of ranges to skip.
 *
 * You must reload the chart when removing skips.
 *
 * @param skip The `SChartNumberSkip` to be removed from the exclusions
 */
- (void) removeSkip:(SChartNumberSkip)skip;


/**
 * Returns an array of NSValues, each containing an SChartNumberSkip.
 *
 * Note that you should not call `addSkip` or `removeSkip` while iterating over
 * this array.
 */
- (NSArray *)skips;

@end
