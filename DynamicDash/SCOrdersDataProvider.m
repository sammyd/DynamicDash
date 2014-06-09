//
//  SCOrdersDataProvider.m
//  DynamicDash
//
//  Created by Sam Davies on 07/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCOrdersDataProvider.h"

@interface SCOrdersDataProvider ()

@property (nonatomic, strong, readwrite) ShinobiDataGrid *dataGrid;
@property (nonatomic, strong) SDataGridDataSourceHelper *datasourceHelper;

@end


@implementation SCOrdersDataProvider

- (id)initWithDataGrid:(ShinobiDataGrid *)dataGrid orders:(NSArray *)orders
{
    self = [super init];
    if(self) {
        self.dataGrid = dataGrid;
        [self commonInit];
        self.orders = orders;
    }
    return self;
}

- (void)commonInit
{
    self.datasourceHelper = [[SDataGridDataSourceHelper alloc] initWithDataGrid:self.dataGrid];
    
    // Prepare columns
    NSArray *columnSpecs = @[
                             @[@"ID", @"OrderID"],
                             @[@"Date", @"OrderDate"],
                             @[@"Required", @"RequiredDate"],
                             @[@"Shipped", @"ShippedDate"],
                             @[@"First", @"FirstName"],
                             @[@"Last", @"LastName"],
                             @[@"Company", @"CompanyName"],
                             @[@"Total", @"OrderTotal"]
                             ];
    
    [columnSpecs enumerateObjectsUsingBlock:^(NSArray *colSpec, NSUInteger idx, BOOL *stop) {
        SDataGridColumn *col = [SDataGridColumn columnWithTitle:colSpec[0] forProperty:colSpec[1]];
        [self.dataGrid addColumn:col];
    }];
}

- (void)setOrders:(NSArray *)orders
{
    if(orders != _orders) {
        _orders = orders;
        [self updateData];
    }
}

#pragma mark - Utility methods
- (void)updateData
{
    self.datasourceHelper.data = self.orders;
}

@end
