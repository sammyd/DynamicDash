//
//  SCRangeHighlightChart.m
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCRangeHighlightChart.h"
#import <POP/POP.h>

@interface SCRangeHighlightChart () <SChartDatasource>

@property (nonatomic, strong) NSArray *datapoints;
@property (nonatomic, strong) SChartLineSeries *lineSeries;
@property (nonatomic, strong) SChartAnnotationZooming *highlight;
@property (nonatomic, strong) POPAnimatableProperty *animateableAnnotationMinX;
@property (nonatomic, strong) POPAnimatableProperty *animateableAnnotationMaxX;

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
    [self moveHighlightToStart:nil end:nil];
    
    self.animateableAnnotationMinX = [POPAnimatableProperty propertyWithName:@"com.shinobicharts.annotation.minx" initializer:^(POPMutableAnimatableProperty *prop) {
        // read value
        prop.readBlock = ^(SChartAnnotationZooming *annotation, CGFloat values[]) {
            values[0] = [annotation.xValue timeIntervalSince1970];
        };
        // write value
        prop.writeBlock = ^(SChartAnnotationZooming *annotation, const CGFloat values[]) {
            annotation.xValue = [NSDate dateWithTimeIntervalSince1970:values[0]];
            [self redrawChart];
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];
    
    self.animateableAnnotationMaxX = [POPAnimatableProperty propertyWithName:@"com.shinobicharts.annotation.maxx" initializer:^(POPMutableAnimatableProperty *prop) {
        // read value
        prop.readBlock = ^(SChartAnnotationZooming *annotation, CGFloat values[]) {
            values[0] = [annotation.xValueMax timeIntervalSince1970];
        };
        // write value
        prop.writeBlock = ^(SChartAnnotationZooming *annotation, const CGFloat values[]) {
            annotation.xValueMax = [NSDate dateWithTimeIntervalSince1970:values[0]];
            [self redrawChart];
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];
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
    self.yAxis.style.lineColor = theme.midLightColour;
    self.yAxis.style.lineWidth = @2;
    self.xAxis.style.majorTickStyle.labelColor = theme.lightColour;
    self.yAxis.style.majorTickStyle.labelColor = theme.lightColour;
    self.highlight.backgroundColor = [theme.lightColour colorWithAlphaComponent:0.5];
    
    [self redrawChart];
}

- (void)moveHighlightToStart:(NSDate *)start end:(NSDate *)end
{
    if(!self.highlight) {
        self.highlight = [SChartAnnotation verticalBandAtPosition:start andMaxX:end withXAxis:self.xAxis andYAxis:self.yAxis withColor:[UIColor whiteColor]];
        [self addAnnotation:self.highlight];
    }
    POPSpringAnimation *minAnim = [POPSpringAnimation animation];
    minAnim.property = self.animateableAnnotationMinX;
    minAnim.toValue = @([start timeIntervalSince1970]);
    minAnim.springBounciness = 4.0;
    minAnim.springSpeed = 4.0;
    [self.highlight pop_addAnimation:minAnim forKey:@"MinValueAnimation"];
    
    POPSpringAnimation *maxAnim = [POPSpringAnimation animation];
    maxAnim.property = self.animateableAnnotationMaxX;
    maxAnim.toValue = @([end timeIntervalSince1970]);
    maxAnim.springBounciness = 4.0;
    maxAnim.springSpeed = 4.0;
    [self.highlight pop_addAnimation:maxAnim forKey:@"MaxValueAnimation"];
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
