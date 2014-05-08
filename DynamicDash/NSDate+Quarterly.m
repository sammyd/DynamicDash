//
//  NSDate+Quarterly.m
//  DynamicDash
//
//  Created by Sam Davies on 07/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "NSDate+Quarterly.h"

@implementation NSDate (Quarterly)

+ (instancetype)firstDayOfQuarter:(NSUInteger)quarter year:(NSInteger)year
{
    if(quarter < 1 || quarter > 4) {
        NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
                                                  reason:@"Quarters are labelled 1-4"
                                                userInfo:nil];
        @throw ex;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [NSDateComponents new];
    [components setDay:1];
    [components setMonth:(quarter * 3 + 1)];
    [components setYear:year];
    return [calendar dateFromComponents:components];
}

+ (instancetype)lastDayOfQuarter:(NSUInteger)quarter year:(NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [NSDateComponents new];
    
    NSDate *startOfNextQuarter;
    
    if(quarter < 4) {
        startOfNextQuarter = [NSDate firstDayOfQuarter:(quarter + 1) year:year];
    } else {
        startOfNextQuarter = [NSDate firstDayOfQuarter:1 year:(year + 1)];
    }
    
    [components setDay:-1];
    
    return [calendar dateByAddingComponents:components toDate:startOfNextQuarter options:0];
}

@end
