//
//  SCNorthwindData.h
//  DynamicDash
//
//  Created by Sam Davies on 06/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNorthwindData : NSObject

- (NSArray *)invoiceData;

#pragma mark - Categorical data
- (NSArray *)productCategories;
- (NSArray *)employeeNames;
- (NSArray *)shippers;

#pragma mark - Summary Data
- (NSDictionary *)salesPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSDictionary *)salesPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSDictionary *)ordersPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSDictionary *)ordersPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSNumber *)totalOrdersForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSNumber *)totalSalesForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSNumber *)totalSalesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSDictionary *)ordersPerShipperForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSDictionary *)salesPerWeek;

#pragma mark - Time-based data queries
- (NSDictionary *)salesPerEmployeeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSDictionary *)salesPerCategoryFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSDictionary *)ordersPerEmployeeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSDictionary *)ordersPerCategoryFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

#pragma mark - Orders Data
- (NSArray *)orderDetailsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;


@end
