//
//  SCMultiAxisCategoryDataSource.h
//  DynamicDash
//
//  Created by Sam Davies on 07/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>
#import "SCColourTheme.h"

@interface SCMultiAxisCategoryDataSource : NSObject

- (instancetype)initWithChart:(ShinobiChart *)chart categories:(NSArray *)categories;

@property (nonatomic, strong, readonly) ShinobiChart *chart;
@property (nonatomic, strong, readonly) NSArray *categories;
@property (nonatomic, strong, readonly) NSArray *yAxes;

- (void)animateToValues:(NSArray *)values;
- (void)animateToValuesInDictionary:(NSDictionary *)dict;
- (void)applyTheme:(id<SCColourTheme>)theme;

@end
