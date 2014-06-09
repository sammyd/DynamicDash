//
//  SCOrdersDataProvider.m
//  DynamicDash
//
//  Created by Sam Davies on 07/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCOrdersDataProvider.h"
#import "SCOrderDetail.h"

@interface SCOrdersDataProvider () <SDataGridDataSourceHelperDelegate>

@property (nonatomic, strong, readwrite) ShinobiDataGrid *dataGrid;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, strong) SDataGridDataSourceHelper *datasourceHelper;

@end


@implementation SCOrdersDataProvider

- (id)initWithDataGrid:(ShinobiDataGrid *)dataGrid orders:(NSArray *)orders
{
    self = [super init];
    if(self) {
        self.dataGrid = dataGrid;
        [self commonInit];
        [self createOrdersFromDicts:orders];
    }
    return self;
}

- (void)commonInit
{
    self.datasourceHelper = [[SDataGridDataSourceHelper alloc] initWithDataGrid:self.dataGrid];
    self.datasourceHelper.delegate = self;
    
    // Prepare columns
    NSArray *propertyNames = [SCOrderDetail propertyNames];
    NSArray *propertyTitles = [SCOrderDetail propertyTitles];
    NSArray *columnWidths = @[@50, @80, @80, @80, @160, @110, @70];
    
    [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        SDataGridColumn *col = [SDataGridColumn columnWithTitle:propertyTitles[idx] forProperty:propertyName];
        col.width = columnWidths[idx];
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
- (void)createOrdersFromDicts:(NSArray *)dicts
{
    NSMutableArray *orders = [NSMutableArray array];
    [dicts enumerateObjectsUsingBlock:^(NSDictionary *orderDict, NSUInteger idx, BOOL *stop) {
        SCOrderDetail *order = [SCOrderDetail orderDetailWithDictionary:orderDict];
        [orders addObject:order];
    }];
    self.orders = [orders copy];
}

- (void)updateData
{
    self.datasourceHelper.data = self.orders;
}

#pragma mark - SDataGridDataSourceHelperDelegate methods
- (id)dataGridDataSourceHelper:(SDataGridDataSourceHelper *)helper displayValueForProperty:(NSString *)propertyKey withSourceObject:(id)object
{
    if([propertyKey hasSuffix:@"Date"]) {
        id date = [object valueForKey:propertyKey];
        if(date == [NSNull null]) {
            return @"-";
        }
        // We must have an NSDate
        static NSDateFormatter *df = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            df = [NSDateFormatter new];
            df.dateStyle = NSDateFormatterShortStyle;
            df.locale = [NSLocale systemLocale];
        });
        return [df stringFromDate:date];
    }
    // By default
    return nil;
}

@end
