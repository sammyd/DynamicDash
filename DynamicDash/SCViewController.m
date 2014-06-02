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
#import "SCMultiAxisCategoryDataSource.h"
#import "SCColourThemeManager.h"
#import "SCColourableChartTheme.h"
#import "SGauge+SpringAnimation.h"
#import "SGauge+ColourTheme.h"
#import "SCAnimatingPieChartDatasource.h"
#import "NSDate+Quarterly.h"
#import "SCSIMultiplierGaugeLabelDelegate.h"

@interface SCViewController () <SCRangeHighlightChartDelegate>

@property (nonatomic, strong) SCNorthwindData *northwind;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *categoryDatasource;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *employeeDatasource;
@property (nonatomic, strong) SCAnimatingPieChartDatasource *shippersDatasource;
@property (nonatomic, strong) SCSIMultiplierGaugeLabelDelegate *gaugeDelegate;
@property (nonatomic, strong) SCColourThemeManager *colourThemeManager;

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.northwind = [SCNorthwindData new];
    self.categoryDatasource = [[SCMultiAxisCategoryDataSource alloc] initWithChart:self.categoryChart categories:[self.northwind productCategories]];
    self.categoryChart.title = @"Orders/Sales per Category";
    [self.categoryChart.allYAxes[0] setTitle:@"Sales ($k)"];
    [self.categoryChart.allYAxes[1] setTitle:@"Orders"];
    
    
    self.employeeDatasource = [[SCMultiAxisCategoryDataSource alloc] initWithChart:self.employeeChart categories:[self.northwind employeeNames]];
    self.employeeChart.title = @"Orders/Sales per Employee";
    [self.employeeChart.allYAxes[0] setTitle:@"Sales ($k)"];
    [self.employeeChart.allYAxes[1] setTitle:@"Orders"];
    
    self.shippersDatasource = [[SCAnimatingPieChartDatasource alloc] initWithChart:self.shippersChart categories:[self.northwind shippers]];
    
    self.colourThemeManager = [SCColourThemeManager new];
    
    [self setColourThemeWithName:@"blue"];
    
    self.gaugeDelegate = [SCSIMultiplierGaugeLabelDelegate new];
    self.ordersGauge.minimumValue = @0;
    self.ordersGauge.maximumValue = @450;
    self.ordersGauge.delegate = self.gaugeDelegate;
    self.salesGauge.minimumValue = @0;
    self.salesGauge.maximumValue = @300000;
    self.salesGauge.delegate = self.gaugeDelegate;
    
    [self.weeklySalesChart setData:[self.northwind salesPerWeek]];
    self.weeklySalesChart.title = @"Weekly Sales Totals";
    self.weeklySalesChart.rangeDelegate = self;
    
    
    [self setYear:1997 quarter:1];
}

- (void)setYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    [self setVisibleDatesFrom:[NSDate firstDayOfQuarter:quarter year:year]
                       toDate:[NSDate lastDayOfQuarter:quarter year:year]];
    
    [self.salesGauge springAnimateToValue:[[self.northwind totalSalesForYear:year quarter:quarter] floatValue]];
    [self.ordersGauge springAnimateToValue:[[self.northwind totalOrdersForYear:year quarter:quarter] floatValue]];
    
    NSDictionary *shipperOrders = [self.northwind ordersPerShipperForYear:year quarter:quarter];
    [self.shippersDatasource animateToValuesInDictionary:shipperOrders];
}

- (void)setVisibleDatesFrom:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSDictionary *categorySales = [self.northwind salesPerCategoryFromDate:fromDate toDate:toDate];
    NSDictionary *categoryOrders = [self.northwind ordersPerCategoryFromDate:fromDate toDate:toDate];
    NSMutableDictionary *newCategoryValues = [NSMutableDictionary new];
    [self.categoryDatasource.categories enumerateObjectsUsingBlock:^(NSString *category, NSUInteger idx, BOOL *stop) {
        NSNumber *sales = categorySales[category] ? categorySales[category] : @0;
        NSNumber *orders = categoryOrders[category] ? categoryOrders[category] : @0;
        NSArray *newValues = @[sales, orders];
        newCategoryValues[category] = newValues;
    }];
    
    [self.categoryDatasource animateToValuesInDictionary:[newCategoryValues copy]];
    
    NSDictionary *employeeSales = [self.northwind salesPerEmployeeFromDate:fromDate toDate:toDate];
    NSDictionary *employeeOrders = [self.northwind ordersPerEmployeeFromDate:fromDate toDate:toDate];
    NSMutableDictionary *newEmployeeValues = [NSMutableDictionary new];
    [self.employeeDatasource.categories enumerateObjectsUsingBlock:^(NSString *employee, NSUInteger idx, BOOL *stop) {
        NSNumber *sales = employeeSales[employee] ? employeeSales[employee] : @0;
        NSNumber *orders = employeeOrders[employee] ? employeeOrders[employee] : @0;
        NSArray *newValues = @[sales, orders];
        newEmployeeValues[employee] = newValues;
    }];
    
    [self.employeeDatasource animateToValuesInDictionary:[newEmployeeValues copy]];
    
    SChartDateRange *dateRange = [[SChartDateRange alloc] initWithDateMinimum:fromDate
                                                               andDateMaximum:toDate];
    [self.weeklySalesChart moveHighlightToDateRange:dateRange];
}

#pragma mark - SChartRangeHighlightChartDelegate methods
- (void)rangeHighlightChart:(SCRangeHighlightChart *)chart didSelectDateRange:(SChartDateRange *)range
{
    [self setVisibleDatesFrom:range.minimumAsDate toDate:range.maximumAsDate];
}

#pragma mark - Utility Methods
- (void)setColourThemeWithName:(NSString *)themeName
{
    id<SCColourTheme> colourTheme = [self.colourThemeManager colourThemeWithName:[themeName lowercaseString]];
    if(colourTheme) {
        [self setColourTheme:colourTheme];
    }
}

- (void)setColourTheme:(id<SCColourTheme>)colourTheme
{
    self.view.backgroundColor = colourTheme.darkColour;
    self.view.tintColor = colourTheme.lightColour;
    
    // Date drill-down section & charts
    self.dateDrillDownContainer.backgroundColor = colourTheme.midLightColour;
    
    [self.categoryChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.categoryDatasource applyThemeColours:@[colourTheme.midColour, [UIColor clearColor]]];
    [self.employeeChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.employeeDatasource applyThemeColours:@[colourTheme.midColour, [UIColor clearColor]]];
    [self.shippersChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.shippersDatasource applyTheme:colourTheme];
    [self.weeklySalesChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.weeklySalesChart applyColourTheme:colourTheme];
    
    // Apply theme to the gauge
    [self.salesGauge applyColourTheme:colourTheme];
    self.salesGauge.backgroundColor = colourTheme.midLightColour;
    [self.ordersGauge applyColourTheme:colourTheme];
    self.ordersGauge.backgroundColor = colourTheme.lightColour;
    
    // And the title labels in the storyboard
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.textColor = colourTheme.darkColour;
    }];
}

- (IBAction)handleSegmentChanged:(id)sender {
    if(sender == self.colourSegment) {
        NSString *themeName = [self.colourSegment titleForSegmentAtIndex:self.colourSegment.selectedSegmentIndex];
        [self setColourThemeWithName:themeName];
    } else {
        [self setYear:(self.yearSegment.selectedSegmentIndex + 1996)
              quarter:(self.quarterSegment.selectedSegmentIndex + 1)];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
