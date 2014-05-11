//
//  SCRangeHighlightChart.m
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCRangeHighlightChart.h"
#import "SCAnnotationAnimator.h"

@interface SCRangeHighlightChart () <SChartDatasource>

@property (nonatomic, strong) NSArray *datapoints;
@property (nonatomic, strong) SChartLineSeries *lineSeries;
@property (nonatomic, strong) SChartAnnotationZooming *highlight;
@property (nonatomic, strong) SCAnnotationAnimator *animator;

@end

@implementation SCRangeHighlightChart


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self sharedInit];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self  = [super initWithCoder:aDecoder];
    if(self) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    self.datasource = self;
    self.xAxis = [SChartDateTimeAxis new];
    self.yAxis = [SChartNumberAxis new];
    self.animator = [SCAnnotationAnimator new];
    [self moveHighlightToDateRange:nil];
}

- (void)setData:(NSDictionary *)data
{
    NSMutableArray *dps = [NSMutableArray array];
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        SChartDataPoint *dp = [SChartDataPoint new];
        dp.xValue = key;
        dp.yValue = @([obj floatValue] / 1000.0);
        [dps addObject:dp];
    }];
    self.datapoints = [dps sortedArrayUsingComparator:^NSComparisonResult(SChartDataPoint *dp1, SChartDataPoint *dp2) {
        return [dp1.xValue compare:dp2.xValue];
    }];
}

- (void)applyColourTheme:(id<SCColourTheme>)theme
{
    self.backgroundColor = theme.midColour;
    self.plotAreaBackgroundColor = [UIColor clearColor];
    self.canvasAreaBackgroundColor = [UIColor clearColor];
    self.lineSeries.style.lineColor = theme.lightColour;
    self.xAxis.style.lineColor = theme.midLightColour;
    self.xAxis.style.lineWidth = @2;
    self.xAxis.style.majorTickStyle.tickLabelOrientation = TickLabelOrientationHorizontal;
    self.yAxis.style.lineColor = theme.midLightColour;
    self.yAxis.style.lineWidth = @2;
    self.xAxis.style.majorTickStyle.labelColor = theme.lightColour;
    self.yAxis.style.majorTickStyle.labelColor = theme.lightColour;
    self.highlight.backgroundColor = [theme.lightColour colorWithAlphaComponent:0.5];
    
    [self redrawChart];
}

- (void)moveHighlightToDateRange:(SChartDateRange *)range
{
    if(!self.highlight) {
        self.highlight = [SChartAnnotation verticalBandAtPosition:[range minimumAsDate]
                                                          andMaxX:[range maximumAsDate]
                                                        withXAxis:self.xAxis
                                                         andYAxis:self.yAxis
                                                        withColor:[UIColor whiteColor]];
        [self addAnnotation:self.highlight];
    }
    [self.animator animateVerticalBandAnnotation:self.highlight toDateRange:range];
}

- (SChartLineSeries *)lineSeries
{
    if (!_lineSeries) {
        _lineSeries = [SChartLineSeries new];
        _lineSeries.style.lineWidth = @4;
    }
    return _lineSeries;
}

#pragma mark - SChartDatasource methods
- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 1;
}

- (SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index
{
    return self.lineSeries;
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
