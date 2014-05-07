//
//  SCChinookData.m
//  DynamicDash
//
//  Created by Sam Davies on 06/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCChinookData.h"
#import <sqlite3-objc/Sqlite3/Sqlite.h>
#import <ShinobiCharts/ShinobiChart.h>

@interface SCChinookData ()

@property (nonatomic, strong) SLDatabase *database;

@end


@implementation SCChinookData

- (instancetype)init
{
    self = [super init];
    if(self) {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Chinook_Sqlite" ofType:@"sqlite"];
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
    SLStatement *statement = [self.database prepareQuery:@"SELECT * FROM 'Invoice'" error:&error];
    if(error) {
        NSLog(@"There was an error with the query %@", error);
        return nil;
    }
    
    static NSDateFormatter *dateFormatter = nil;
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSMutableArray *datapoints = [NSMutableArray new];
    
    for(NSDictionary *result in statement) {
        SChartDataPoint *dp = [SChartDataPoint new];
        dp.xValue = [dateFormatter dateFromString:result[@"InvoiceDate"]];
        dp.yValue = result[@"Total"];
        [datapoints addObject:dp];
    }
    
    return [datapoints copy];
}

@end
