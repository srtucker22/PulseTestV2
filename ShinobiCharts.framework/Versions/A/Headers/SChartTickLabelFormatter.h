//
//  SChartTickLabelFormatter.h
//  SChart
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@class SChartAxis;


/** A wrapper object that contains an appropriate NSFormatter for the axes for which it is formatting tick labels.
 
 Instances of SChartDateTimeAxis and SChartNumberAxis (and subclasses thereof) are assigned a sensible SChartTickLabelFormatter when
 they are initialised. Set properties on the 'formatter' property to customise your formatting.
 You can also subclass SChartTickLabelFormatter and set your custom object to an axis to handle formatting.
 */
@interface SChartTickLabelFormatter : NSObject

/** The internal formatter - set the properties on this.
 
 */
@property (nonatomic, retain) NSFormatter *formatter;

/** Factory method for an SChartTickLabelFormatter with a formatter of type NSNumberFormatter.
 
 Use this to create formatters for SChartNumberAxes.
 */
+(SChartTickLabelFormatter *) numberFormatter;

/** Factory method for an SChartTickLabelFormatter with a formatter of type NSDateFormatter.
 
 Use this to create formatters for SChartDateTimeAxes.
 */
+(SChartTickLabelFormatter *) dateFormatter;

/** Get the formatter property pre-cast as an NSNumberFormatter. 
 
 If the formatter is not an NSNumberFormatter, nil will be returned.
 */
-(NSNumberFormatter *)numberFormatter;

/** Get the formatter property pre-cast as an NSDateFormatter. 
 
 If the formatter is not an NSDateFormatter, nil will be returned.
 */
-(NSDateFormatter *)dateFormatter;

/** Get the formatted string representation for the value of a data object on an axis
 
 */
-(NSString *)stringForObjectValue:(id)obj onAxis:(SChartAxis *)axis;

@end
