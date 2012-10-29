//
//  SChartAxisTitleStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SChartTitleStyle.h"

typedef enum {
    SChartAxisTitleOrientationHorizontal,
    SChartAxisTitleOrientationVertical
} SChartAxisTitleOrientation;

/** The axis title style object controls the look and feel for the axis title.
 
 */
@interface SChartAxisTitleStyle : SChartTitleStyle <NSCopying>

/** One of the preset orientations for the title
 
 <code>typedef enum {<br>
 SChartAxisTitleOrientationHorizontal,<br>
 SChartAxisTitleOrientationVertical
 } SChartAxisTitleOrientation;</code>
*/
@property (nonatomic) SChartAxisTitleOrientation titleOrientation;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
-(void)supplementStyleFromStyle:(SChartAxisTitleStyle *)style;

@end
