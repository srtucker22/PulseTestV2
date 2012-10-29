//
//  SChartCrosshair.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShinobiChart;
@class SChartSeries;
@class SChartCrosshairStyle;
@class SChartCrosshairTooltip;
@protocol SChartData;

typedef enum {
    SChartCrosshairModeSingleSeries,
    SChartCrosshairModeFloating
} SChartCrosshairMode;


/** The SChartCrosshair provides a small circle target with lines that extend to the axis. This is accompanied by a tooltip object - nominally a UIView.
 
 The crosshair is enabled with a _tap-and-hold gesture_ and will lock to the nearest series to pan through the values. On a line series the values will be interpolated between data points, on all other series types the crosshair will jump from data point to data point. Note that line series interpolation can be switched off by setting `interpolatePoints` to `NO` */
@interface SChartCrosshair : UIView

#pragma mark -
#pragma mark Init
/** @name Initialisation */
/** Create a crosshair with frame and the chart handle */
-(id)initWithChart:(ShinobiChart *)parentChart;

-(id)initWithFrame:(CGRect)frame usingChart:(ShinobiChart *)parentChart DEPRECATED_ATTRIBUTE;

/** The series we're tracking */
@property (nonatomic, retain) SChartCartesianSeries *trackingSeries;
@property (nonatomic, assign) SChartPoint            trackingPoint;

/** The handle to the chart allowing the crosshair to access chart data */
@property (nonatomic, assign) ShinobiChart *chart;

#pragma mark -
#pragma mark Style
/** @name Style */
/** All of the properties to style the crosshair */
@property (nonatomic, retain) SChartCrosshairStyle *style;

#pragma mark -
#pragma mark Tooltip
/** @name Tooltip */
/** The UIView to present the data values to the user 
 
 Override this to provide a custom view to present the crosshair data.*/
@property (nonatomic, retain) SChartCrosshairTooltip *tooltip;

#pragma mark -
#pragma mark Customization
/** @name Customization */

/** When set to `YES` the lines from the target point to the axis will be displayed. */
@property (nonatomic)         BOOL    enableCrosshairLines;
@property (nonatomic)         BOOL    enableCrosshairLinesSet;

/**
 A boolean controlling whether the crosshair should draw its tracking lines,
 at the pixel point, `point`, inside `frame`.
 This defaults to a simple bounds check - whether point is inside frame.
 */
- (BOOL) shouldDrawCrosshairLinesForPoint:(CGPoint)point inFrame:(CGRect)frame;

/**
  The crosshair has different behaviors for when it goes out of range.
  It can hide, but continue to track the series until it comes back in range,
  or it can track the edge - the tooltip will move along the edge of the canvas
  until the series comes back into range. The final option is for the crosshair
  to remove itself entirely, leaving the chart open for panning or tracking a new
  series.

 <code>typedef enum {<br>
    SChartCrosshairRangeBehaviorKeepAtEdge,<br>
    SChartCrosshairRangeBehaviorHide,<br>
    SChartCrosshairRangeBehaviorRemove,<br>
 } SChartGesturePanType;</code>
 
 Defaults to `SChartCrosshairRangeBehaviorHide` */
typedef enum {
    SChartCrosshairOutOfRangeBehaviorKeepAtEdge,
    SChartCrosshairOutOfRangeBehaviorHide,
    SChartCrosshairOutOfRangeBehaviorRemove,
} SChartCrosshairOutOfRangeBehavior;

/** Hide the crosshair when out of range (the series is still tracked)
 Otherwise, the crosshair will track along the canvas limit
 */
@property (nonatomic)         SChartCrosshairOutOfRangeBehavior outOfRangeBehavior;

/** If set to 'YES' the crosshair will move smoothly betwen points when tracking a line series */
@property (nonatomic)         BOOL      interpolatePoints;

@property (nonatomic)         UIViewAnimationOptions animationOptions;
@property (nonatomic)         CGFloat animationDuration;
@property (nonatomic)         CGFloat animationDelay;
@property (nonatomic)         BOOL animationEnabled;

/** Displays the crosshair (with lines and tooltip) on the chart
 
 This method is called by the chart when the crosshair should be displayed. Override this method to control the display of the crosshair in subclasses. */
-(void)showCrosshair;

/** Hides the crosshair (with lines and tooltip) on the chart
 
 This method is called by the chart when the crosshair should be dismissed. Override this method to control the display of the crosshair in subclasses. */
-(BOOL)removeCrosshair;

/** Performs the drawing of the lines and target circle element of the crosshair.
 
 Override this function to provide custom lines or other drawn elements. */
-(void)drawCrosshairLines;

/** Sets the current tooltip element of the crosshair to be the default baseclass - SChartCrosshairTooltip. */
-(void)setDefaultTooltip;

/** This method is called when the crosshair changes position. 

The point `coords` is the location in pixels on the series where the crosshair should appear. The `dataPoint` is either an interpolated point or actual data point to represent in the tooltip. Override this method in a subclass to populate a custom crosshair. */
-(void)moveToPosition:(SChartPoint)coords andDisplayDataPoint:(SChartPoint)dataPoint fromSeries:(SChartCartesianSeries *)series andSeriesDataPoint:(id<SChartData>)dataseriesPoint;

/** This describes whether the crosshair is in floating mode or not. */
@property(nonatomic) SChartCrosshairMode mode;

/** This method is called when the crosshair moves out of the visible range of the chart. */
-(void)crosshairMovedOutOfRange;

/** This method is called when the crosshair moves while inside the visible range of the chart. */
-(void)crosshairMovedInsideRange;

/** This method is called to ask whether the crosshair should keep tracking. If this is the case, the crosshair should provide a series to track, in trackingSeries. */
-(BOOL)crosshairShouldKeepTracking;

/** This method is called to obtain the series the crosshair should track. */
-(SChartCartesianSeries *)trackingSeries;

/** This method is informs the crosshair that a gesture was performed which failed to select any series. The default behavior is to remove the crosshair. */
-(void)crosshairTrackingFailed;

/** This method is informs the crosshair that there was a pinch/pan gesture on the chart. The default behavior is to remove the crosshair. */
-(void)crosshairChartGotPinchAndPan;

/** This method is informs the crosshair that there was a tap gesture on the chart at a point. The default behavior is to remove the crosshair. */
-(void)crosshairChartGotTapAt:(CGPoint)tap;

/**
 This method is informs the crosshair that there was a long press gesture on the chart at a point.
 The default behavior is to do nothing - the Shinobi framework will ask for a series to track. If nil is given, the closest series will be found and the crosshair will be informed.
 */
-(void)crosshairChartGotLongPressAt:(CGPoint)longpress;

/** The chart owning this crosshair did a data-reload. */
-(void)chartDidReload;

/** Move the crosshair to the pixel coordinates `floatingCoords`. */
-(void)moveToFloatingPixelPosition:(CGPoint)floatingCoords;

/** Move the crosshair to the data coordinates `floatingCoords` relative to `xAxis` and `yAxis`. */
- (void)moveToFloatingPosition:(SChartPoint)point onXAxis:(SChartAxis *)xAxis onYAxis:(SChartAxis *)yAxis;

@end
