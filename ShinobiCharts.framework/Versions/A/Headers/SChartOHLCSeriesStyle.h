//
//  SChartOHLCSeriesStyle.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import "SChartBarColumnSeriesStyle.h"

@interface SChartOHLCSeriesStyle : SChartSeriesStyle
/** @name Styling properties */

/** The color of the body of the OHLC point if the point is rising */
@property (nonatomic, retain)       UIColor     *risingColor;
/** The gradient color of the body of the OHLC point if the point is rising */
@property (nonatomic, retain)       UIColor     *risingColorGradient;

/** The color of the body of the OHLC point if the point is falling */
@property (nonatomic, retain)       UIColor     *fallingColor;
/** The gradient color of the body of the OHLC point if the point is falling */
@property (nonatomic, retain)       UIColor     *fallingColorGradient;

/** The width of the trunk in pixels */
@property (nonatomic, retain)     NSNumber  *trunkWidth;
/** The width of the arms in pixels */
@property (nonatomic, retain)     NSNumber  *armWidth;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
-(void)supplementStyleFromStyle:(SChartOHLCSeriesStyle *)style;

@end
