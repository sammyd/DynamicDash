//
//  NSDate+Quarterly.h
//  DynamicDash
//
//  Created by Sam Davies on 07/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Quarterly)

+ (instancetype)firstDayOfQuarter:(NSUInteger)quarter year:(NSInteger)year;
+ (instancetype)lastDayOfQuarter:(NSUInteger)quarter year:(NSInteger)year;

@end
