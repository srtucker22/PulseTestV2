//
//  SChartTitleStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    SChartTitlePositionCenter,
    SChartTitlePositionBottomOrLeft,
    SChartTitlePositionTopOrRight
} SChartTitlePosition;


/** The style properties for the chart title
 
 */

@interface SChartTitleStyle : NSObject

/** @name Styling Properties */

/** The color of the text for the title */
@property (nonatomic, retain)     UIColor           *textColor;

/** The font for the title text */
@property (nonatomic, retain)     UIFont            *font;

/** The minimum font size for the title text.
 
 Functions in the same way as the UILabel equivalent property.*/
@property (nonatomic)             CGFloat           minimumFontSize;

/** The text alignment of the title */
@property (nonatomic)             UITextAlignment   textAlign;

/** The background color of the title label */
@property (nonatomic, retain)     UIColor           *backgroundColor;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       

/** Where the title will appear relative to the chart or axis */
@property (nonatomic) SChartTitlePosition           position;

@end
