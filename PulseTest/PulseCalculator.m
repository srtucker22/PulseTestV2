//
//  PulseCalculator.m
//  PulseTest
//
//  Created by Simon Tucker on 10/30/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "PulseCalculator.h"
#define MIN_THRESHOLD 30000
@implementation PulseCalculator
+(NSArray *)smoothScores:(NSArray *)brightnessScores alpha:(double)alpha{
    float s1 = ((NSNumber *)[brightnessScores objectAtIndex:0]).floatValue;
    
    NSMutableArray *smoothedScores = [[NSMutableArray alloc] initWithCapacity:brightnessScores.count];
    
    float s_t_minus1 = s1;
    for(int t=1;t<brightnessScores.count;t++)
    {
        float x_t_minus1 = ((NSNumber *)[brightnessScores objectAtIndex:(t-1)]).floatValue;
        float s_t = alpha*x_t_minus1 + (1 - alpha)*s_t_minus1;
        [smoothedScores addObject:[NSNumber numberWithFloat:s_t]];
        s_t_minus1 = s_t;
    }
    return smoothedScores;
}
+(NSInteger)pulseScore:(NSArray *)brightnessScores interval:(int)seconds{
    float localMin = 100000000;
    float localMax = -100000000;
    float previousVal = -100000000;
    
    int pulseIncrementer = 0;
    
    for(NSNumber *value in brightnessScores)
    {
        float val = [value floatValue];
        if(previousVal>=0)
        {
            if(val>previousVal)
            {
                if(localMin==previousVal){
                    
                }
                localMax=val;
            }else
            {
                if(localMax==previousVal){
                    if(val-MIN_THRESHOLD>localMin)
                        pulseIncrementer++;
                }
                localMin = val;
            }
        }else
        {
            if(val<localMin)
            {
                localMin = val;
            }
            if(val>localMax)
            {
                localMax = val;
            }
        }
        previousVal = val;
    }
    return pulseIncrementer*60/seconds;
}

+(NSNumber *)meanOf:(NSArray *)array
{
    double runningTotal = 0.0;
    
    for(NSNumber *number in array)
    {
        runningTotal += [number doubleValue];
    }
    
    return [NSNumber numberWithDouble:(runningTotal / [array count])];
}

+(NSNumber *)standardDeviationOf:(NSArray *)array
{
    if(![array count]) return nil;
    
    double mean = [[self meanOf:array] doubleValue];
    double sumOfSquaredDifferences = 0.0;
    
    for(NSNumber *number in array)
    {
        double valueOfNumber = [number doubleValue];
        double difference = valueOfNumber - mean;
        sumOfSquaredDifferences += difference * difference;
    }
    
    return [NSNumber numberWithDouble:sqrt(sumOfSquaredDifferences / [array count])];
}
@end
