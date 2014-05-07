//
//  SCViewController.m
//  DynamicDash
//
//  Created by Sam Davies on 05/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCViewController.h"
#import "SCNorthwindData.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface SCViewController () <SChartDatasource>

@property (nonatomic, strong) NSArray *datapoints;

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SCNorthwindData *data = [SCNorthwindData new];
    self.datapoints = [data invoiceData];
    
    ShinobiChart *chart = [[ShinobiChart alloc] initWithFrame:self.view.bounds withPrimaryXAxisType:SChartAxisTypeDateTime withPrimaryYAxisType:SChartAxisTypeNumber];
    chart.autoresizingMask = ~ UIViewAutoresizingNone;
    chart.datasource = self;
    [self.view addSubview:chart];
    
}

#pragma mark - SChartDatasource Methods
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
