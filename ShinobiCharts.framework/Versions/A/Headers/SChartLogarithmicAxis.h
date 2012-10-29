//
//  SChartLogarithmicAxis.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SChartNumberAxis.h"

/** 
 An SChartLogarithmicAxis is a subclass of SChartNumberAxis used for displaying logarithmic data.
 
 Unlike a 'standard' number axis, the distance between n and n+1 is not the same as the distance between n+7 and n+8.
 Rather, the distance between base^(n) and base^(n+1) is the same as the distance between base^(n+7) and base^(n+8).
 */

@interface SChartLogarithmicAxis : SChartNumberAxis

/** The base of the logarithmic axis. */
@property (nonatomic, retain)   NSNumber    *base;

@end
