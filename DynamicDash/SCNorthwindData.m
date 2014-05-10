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

- (NSArray *)shippers
{
    return [self executeQuery:@"SELECT CompanyName FROM Shippers"
                      withMap:^id(NSDictionary *row) {
                          return row[@"CompanyName"];
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

- (NSDictionary *)salesPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter
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
         withResultDictionary:^(NSMutableDictionary *dict, NSDictionary *row) {
             [dict setValue:row[@"CategorySales"] forKey:row[@"CategoryName"]];
         }];
}

- (NSDictionary *)salesPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter
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
         withResultDictionary:^(NSMutableDictionary *dict, NSDictionary *row) {
             NSString *employeeName = [NSString stringWithFormat:@"%@ %@", row[@"FirstName"], row[@"LastName"]];
             [dict setValue:row[@"EmployeeSales"] forKey:employeeName];
         }];
}

- (NSDictionary *)ordersPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter
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
         withResultDictionary:^(NSMutableDictionary *dict, NSDictionary *row) {
             [dict setValue:row[@"CategoryOrders"] forKey:row[@"CategoryName"]];
         }];

}

- (NSDictionary *)ordersPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter
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
         withResultDictionary:^(NSMutableDictionary *dict, NSDictionary *row) {
             NSString *employeeName = [NSString stringWithFormat:@"%@ %@", row[@"FirstName"], row[@"LastName"]];
             [dict setValue:row[@"EmployeeOrders"] forKey:employeeName];
         }];
}

- (NSNumber *)totalOrdersForYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    NSDictionary *ordersPerCategory = [self ordersPerCategoryForYear:year quarter:quarter];
    NSArray *orders = [ordersPerCategory allValues];
    return [orders valueForKeyPath:@"@sum.self"];
}

- (NSNumber *)totalSalesForYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    NSDictionary *salesPerCategory = [self salesPerCategoryForYear:year quarter:quarter];
    NSArray *sales = [salesPerCategory allValues];
    return [sales valueForKeyPath:@"@sum.self"];
}

- (NSDictionary *)ordersPerShipperForYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    NSString *queryString = [NSString stringWithFormat:
         @"SELECT Shippers.CompanyName, "
          "Count(Orders.OrderID) AS ShipperOrders "
          "FROM Shippers "
          "JOIN    Orders ON Orders.ShipVia = Shippers.ShipperID "
          "WHERE Orders.ShippedDate BETWEEN DATETIME('%@') AND DATETIME('%@') "
          "GROUP BY Shippers.ShipperID",
          [self.ymdDF stringFromDate:[NSDate firstDayOfQuarter:quarter year:year]],
          [self.ymdDF stringFromDate:[NSDate lastDayOfQuarter:quarter year:year]]];
    return [self executeQuery:queryString
         withResultDictionary:^(NSMutableDictionary *dict, NSDictionary *row) {
             [dict setValue:row[@"ShipperOrders"] forKey:row[@"CompanyName"]];
         }];
    
}

- (NSDictionary *)salesPerWeek
{
    NSString *queryString = @"SELECT strftime('%W', Orders.OrderDate) AS Week, "
                             "strftime('%Y', Orders.OrderDate) AS Year, "
                             "strftime('%Y-%W', Orders.OrderDate) AS YearWeek, "
                             "Sum(([Order Details].UnitPrice*Quantity*(1-Discount)/100)*100) AS WeeklySales "
                             "FROM [Order Details] "
                             "JOIN Orders ON Orders.OrderID = [Order Details].OrderID "
                             "GROUP BY YearWeek";
    return [self executeQuery:queryString
         withResultDictionary:^(NSMutableDictionary *dict, NSDictionary *row) {
             // Create a date from the week and year
             NSDateComponents *cmpts = [NSDateComponents new];
             [cmpts setWeek:[row[@"Week"] integerValue]];
             [cmpts setYear:[row[@"Year"] integerValue]];
             NSDate *weekDate = [[NSCalendar currentCalendar] dateFromComponents:cmpts];
             [dict setObject:row[@"WeeklySales"] forKey:weekDate];
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

- (NSDictionary *)executeQuery:(NSString *)query withResultDictionary:(void(^)(NSMutableDictionary *dict, NSDictionary *row))map
{
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    for(NSDictionary *row in [self executeQuery:query]) {
        map(results, row);
    }
    return [results copy];
}

- (NSArray *)allValuesForQuery:(NSString *)query
{
    return [[self executeQuery:query] allRows];
}

@end
