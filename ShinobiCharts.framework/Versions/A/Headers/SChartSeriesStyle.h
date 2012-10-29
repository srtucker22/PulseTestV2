//
//  SChartSeriesStyle.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SChartSeriesStyle : NSObject

/** If YES, this will display a symbolic representation of the series in the legend.
 If set to NO, the series will be represented by a solid block of color */
@property (nonatomic)           BOOL        useSeriesSymbols;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartSeriesStyle *)style;

@end
