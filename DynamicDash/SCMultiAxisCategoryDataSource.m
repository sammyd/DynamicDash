//
//  SCMultiAxisCategoryDataSource.m
//  DynamicDash
//
//  Created by Sam Davies on 07/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCMultiAxisCategoryDataSource.h"
#import "SCNoSpaceCategoryAxis.h"
#import <POP/POP.h>

@interface SCMultiAxisCategoryDataSource () <SChartDatasource, SChartDelegate>

@property (nonatomic, strong, readwrite) ShinobiChart *chart;
@property (nonatomic, strong, readwrite) NSArray *categories;
@property (nonatomic, strong, readwrite) NSArray *yAxes;
@property (nonatomic, strong) NSArray *datapoints;
@property (nonatomic, strong) SChartLineSeries *lineSeries;
@property (nonatomic, strong) SChartColumnSeries *columnSeries;
@property (nonatomic, strong) POPAnimatableProperty *animateableValuesProperty;


@end

@implementation SCMultiAxisCategoryDataSource

- (instancetype)initWithChart:(ShinobiChart *)chart categories:(NSArray *)categories
{
    self = [super init];
    if(self) {
        [self prepareChart:chart];
        self.categories = categories;
        [self prepareDataPoints];
        
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

#pragma mark - API Methods
- (void)animateToValues:(NSArray *)values
{
    [self validateValues:values];

    [values enumerateObjectsUsingBlock:^(NSArray *dpValues, NSUInteger seriesIdx, BOOL *oStop) {
        [dpValues enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger dataIdx, BOOL *iStop) {
            SChartDataPoint *dp = self.datapoints[seriesIdx][dataIdx];
            [self animateDataPoint:dp toValue:value];
        }];
    }];
}

- (void)animateToValuesInDictionary:(NSDictionary *)dict
{
    // We fail silently in all cases
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *values, BOOL *oStop) {
        // If there aren't enough elements in the array, skip it
        if([values count] == 2) {
            NSUInteger dataIndex = [self.categories indexOfObject:key];
            if(dataIndex != NSNotFound) {
                [values enumerateObjectsUsingBlock:^(NSNumber *val, NSUInteger seriesIdx, BOOL *iStop) {
                    [self animateDataPoint:self.datapoints[seriesIdx][dataIndex] toValue:val];
                }];
            }
        }
    }];
}

- (void)applyTheme:(id<SCColourTheme>)theme
{
    self.lineSeries.style.lineColor = theme.midLightColour;
    self.lineSeries.style.lineWidth = @4;
    self.columnSeries.style.areaColor = theme.midDarkColour;
    self.columnSeries.style.areaColorGradient = theme.midDarkColour;
    self.columnSeries.style.dataPointLabelStyle.textColor = theme.darkColour;
    
    SChartAxis *leftYAxis = self.yAxes[0];
    leftYAxis.style.majorTickStyle.showLabels = NO;
    
    SChartAxis *rightYAxis = self.yAxes[1];
    rightYAxis.style.majorTickStyle.textAlignment = NSTextAlignmentLeft;
}


#pragma mark - Non-public methods
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


- (void)prepareChart:(ShinobiChart *)chart
{
    SChartCategoryAxis *xAxis = [SCNoSpaceCategoryAxis new];
    xAxis.style.majorTickStyle.tickLabelOrientation = TickLabelOrientationVertical;
    chart.xAxis = xAxis;
    
    SChartNumberAxis *firstYAxis = [SChartNumberAxis new];
    [chart addYAxis:firstYAxis];
    firstYAxis.rangePaddingHigh = @(5000);
    SChartNumberAxis *secondYAxis = [SChartNumberAxis new];
    secondYAxis.axisPosition = SChartAxisPositionReverse;
    secondYAxis.rangePaddingHigh = @(2);
    [chart addYAxis:secondYAxis];
    self.yAxes = @[firstYAxis, secondYAxis];
    
    chart.datasource = self;
    chart.delegate = self;
    
    self.chart = chart;
}

- (void)prepareDataPoints
{
    // Want a 2-dimensional array. series x datapoints
    NSMutableArray *series = [NSMutableArray array];
    for(NSUInteger seriesIdx = 0; seriesIdx < 2; seriesIdx ++) {
        NSMutableArray *datapoints = [NSMutableArray array];
        [self.categories enumerateObjectsUsingBlock:^(NSString *category, NSUInteger idx, BOOL *stop) {
            SChartDataPoint *dp = [SChartDataPoint new];
            dp.xValue = category;
            dp.yValue = @0;
            [datapoints addObject:dp];
        }];
        [series addObject:[datapoints copy]];
    }
    self.datapoints = [series copy];
}

- (void)validateValues:(NSArray *)values
{
    if([values count] != 2) {
        NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
                                                  reason:@"There should be data for 2 series provided in the values array"
                                                userInfo:nil];
        @throw ex;
    }
    
    [values enumerateObjectsUsingBlock:^(NSArray *seriesValues, NSUInteger idx, BOOL *stop) {
        if([seriesValues count] != [self.categories count]) {
            NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
                                                      reason:@"Each array of series data should contain the same number values as categories"
                                                    userInfo:nil];
            @throw ex;
        }
    }];
}

- (SChartLineSeries *)lineSeries
{
    if(!_lineSeries) {
        _lineSeries = [SChartLineSeries new];
        _lineSeries.baseline = @0;
    }
    return _lineSeries;
}

- (SChartColumnSeries *)columnSeries
{
    if(!_columnSeries) {
        _columnSeries = [SChartColumnSeries new];
        _columnSeries.baseline = @0;
        _columnSeries.style.dataPointLabelStyle.showLabels = YES;
        _columnSeries.style.dataPointLabelStyle.offsetFromDataPoint = CGPointMake(0, -10);
    }
    return _columnSeries;
}


#pragma mark - SChartDatasource methods
- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 2;
}

- (SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return self.columnSeries;
            break;
        case 1:
            return self.lineSeries;
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
    return [self.datapoints[seriesIndex] count];
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex
{
    return self.datapoints[seriesIndex][dataIndex];
}

- (SChartAxis *)sChart:(ShinobiChart *)chart yAxisForSeriesAtIndex:(NSInteger)index
{
    return self.yAxes[index];
}

#pragma mark - SChartDelegate methods
- (void)sChart:(ShinobiChart *)chart alterTickMark:(SChartTickMark *)tickMark beforeAddingToAxis:(SChartAxis *)axis
{
    if([axis isEqual:self.chart.xAxis]) {
        CGPoint centre = tickMark.tickLabel.center;
        centre.y -= tickMark.tickLabel.bounds.size.width + [axis spaceRequiredToDrawWithTitle:NO] + 5;
        tickMark.tickLabel.center = centre;
    }
}

- (void)sChart:(ShinobiChart *)chart alterDataPointLabel:(SChartDataPointLabel *)label forDataPoint:(SChartDataPoint *)dataPoint inSeries:(SChartSeries *)series
{
    CGFloat value = [dataPoint.yValue floatValue] / 1000.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%0.1fk", value];
}

@end
