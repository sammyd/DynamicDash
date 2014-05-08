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

- (NSArray *)salesPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSArray *)salesPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSArray *)ordersPerEmployeeForYear:(NSUInteger)year quarter:(NSUInteger)quarter;
- (NSArray *)ordersPerCategoryForYear:(NSUInteger)year quarter:(NSUInteger)quarter;

@end
