//
//  SChartLegendSymbolBlockSplit.h
//  ShinobiControls_Source
//
//  Created by Simon Withington on 14/09/2012.
//
//

#import "SChartLegendSymbolBlock.h"

@interface SChartLegendSymbolBlockSplit : SChartLegendSymbolBlock

@property (nonatomic, retain)   UIColor *lowColor;

-(id)initWithAreaColor:(UIColor *)aColor andLowAreaColor:(UIColor *)lColor andOutlineColor:(UIColor *)oColor;

@end
