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
#import "SCBlueColourTheme.h"
#import "SCGreenColourTheme.h"
#import "SCRedColourTheme.h"
#import "SCColourableChartTheme.h"
#import "SGauge+SpringAnimation.h"
#import "SGauge+ColourTheme.h"
#import "SCAnimatingPieChartDatasource.h"
#import "NSDate+Quarterly.h"
#import "SCSIMultiplierGaugeLabelDelegate.h"

@interface SCViewController ()

@property (nonatomic, strong) SCNorthwindData *northwind;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *categoryDatasource;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *employeeDatasource;
@property (nonatomic, strong) SCAnimatingPieChartDatasource *shippersDatasource;
@property (nonatomic, strong) SCSIMultiplierGaugeLabelDelegate *gaugeDelegate;

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.northwind = [SCNorthwindData new];
    self.categoryDatasource = [[SCMultiAxisCategoryDataSource alloc] initWithChart:self.categoryChart categories:[self.northwind productCategories]];
    self.categoryChart.title = @"Orders/Sales per Category";
    
    self.employeeDatasource = [[SCMultiAxisCategoryDataSource alloc] initWithChart:self.employeeChart categories:[self.northwind employeeNames]];
    self.employeeChart.title = @"Orders/Sales per Employee";
    
    self.shippersDatasource = [[SCAnimatingPieChartDatasource alloc] initWithChart:self.shippersChart categories:[self.northwind shippers]];
    
    [self setColourTheme:[SCBlueColourTheme new]];
    
    self.gaugeDelegate = [SCSIMultiplierGaugeLabelDelegate new];
    self.ordersGauge.minimumValue = @0;
    self.ordersGauge.maximumValue = @450;
    self.ordersGauge.delegate = self.gaugeDelegate;
    self.salesGauge.minimumValue = @0;
    self.salesGauge.maximumValue = @300000;
    self.salesGauge.delegate = self.gaugeDelegate;
    
    [self.weeklySalesChart setData:[self.northwind salesPerWeek]];
    
    
    [self setYear:1997 quarter:1];
}

- (void)setYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    NSDictionary *categorySales = [self.northwind salesPerCategoryForYear:year quarter:quarter];
    NSDictionary *categoryOrders = [self.northwind ordersPerCategoryForYear:year quarter:quarter];
    NSMutableDictionary *newCategoryValues = [NSMutableDictionary new];
    [self.categoryDatasource.categories enumerateObjectsUsingBlock:^(NSString *category, NSUInteger idx, BOOL *stop) {
        NSNumber *sales = categorySales[category] ? categorySales[category] : @0;
        NSNumber *orders = categoryOrders[category] ? categoryOrders[category] : @0;
        NSArray *newValues = @[sales, orders];
        newCategoryValues[category] = newValues;
    }];
    
    [self.categoryDatasource animateToValuesInDictionary:[newCategoryValues copy]];
    
    
    NSDictionary *employeeSales = [self.northwind salesPerEmployeeForYear:year quarter:quarter];
    NSDictionary *employeeOrders = [self.northwind ordersPerEmployeeForYear:year quarter:quarter];
    NSMutableDictionary *newEmployeeValues = [NSMutableDictionary new];
    [self.employeeDatasource.categories enumerateObjectsUsingBlock:^(NSString *employee, NSUInteger idx, BOOL *stop) {
        NSNumber *sales = employeeSales[employee] ? employeeSales[employee] : @0;
        NSNumber *orders = employeeOrders[employee] ? employeeOrders[employee] : @0;
        NSArray *newValues = @[sales, orders];
        newEmployeeValues[employee] = newValues;
    }];
    
    [self.employeeDatasource animateToValuesInDictionary:[newEmployeeValues copy]];
    
    
    [self.salesGauge springAnimateToValue:[[self.northwind totalSalesForYear:year quarter:quarter] floatValue]];
    [self.ordersGauge springAnimateToValue:[[self.northwind totalOrdersForYear:year quarter:quarter] floatValue]];
    
    NSDictionary *shipperOrders = [self.northwind ordersPerShipperForYear:year quarter:quarter];
    [self.shippersDatasource animateToValuesInDictionary:shipperOrders];
    
    
    SChartDateRange *quarterDateRange = [[SChartDateRange alloc] initWithDateMinimum:[NSDate firstDayOfQuarter:quarter year:year]
                                                                      andDateMaximum:[NSDate lastDayOfQuarter:quarter year:year]];
    [self.weeklySalesChart moveHighlightToDateRange:quarterDateRange];
}

#pragma mark - Utility Methods
- (void)setColourTheme:(id<SCColourTheme>)colourTheme
{
    self.view.backgroundColor = colourTheme.darkColour;
    [self.categoryChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.categoryDatasource applyThemeColours:@[colourTheme.midColour, colourTheme.midLightColour,
                                                 colourTheme.midDarkColour, colourTheme.darkColour]];
    [self.employeeChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.employeeDatasource applyThemeColours:@[colourTheme.midLightColour, colourTheme.midColour,
                                                 colourTheme.midDarkColour, colourTheme.darkColour]];
    [self.shippersChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.shippersDatasource applyTheme:colourTheme];
    [self.weeklySalesChart applyColourTheme:colourTheme];
    
    // Apply theme to the gauge
    [self.salesGauge applyColourTheme:colourTheme];
    self.salesGauge.backgroundColor = colourTheme.midLightColour;
    [self.ordersGauge applyColourTheme:colourTheme];
    self.ordersGauge.backgroundColor = colourTheme.lightColour;
}

- (IBAction)handleSegmentChanged:(id)sender {
    if(sender == self.colourSegment) {
        id<SCColourTheme> colourTheme;
        switch (self.colourSegment.selectedSegmentIndex) {
            case 0:
                colourTheme = [SCBlueColourTheme new];
                break;
            case 1:
                colourTheme = [SCGreenColourTheme new];
                break;
            case 2:
                colourTheme = [SCRedColourTheme new];
                break;
            default:
                break;
        }
        if(colourTheme) {
            [self setColourTheme:colourTheme];
        }
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
