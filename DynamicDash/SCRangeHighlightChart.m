//
//  SCRangeHighlightChart.m
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCRangeHighlightChart.h"

@interface SCRangeHighlightChart () <SChartDatasource>

@property (nonatomic, strong) NSArray *datapoints;

@end

@implementation SCRangeHighlightChart


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.datasource = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self  = [super initWithCoder:aDecoder];
    if(self) {
        self.datasource = self;
    }
    return self;
}

- (void)setData:(NSDictionary *)data
{
    NSMutableArray *dps = [NSMutableArray array];
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        SChartDataPoint *dp = [SChartDataPoint new];
        dp.xValue = key;
        dp.yValue = obj;
        [dps addObject:dp];
    }];
    self.datapoints = [dps sortedArrayUsingComparator:^NSComparisonResult(SChartDataPoint *dp1, SChartDataPoint *dp2) {
        return [dp1.xValue compare:dp2.xValue];
    }];
}

#pragma mark - SChartDatasource methods
- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 1;
}

- (SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index
{
    return [SChartLineSeries new];
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
    return [self.datapoints count];
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex
{
    return self.datapoints[dataIndex];
}

@end
