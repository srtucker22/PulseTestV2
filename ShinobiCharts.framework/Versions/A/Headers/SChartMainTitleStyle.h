//
//  SChartMainTitleStyle.h
//  ShinobiControls_Source
//
//  Copyright 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SChartTitleStyle.h"

typedef enum {
    SChartTitleCentresOnChart,
    SChartTitleCentresOnPlottingArea,
    SChartTitleCentresOnCanvas
} SChartTitleCentresOn;

@interface SChartMainTitleStyle : SChartTitleStyle

/** Whether the chart centers on the full chart view, the plot area, or the canvas.
 
 <code>typedef enum {<br>
 SChartTitleCentreOnChart,<br>
 SChartTitleCentreOnPlottingArea,<br>
 SChartTitleCentreOnCanvas
 } SChartTitleCentreOn;</code>
 */
@property (nonatomic, assign) SChartTitleCentresOn titleCentresOn;

/** A BOOLean to indicate if the chart title label should reserve space at the top of the chart or overlap the canvas.
 
 Setting this attribute to `YES` will allow the UILabel to appear over the chart plot area. Setting it to `NO` will push the canvas area down and reserve space obove the chart plots for the title.  calculateTargetBounds controls the space reserved for chart objects outside of the canvas area.*/
@property (nonatomic, assign) BOOL overlapChartTitle;

@end
