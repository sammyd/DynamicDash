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
#import "SCColourableChartTheme.h"
#import "SGauge+SpringAnimation.h"
#import "SCAnimatingPieChartDatasource.h"

@interface SCViewController ()

@property (nonatomic, strong) SCNorthwindData *northwind;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *categoryDatasource;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *employeeDatasource;
@property (nonatomic, strong) SCAnimatingPieChartDatasource *shippersDatasource;

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.northwind = [SCNorthwindData new];
    self.categoryDatasource = [[SCMultiAxisCategoryDataSource alloc] initWithChart:self.categoryChart categories:[self.northwind productCategories]];
    
    self.employeeDatasource = [[SCMultiAxisCategoryDataSource alloc] initWithChart:self.employeeChart categories:[self.northwind employeeNames]];
    
    self.shippersDatasource = [[SCAnimatingPieChartDatasource alloc] initWithChart:self.shippersChart categories:[self.northwind shippers]];
    
    [self setColourTheme:[SCBlueColourTheme new]];
    
    self.ordersGauge.minimumValue = @0;
    self.ordersGauge.maximumValue = @450;
    self.salesGauge.minimumValue = @0;
    self.salesGauge.maximumValue = @300000;
    
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
}

#pragma mark - Utility Methods
- (void)setColourTheme:(id<SCColourTheme>)colourTheme
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.categoryChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.categoryDatasource applyTheme:colourTheme];
    self.categoryChart.backgroundColor = colourTheme.midLightColour;
    [self.employeeChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.employeeDatasource applyTheme:colourTheme];
    self.employeeChart.backgroundColor = colourTheme.midColour;
    [self.shippersChart applyTheme:[SCColourableChartTheme themeWithColourTheme:colourTheme]];
    [self.shippersDatasource applyTheme:colourTheme];
    [self.weeklySalesChart applyColourTheme:colourTheme];
    
    // Apply theme to the gauge
    [self styleGauge:self.salesGauge withColourTheme:colourTheme background:colourTheme.midLightColour];
    [self styleGauge:self.ordersGauge withColourTheme:colourTheme background:colourTheme.lightColour];
    
}

- (IBAction)handleSegmentChanged:(id)sender {
    [self setYear:(self.yearSegment.selectedSegmentIndex + 1996)
          quarter:(self.quarterSegment.selectedSegmentIndex + 1)];
}

- (void)styleGauge:(SGauge *)gauge withColourTheme:(id<SCColourTheme>)colourTheme background:(UIColor *)bgColour
{
    gauge.style.bevelWidth = 5;
    gauge.style.showGlassEffect = NO;
    gauge.style.bevelPrimaryColor = [UIColor clearColor];
    gauge.style.bevelSecondaryColor = [UIColor clearColor];
    gauge.style.innerBackgroundColor = [UIColor clearColor];
    gauge.style.outerBackgroundColor = [UIColor clearColor];
    gauge.style.needleBorderWidth = 0;
    gauge.style.needleColor = colourTheme.midDarkColour;
    gauge.style.tickLabelColor = colourTheme.darkColour;
    gauge.style.tickBaselineColor = colourTheme.darkColour;
    gauge.style.majorTickColor = colourTheme.darkColour;
    gauge.style.knobColor = colourTheme.darkColour;
    gauge.style.knobBorderWidth = 0;
    gauge.style.knobRadius = 10;
    gauge.style.needleWidth = 12;
    gauge.backgroundColor = bgColour;
}
@end
