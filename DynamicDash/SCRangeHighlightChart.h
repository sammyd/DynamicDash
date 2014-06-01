//
//  SCRangeHighlightChart.h
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>
#import "SCColourTheme.h"

@class SCRangeHighlightChart;

@protocol SCRangeHighlightChartDelegate <NSObject>

@required
- (void)rangeHighlightChart:(SCRangeHighlightChart *)chart didSelectDateRange:(SChartDateRange *)range;

@end


@interface SCRangeHighlightChart : ShinobiChart

@property (nonatomic, weak) id<SCRangeHighlightChartDelegate> rangeDelegate;

- (void)setData:(NSDictionary *)data;
- (void)applyColourTheme:(id<SCColourTheme>)theme;
- (void)moveHighlightToDateRange:(SChartDateRange *)range;

@end

