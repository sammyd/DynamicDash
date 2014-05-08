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

@interface SCViewController ()

@property (nonatomic, strong) SCNorthwindData *northwind;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *categoryDatasource;
@property (nonatomic, strong) SCMultiAxisCategoryDataSource *employeeDatasource;

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.northwind = [SCNorthwindData new];
    self.categoryDatasource = [[SCMultiAxisCategoryDataSource alloc] initWithChart:self.categoryChart categories:[self.northwind productCategories]];
    
    self.employeeDatasource = [[SCMultiAxisCategoryDataSource alloc] initWithChart:self.employeeChart categories:[self.northwind employeeNames]];
    
    [self setYear:1997 quarter:1];
}

- (void)setYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    NSDictionary *categorySales = [self.northwind salesPerCategoryForYear:year quarter:quarter];
    NSDictionary *categoryOrders = [self.northwind ordersPerCategoryForYear:year quarter:quarter];
    NSMutableDictionary *newCategoryValues = [NSMutableDictionary new];
    [self.categoryDatasource.categories enumerateObjectsUsingBlock:^(NSString *category, NSUInteger idx, BOOL *stop) {
        NSArray *newValues = @[categorySales[category], categoryOrders[category]];
        newCategoryValues[category] = newValues;
    }];
    
    [self.categoryDatasource animateToValuesInDictionary:[newCategoryValues copy]];
    
    
    NSDictionary *employeeSales = [self.northwind salesPerEmployeeForYear:year quarter:quarter];
    NSDictionary *employeeOrders = [self.northwind ordersPerEmployeeForYear:year quarter:quarter];
    NSMutableDictionary *newEmployeeValues = [NSMutableDictionary new];
    [self.employeeDatasource.categories enumerateObjectsUsingBlock:^(NSString *employee, NSUInteger idx, BOOL *stop) {
        NSArray *newValues = @[employeeSales[employee], employeeOrders[employee]];
        newEmployeeValues[employee] = newValues;
    }];
    
    [self.employeeDatasource animateToValuesInDictionary:[newEmployeeValues copy]];
}

@end
