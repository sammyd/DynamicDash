//
//  SCColourableChartTheme.h
//  DynamicDash
//
//  Created by Sam Davies on 08/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>
#import "SCColourTheme.h"

@interface SCColourableChartTheme : SChartiOS7Theme

+ (instancetype)themeWithColourTheme:(id<SCColourTheme>)theme;
- (instancetype)initWithColourTheme:(id<SCColourTheme>)theme;

@end
