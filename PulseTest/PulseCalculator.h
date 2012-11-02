//
//  PulseCalculator.h
//  PulseTest
//
//  Created by Simon Tucker on 10/30/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PulseCalculator : NSObject
+(NSArray *)smoothScores:(NSArray *)brightnessScores alpha:(double)alpha;
+(NSInteger)pulseScore:(NSArray *)brightnessScores interval:(int)seconds;

+(NSNumber *)meanOf:(NSArray *)array;
+(NSNumber *)standardDeviationOf:(NSArray *)array;
@end
