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


- (NSArray *)productCategories;
- (NSArray *)employeeNames;
- (NSArray *)shippers;

- (NSDictionary *)salesPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSDictionary *)salesPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSDictionary *)ordersPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSDictionary *)ordersPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSNumber *)totalOrdersForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSNumber *)totalSalesForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSDictionary *)ordersPerShipperForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSDictionary *)salesPerWeek;


@end
