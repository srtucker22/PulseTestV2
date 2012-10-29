#import <Foundation/Foundation.h>

@class SChartDateFrequency;


/**
 * An SChartTimePeriod represents a period of time beginning at a certain date-time.
 */
@interface SChartTimePeriod : NSObject

/**
 * Initialise a time period with a given start date and length
 */
- (id) initWithStart:(NSDate *)start
           andLength:(SChartDateFrequency *)length;

/**
 * Retrieve the start date of this period
 */
- (NSDate *) periodStart;

/**
 * Retrieve the length of this period
 */
- (SChartDateFrequency *) periodLength;

@end


/**
 * An SChartRepeatedTimePeriod represents a repeated period of time, anchored
 * to the start date. It repeats at the given frequency.
 */
@interface SChartRepeatedTimePeriod : SChartTimePeriod

/**
 * Initialise a repeat time period with a given start date, length and frequency
 */
- (id) initWithStart:(NSDate *)start
           andLength:(SChartDateFrequency *)length
        andFrequency:(SChartDateFrequency *)freq;

// unavailable superclass init
- (id) initWithStart:(NSDate *)start
           andLength:(SChartDateFrequency *)length UNAVAILABLE_ATTRIBUTE;

/**
 * Retrieve the frequency of this period
 */
- (SChartDateFrequency *) frequency;

@end
