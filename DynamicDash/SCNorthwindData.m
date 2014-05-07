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

@interface SCNorthwindData ()

@property (nonatomic, strong) SLDatabase *database;

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

@end
