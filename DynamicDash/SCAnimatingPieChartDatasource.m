//
//  SCAnimatingPieChartDatasource.m
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCAnimatingPieChartDatasource.h"
#import <POP/POP.h>

@interface SCAnimatingPieChartDatasource () <SChartDatasource, SChartDelegate>

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *datapoints;
@property (nonatomic, strong) ShinobiChart *chart;
@property (nonatomic, strong) POPAnimatableProperty *animateableValuesProperty;

@end

@implementation SCAnimatingPieChartDatasource

- (instancetype)initWithChart:(ShinobiChart *)chart categories:(NSArray *)categories
{
    self = [super init];
    if(self) {
        self.categories = categories;
        self.chart = chart;
        self.chart.datasource = self;
        self.chart.delegate = self;
        [self prepareDatapoints];
        
        self.springBounciness = 16.0;
        self.springSpeed = 4.0;
        self.animateableValuesProperty = [POPAnimatableProperty propertyWithName:@"com.shinobicontrols.popgoesshinobi.animatingdatasource" initializer:^(POPMutableAnimatableProperty *prop) {
            // read value
            prop.readBlock = ^(SChartDataPoint *dp, CGFloat values[]) {
                values[0] = [dp.yValue floatValue];
            };
            // write value
            prop.writeBlock = ^(SChartDataPoint *dp, const CGFloat values[]) {
                dp.yValue = @(MAX(values[0], 0));
                [self.chart reloadData];
                [self.chart redrawChart];
            };
            // dynamics threshold
            prop.threshold = 0.01;
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
            [self animateDataPoint:self.datapoints[dataIndex] toValue:value];
        }
    }];
}

#pragma mark - Utility methods
- (void)animateDataPoint:(SChartDataPoint *)dp toValue:(NSNumber *)value
{
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = self.animateableValuesProperty;
    anim.fromValue = dp.yValue;
    anim.toValue = value;
    anim.springBounciness = self.springBounciness;
    anim.springSpeed = self.springSpeed;
    
    [dp pop_addAnimation:anim forKey:@"ValueChangeAnimation"];
}

#pragma mark - SChartDataSource methods
- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 1;
}

- (SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index
{
    return [SChartPieSeries new];
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
    return [self.datapoints count];
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex
{
    return self.datapoints[dataIndex];
}

#pragma mark - SChartDelegate methods
- (void)sChart:(ShinobiChart *)chart alterLabel:(UILabel *)label forDatapoint:(SChartRadialDataPoint *)datapoint atSliceIndex:(NSInteger)index inRadialSeries:(SChartRadialSeries *)series
{
    label.text = datapoint.name;
    [label sizeToFit];
}

@end
