//
//  SCViewController.m
//  DynamicDash
//
//  Created by Sam Davies on 05/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCViewController.h"
#import "SCNorthwindData.h"
#import "SCMultiAxisCategoryDataSource.h"
#import "SCColourThemeManager.h"
#import "SCColourableChartTheme.h"
#import "SGauge+SpringAnimation.h"
#import "SGauge+ColourTheme.h"
#import "SCAnimatingPieChartDatasource.h"
#import "NSDate+Quarterly.h"
#import "SCSIMultiplierGaugeLabelDelegate.h"
#import "SCOrdersDataProvider.h"
#import "SCDashDataGridTheme.h"

@interface SCViewController () <SCRangeHighlightChartDelegate>

@property (nonatomic, strong) SCNorthwindData *northwind;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *categoryDatasource;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *employeeDatasource;
@property (nonatomic, strong) SCAnimatingPieChartDatasource *shippersDatasource;
@property (nonatomic, strong) SCOrdersDataProvider *ordersDataProvider;
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
    // Set some titles
    self.categoryDatasource.lineSeries.title = @"Orders";
    self.categoryDatasource.columnSeries.title = @"Sales";
    self.categoryChart.title = @"Orders/Sales per Category";
    [self.categoryChart.allYAxes[0] setTitle:@"Sales ($k)"];
    [self.categoryChart.allYAxes[1] setTitle:@"Orders"];
    
    
    self.employeeDatasource = [[SCMultiAxisCategoryDataSource alloc] initWithChart:self.employeeChart categories:[self.northwind employeeNames]];
    // Set some titles
    self.employeeDatasource.lineSeries.title = @"Orders";
    self.employeeDatasource.columnSeries.title = @"Sales";
    self.employeeChart.title = @"Orders/Sales per Employee";
    [self.employeeChart.allYAxes[0] setTitle:@"Sales ($k)"];
    [self.employeeChart.allYAxes[1] setTitle:@"Orders"];
    
    [self.weeklySalesChart setData:[self.northwind salesPerWeek]];
    self.weeklySalesChart.title = @"Weekly Sales Totals";
    [self.weeklySalesChart.yAxis setTitle:@"Sales ($k)"];
    self.weeklySalesChart.rangeDelegate = self;
    
    
    self.shippersDatasource = [[SCAnimatingPieChartDatasource alloc] initWithChart:self.shippersChart categories:[self.northwind shippers]];
    
    self.gaugeDelegate = [SCSIMultiplierGaugeLabelDelegate new];
    [self prepareOrdersGaugeSinceBeginningOfYear:1998];
    
    [self setYear:1997 quarter:1];
    
    // Prepare the orders DataGrid
    NSArray *orders = [self.northwind orderDetailsFromDate:[NSDate firstDayOfQuarter:1 year:1998]
                                                    toDate:[NSDate lastDayOfQuarter:2 year:1998]];
    self.ordersDataProvider = [[SCOrdersDataProvider alloc] initWithDataGrid:self.ordersDataGrid orders:orders];
    
    // Apply the initial theme
    self.colourThemeManager = [SCColourThemeManager new];
    [self setColourThemeWithName:@"blue"];
}

- (void)setYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    [self setVisibleDatesFrom:[NSDate firstDayOfQuarter:quarter year:year]
                       toDate:[NSDate lastDayOfQuarter:quarter year:year]];
    
    NSDictionary *shipperOrders = [self.northwind ordersPerShipperForYear:year quarter:quarter];
    [self.shippersDatasource animateToValuesInDictionary:shipperOrders];
}

- (void)prepareOrdersGaugeSinceBeginningOfYear:(NSUInteger)year
{
    self.ordersGauge.minimumValue = @0;
    self.ordersGauge.maximumValue = @1000000;
    self.ordersGauge.delegate = self.gaugeDelegate;
    
    // Prepare some qualitative ranges
    NSArray *colors = @[[[UIColor redColor] colorWithAlphaComponent:0.3],
                        [[UIColor orangeColor] colorWithAlphaComponent:0.3],
                        [[UIColor yellowColor] colorWithAlphaComponent:0.3],
                        [[UIColor greenColor] colorWithAlphaComponent:0.3]
                        ];
    self.ordersGauge.qualitativeRanges = @[
                [SGaugeQualitativeRange rangeWithMinimum:nil maximum:@400000 color:colors[0]],
                [SGaugeQualitativeRange rangeWithMinimum:@400000 maximum:@6000000 color:colors[1]],
                [SGaugeQualitativeRange rangeWithMinimum:@600000 maximum:@7500000 color:colors[2]],
                [SGaugeQualitativeRange rangeWithMinimum:@750000 maximum:nil color:colors[3]]
                                           ];
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    components.month = 1;
    components.year = year;
    NSDate *start = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSNumber *value = [self.northwind totalSalesFromDate:start toDate:[NSDate date]];
    [self.ordersGauge springAnimateToValue:[value floatValue]];
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
    // Update the title
    static NSDateFormatter *titleDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        titleDateFormatter = [NSDateFormatter new];
        titleDateFormatter.dateStyle = NSDateFormatterShortStyle;
        titleDateFormatter.locale = [NSLocale systemLocale];
    });
    self.dateDrillDownTitle.text = [NSString stringWithFormat:@"Sales figures from %@ to %@",
                                    [titleDateFormatter stringFromDate:range.minimumAsDate],
                                    [titleDateFormatter stringFromDate:range.maximumAsDate]];
    
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
    self.dashboardTitle.textColor = colourTheme.darkColour;
    self.dashboardTitle.backgroundColor = colourTheme.lightColour;
    
    // Date drill-down section & charts
    self.dateDrillDownContainer.backgroundColor = colourTheme.midLightColour;
    self.dateDrillDownTitle.textColor = colourTheme.darkColour;
    self.dateDrillDownTitle.backgroundColor = colourTheme.lightColour;

    [self.categoryChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.categoryDatasource applyThemeColours:@[colourTheme.midColour, [UIColor clearColor]]];
    [self.employeeChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.employeeDatasource applyThemeColours:@[colourTheme.midColour, [UIColor clearColor]]];
    [self.shippersChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.shippersDatasource applyTheme:colourTheme];
    [self.weeklySalesChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.weeklySalesChart applyColourTheme:colourTheme];
    
    // And the summary page
    self.summaryContainer.backgroundColor = colourTheme.midColour;
    
    // Apply theme to the gauge
    [self.ordersGauge applyColourTheme:colourTheme];
    self.ordersGauge.backgroundColor = colourTheme.midLightColour;
    
    // And the title labels in the storyboard
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.textColor = colourTheme.darkColour;
    }];
    
    // Apply the theme to the datagrid
    [self.ordersDataGrid applyTheme:[SCDashDataGridTheme themeWithColourTheme:colourTheme]];
    self.ordersDataGrid.defaultHeaderRowHeight = @35;
    self.ordersDataGrid.defaultRowHeight = @25;
    self.ordersDataGrid.selectionMode = SDataGridSelectionModeNone;
    [self.ordersDataGrid reload];
}

- (IBAction)handleSegmentChanged:(id)sender {
    if(sender == self.colourSegment) {
        NSString *themeName = [self.colourSegment titleForSegmentAtIndex:self.colourSegment.selectedSegmentIndex];
        [self setColourThemeWithName:themeName];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
