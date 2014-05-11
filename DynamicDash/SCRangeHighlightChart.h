//
//  SCRangeHighlightChart.h
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>
#import "SCColourTheme.h"

@interface SCRangeHighlightChart : ShinobiChart

- (void)setData:(NSDictionary *)data;
- (void)applyColourTheme:(id<SCColourTheme>)theme;
- (void)moveHighlightToDateRange:(SChartDateRange *)range;

@end
