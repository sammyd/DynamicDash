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
        self.chartStyle.backgroundColor = [UIColor clearColor];
        self.chartStyle.plotAreaBackgroundColor = [UIColor clearColor];
        self.chartStyle.canvasBackgroundColor = [UIColor clearColor];
        self.chartTitleStyle.textColor = theme.darkColour;
        self.chartTitleStyle.font = [self.chartTitleStyle.font fontWithSize:18];
        self.chartTitleStyle.overlapChartTitle = YES;
        
        // Set some legend details
        self.legendStyle.showSymbols = YES;
        self.legendStyle.borderColor = theme.darkColour;
        self.legendStyle.fontColor = theme.darkColour;
        self.legendStyle.areaColor = [theme.lightColour colorWithAlphaComponent:0.4];
        
        // Axis settings
        self.xAxisStyle.lineColor = theme.darkColour;
        self.xAxisStyle.majorTickStyle.labelColor = theme.lightColour;
        self.xAxisStyle.majorTickStyle.tickLabelOrientation = TickLabelOrientationVertical;
        self.yAxisStyle.lineColor = theme.darkColour;
        self.yAxisStyle.majorTickStyle.labelColor = theme.darkColour;
        self.yAxisStyle.titleStyle.textColor = theme.darkColour;
        
        // Sort the series styles
        SChartColumnSeriesStyle *style = [self columnSeriesStyleForSeriesAtIndex:0 selected:NO];
        style.areaColor = theme.midDarkColour;
        style.areaColorGradient = theme.midDarkColour;
        
        SChartLineSeriesStyle *lineStyle = [self lineSeriesStyleForSeriesAtIndex:1 selected:NO];
        lineStyle.lineWidth = @4;
    }
    return self;
}

@end
