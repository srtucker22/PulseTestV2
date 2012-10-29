//
//  SChartCrosshairTooltip.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SChartCanvas;

/** A simple extension of the UIView class to use as the standard cross hair tooltip.
 
 To create a custom tooltip - subclass this class and override the functions below. When the standard crosshair moves position it will call the following functions in order:
 
 1) setTooltipStyle: <br>
 2) setDataPoint:fromSeries:fromChart: <br>
 3) setPosition:onCanvas: */
@interface SChartCrosshairTooltip : UIView {
    UILabel *label;
    SChartCrosshairStyle *style;
}

@property (nonatomic, retain) UILabel *label;

/** A method called by the default crosshair
 
 Passes in the crosshair style object to update the look and feel of the tooltip*/
- (void)setTooltipStyle:(SChartCrosshairStyle*)style;

/** Standard crosshair called-method.
 
 Passes in information about the current crosshair data point. To convert dataPoint to a useful value - use the axis, eg:
 
 <code>[chart.xAxis stringForValue:dataPoint.x]</code>*/
- (void)setDataPoint:(id<SChartData>)dataPoint fromSeries:(SChartSeries *)series fromChart:(ShinobiChart *)chart;

/** Standard crosshair called-method.
 
 Passes in information about the current crosshair data point's resolved value.
 
 You can use dataPoint to obtain the interpolated value.*/
- (void) setResolvedDataPoint:(SChartPoint)dataPoint fromSeries:(SChartSeries *)series fromChart:(ShinobiChart *)chart;


/** Standard crosshair called-method.
  
 Passes in the position of the crosshair target and the current canvas. This allows positioning of the tooltip, using the canvas to do border checks. */
- (void)setPosition:(struct SChartPoint)pos onCanvas:(SChartCanvas*)canvas;

/** Standard crosshair called-method.
 
 When the crosshair is in floating mode, this is called for the current floating-position.
 This is primarily for use in a subclass, where the label text can be set to a custom string.
 By default, no useful information is shown in the label. */
- (void) floatingAt:(CGPoint)coords;

@end
