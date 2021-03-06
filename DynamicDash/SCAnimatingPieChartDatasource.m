//
//  SCAnimatingPieChartDatasource.m
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCAnimatingPieChartDatasource.h"
#import "SCDataPointAnimator.h"

@interface SCAnimatingPieChartDatasource () <SChartDatasource, SChartDelegate>

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *datapoints;
@property (nonatomic, strong) ShinobiChart *chart;
@property (nonatomic, strong) SChartPieSeries *series;
@property (nonatomic, strong) SCDataPointAnimator *dpAnimator;

@end

@implementation SCAnimatingPieChartDatasource

- (instancetype)initWithChart:(ShinobiChart *)chart categories:(NSArray *)categories
{
    self = [super init];
    if(self) {
        self.categories = categories;
        self.chart = chart;
        self.chart.datasource = self;
        self.chart.legend.hidden = NO;
        self.chart.legend.placement = SChartLegendPlacementInsidePlotArea;
        self.chart.legend.position = SChartLegendPositionBottomMiddle;
        [self prepareDatapoints];
        
        self.dpAnimator = [[SCDataPointAnimator alloc] initWithPostWriteCallback:^{
            [self.chart reloadData];
            [self.chart redrawChart];
        }];
    }
    return self;
}

- (void)prepareDatapoints
{
    NSMutableArray *dps = [NSMutableArray new];
    [self.categories enumerateObjectsUsingBlock:^(NSString *category, NSUInteger idx, BOOL *stop) {
        SChartRadialDataPoint *dp = [SChartRadialDataPoint new];
        dp.name = category;
        dp.value = @1;
        [dps addObject:dp];
    }];
    
    self.datapoints = [dps copy];
}

- (void)animateToValuesInDictionary:(NSDictionary *)dict
{
    // We fail silently in all cases
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *value, BOOL *oStop) {
        // If there aren't enough elements in the array, skip it
        NSUInteger dataIndex = [self.categories indexOfObject:key];
        if(dataIndex != NSNotFound) {
            [self.dpAnimator animateDatapoint:self.datapoints[dataIndex] toValue:value];
        }
    }];
}

- (void)applyTheme:(id<SCColourTheme>)theme
{
    self.series.style.flavourColors = [NSMutableArray arrayWithArray:@[[theme.midColour colorWithAlphaComponent:0.5], theme.midLightColour, theme.lightColour]];

    self.chart.legend.style.fontColor = theme.darkColour;
    self.chart.legend.style.borderColor = theme.darkColour;
    self.chart.legend.style.borderWidth = @2;
    self.chart.legend.style.areaColor = [theme.midColour colorWithAlphaComponent:0.4];
    self.chart.legend.style.font = [self.chart.legend.style.font fontWithSize:10];
    self.series.style.labelFontColor = theme.darkColour;
    self.chart.backgroundColor = theme.midDarkColour;
}

- (SChartPieSeries *)series
{
    if(!_series) {
        _series = [SChartPieSeries new];
        _series.style.showLabels = NO;
        _series.selectedStyle.showLabels = NO;
    }
    return _series;
}

#pragma mark - SChartDataSource methods
- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 1;
}

- (SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index
{
    return self.series;
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
