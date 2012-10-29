//
//  SChartLegendSymbolBlock.h
//  ShinobiControls_Source
//
//

#import "SChartLegendSymbol.h"

@interface SChartLegendSymbolBlock : SChartLegendSymbol

@property (nonatomic, retain)   UIColor *areaColor;
@property (nonatomic, retain)   UIColor *outlineColor;

-(id)initWithAreaColor:(UIColor *)aColor andOutlineColor:(UIColor *)oColor;

@end
