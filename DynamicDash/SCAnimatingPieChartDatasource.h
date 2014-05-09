//
//  SCAnimatingPieChartDatasource.h
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>
#import "SCColourTheme.h"

@interface SCAnimatingPieChartDatasource : NSObject

- (instancetype)initWithChart:(ShinobiChart *)chart categories:(NSArray *)categories;
- (void)animateToValuesInDictionary:(NSDictionary *)dict;
- (void)applyTheme:(id<SCColourTheme>)theme;

@end
