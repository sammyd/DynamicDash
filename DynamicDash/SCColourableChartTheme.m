//
//  SCColourableChartTheme.m
//  DynamicDash
//
//  Created by Sam Davies on 08/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCColourableChartTheme.h"

@implementation SCColourableChartTheme

+ (instancetype)themeWithColourTheme:(id<SCColourTheme>)theme
{
    return [[self alloc] initWithColourTheme:theme];
}

- (instancetype)initWithColourTheme:(id<SCColourTheme>)theme
{
    self = [super init];
    if(self) {
        // Set some chart colors
        self.chartStyle.backgroundColor = theme.midColour;
        self.chartStyle.plotAreaBackgroundColor = theme.midColour;
        self.chartStyle.canvasBackgroundColor = theme.midColour;
        
        // Axis settings
        self.xAxisStyle.lineColor = theme.darkColour;
        self.xAxisStyle.majorTickStyle.labelColor = theme.lightColour;
        self.xAxisStyle.majorTickStyle.tickLabelOrientation = TickLabelOrientationVertical;
        self.yAxisStyle.lineColor = theme.darkColour;
        self.yAxisStyle.majorTickStyle.labelColor = theme.lightColour;

    }
    return self;
}

@end
