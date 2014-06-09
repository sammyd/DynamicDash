//
//  SCOrderDetail.h
//  DynamicDash
//
//  Created by Sam Davies on 09/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCOrderDetail : NSObject

+ (instancetype)orderDetailWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)propertyNames;
+ (NSArray *)propertyTitles;

// Computed properties
@property (nonatomic, readonly) NSString *employeeName;

@end
