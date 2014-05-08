//
//  SCNorthwindData.m
//  DynamicDash
//
//  Created by Sam Davies on 06/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCNorthwindData.h"
#import <sqlite3-objc/Sqlite3/Sqlite.h>
#import <ShinobiCharts/ShinobiChart.h>
#import "NSDate+Quarterly.h"

@interface SCNorthwindData ()

@property (nonatomic, strong) SLDatabase *database;
@property (nonatomic, strong) NSDateFormatter *ymdDF;

@end


@implementation SCNorthwindData

- (instancetype)init
{
    self = [super init];
    if(self) {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"northwind" ofType:@"sqlite"];
        self.database = [SLDatabase databaseWithFile:path error:&error];
        if(error) {
            NSLog(@"There was an error: %@", error);
            return nil;
        }
    }
    return self;
}

- (NSArray *)invoiceData
{
    NSError *error;
    SLStatement *statement = [self.database prepareQuery:@"SELECT * FROM 'Summary of Sales by Year' ORDER BY ShippedDate ASC" error:&error];
    if(error) {
        NSLog(@"There was an error with the query %@", error);
        return nil;
    }
    
    static NSDateFormatter *dateFormatter = nil;
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    
    NSMutableArray *datapoints = [NSMutableArray new];
    
    for(NSDictionary *result in statement) {
        SChartDataPoint *dp = [SChartDataPoint new];
        dp.xValue = [dateFormatter dateFromString:result[@"ShippedDate"]];
        dp.yValue = result[@"Subtotal"];
        [datapoints addObject:dp];
    }
    
    return [datapoints copy];
}


- (NSArray *)employeeNames
{
    return [self executeQuery:@"SELECT FirstName, LastName FROM Employees"
                      withMap:^id(NSDictionary *row) {
        return [NSString stringWithFormat:@"%@ %@", row[@"FirstName"], row[@"LastName"]];
    }];
}

- (NSArray *)productCategories
{
    return [self executeQuery:@"SELECT CategoryName FROM Categories"
                      withMap:^id(NSDictionary *row) {
                          return row[@"CategoryName"];
    }];
}

- (NSDateFormatter *)ymdDF
{
    if(!_ymdDF) {
        _ymdDF = [NSDateFormatter new];
        _ymdDF.dateFormat = @"yyyy-MM-dd";
    }
    return _ymdDF;
}

- (NSArray *)salesPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    NSString *queryString = [NSString stringWithFormat:
        @"SELECT Categories.CategoryName, "
        "Sum(([Order Details].UnitPrice*Quantity*(1-Discount)/100)*100) AS CategorySales "
        "FROM Categories "
        "JOIN    Products On Categories.CategoryID = Products.CategoryID "
        "JOIN  [Order Details] on Products.ProductID = [Order Details].ProductID "
        "JOIN  [Orders] on Orders.OrderID = [Order Details].OrderID "
        "WHERE Orders.ShippedDate Between DATETIME('%@') And DATETIME('%@')"
        "GROUP BY Categories.CategoryName",
                     [self.ymdDF stringFromDate:[NSDate firstDayOfQuarter:quarter year:year]],
                     [self.ymdDF stringFromDate:[NSDate lastDayOfQuarter:quarter year:year]]];
    
    return [self executeQuery:queryString
                      withMap:^id(NSDictionary *row) {
                          return row;
                      }];
}

- (NSArray *)salesPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    NSString *queryString = [NSString stringWithFormat:
         @"SELECT Employees.FirstName, Employees.LastName, "
         "Sum(([Order Details].UnitPrice*Quantity*(1-Discount)/100)*100) AS EmployeeSales "
         "FROM Employees "
         "JOIN  Orders On Orders.EmployeeID = Employees.EmployeeID "
         "JOIN   [Order Details] on Orders.OrderID = [Order Details].OrderID "
         "WHERE Orders.ShippedDate Between DATETIME('%@') And DATETIME('%@')"
         "GROUP BY Employees.EmployeeID",
                     [self.ymdDF stringFromDate:[NSDate firstDayOfQuarter:quarter year:year]],
                     [self.ymdDF stringFromDate:[NSDate lastDayOfQuarter:quarter year:year]]];
    
    return [self executeQuery:queryString
                      withMap:^id(NSDictionary *row) {
                          return row;
                      }];
}

- (NSArray *)ordersPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    NSString *queryString = [NSString stringWithFormat:
         @"SELECT Categories.CategoryName, "
         "Count(Orders.OrderID) AS CategoryOrders "
         "FROM Categories "
         "JOIN    Products On Categories.CategoryID = Products.CategoryID "
         "JOIN  [Order Details] on Products.ProductID = [Order Details].ProductID "
         "JOIN  [Orders] on Orders.OrderID = [Order Details].OrderID "
         "WHERE Orders.ShippedDate Between DATETIME('%@') And DATETIME('%@')"
         "GROUP BY Categories.CategoryName",
                     [self.ymdDF stringFromDate:[NSDate firstDayOfQuarter:quarter year:year]],
                     [self.ymdDF stringFromDate:[NSDate lastDayOfQuarter:quarter year:year]]];
    
    return [self executeQuery:queryString
                      withMap:^id(NSDictionary *row) {
                          return row;
                      }];

}

- (NSArray *)ordersPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    NSString *queryString = [NSString stringWithFormat:
         @"SELECT Employees.FirstName, Employees.LastName, "
         "Count(Orders.OrderID) AS EmployeeOrders "
         "FROM Employees "
         "JOIN    Orders On Orders.EmployeeID = Employees.EmployeeID "
         "WHERE Orders.ShippedDate Between DATETIME('%@') And DATETIME('%@')"
         "GROUP BY Employees.EmployeeID",
                     [self.ymdDF stringFromDate:[NSDate firstDayOfQuarter:quarter year:year]],
                     [self.ymdDF stringFromDate:[NSDate lastDayOfQuarter:quarter year:year]]];
    
    return [self executeQuery:queryString
                      withMap:^id(NSDictionary *row) {
                          return row;
                      }];
}


#pragma mark - Non-API methods
- (SLStatement *)executeQuery:(NSString *)query
{
    NSError *error;
    SLStatement *statement = [self.database prepareQuery:query error:&error];
    if(error) {
        NSLog(@"There was an error with the query %@", error);
        return nil;
    }
    return statement;
}

- (NSArray *)executeQuery:(NSString *)query withMap:(id(^)(NSDictionary *row))map
{
    NSMutableArray *mappedResults = [NSMutableArray array];
    for(NSDictionary *row in [self executeQuery:query]) {
        [mappedResults addObject:map(row)];
    }
    return [mappedResults copy];
}

- (NSArray *)allValuesForQuery:(NSString *)query
{
    return [[self executeQuery:query] allRows];
}

@end
