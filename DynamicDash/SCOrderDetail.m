//
//  SCOrderDetail.m
//  DynamicDash
//
//  Created by Sam Davies on 09/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCOrderDetail.h"

@interface SCOrderDetail ()

@property (nonatomic, strong) NSDictionary *backingDictionary;

@end

@implementation SCOrderDetail

+ (instancetype)orderDetailWithDictionary:(NSDictionary *)dictionary
{
    return [[[self class] alloc] initWithDictionary:dictionary];
}

+ (NSArray *)propertyNames
{
    return @[@"OrderID", @"OrderDate", @"RequiredDate", @"ShippedDate",
             @"CompanyName", @"employeeName", @"OrderTotal" ];
}

+ (NSArray *)propertyTitles
{
    return @[@"ID", @"Ordered", @"Required", @"Shipped",
            @"Customer", @"Sold By", @"Total"];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self) {
        self.backingDictionary = dictionary;
    }
    return self;
}

- (NSString *)employeeName
{
    return [NSString stringWithFormat:@"%@ %@", self.backingDictionary[@"FirstName"],
                                                self.backingDictionary[@"LastName"]];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    // Proxy the backing dictionary for values we haven't overridden
    id fromDict = [self.backingDictionary valueForKey:key];
    if(fromDict && [key hasSuffix:@"Date"] && fromDict != [NSNull null]) {
        // Convert to an NSDate if it ends in a date
        static NSDateFormatter *df = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            df = [NSDateFormatter new];
            df.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        });
        fromDict = [df dateFromString:fromDict];
    }
    return fromDict;
}

@end
