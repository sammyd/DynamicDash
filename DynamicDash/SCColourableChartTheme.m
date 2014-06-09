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
        self.chartTitleStyle.textColor = theme.lightColour;
        self.chartTitleStyle.font = [self.chartTitleStyle.font fontWithSize:18];
        self.chartTitleStyle.overlapChartTitle = NO;
        self.chartTitleStyle.position = SChartTitlePositionBottomOrLeft;
        
        // Set some legend details
        self.legendStyle.showSymbols = YES;
        self.legendStyle.borderColor = [theme.lightColour colorWithAlphaComponent:0.8];
        self.legendStyle.borderWidth = @1;
        self.legendStyle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        self.legendStyle.fontColor = theme.lightColour;
        self.legendStyle.areaColor = [theme.lightColour colorWithAlphaComponent:0.3];
        self.legendStyle.cornerRadius = @5;
        
        // Axis settings
        self.xAxisStyle.lineColor = [theme.lightColour colorWithAlphaComponent:0.7];
        self.xAxisStyle.majorTickStyle.labelColor = theme.lightColour;
        self.xAxisStyle.majorTickStyle.tickLabelOrientation = TickLabelOrientationVertical;
        self.yAxisStyle.majorTickStyle.labelColor = theme.lightColour;
        self.yAxisStyle.titleStyle.textColor = theme.lightColour;
        self.yAxisStyle.lineWidth = @0;
        self.yAxisStyle.majorGridLineStyle.showMajorGridLines = YES;
        self.yAxisStyle.majorGridLineStyle.lineColor = [theme.lightColour colorWithAlphaComponent:0.7];
        self.yAxisStyle.majorGridLineStyle.lineWidth = @1.0;
        self.yAxisStyle.majorGridLineStyle.dashedMajorGridLines = YES;
        self.yAxisStyle.majorGridLineStyle.dashStyle = @[@2, @2];
        
        // Sort the series styles
        SChartColumnSeriesStyle *style = [self columnSeriesStyleForSeriesAtIndex:0 selected:NO];
        style.areaColor = [theme.midLightColour colorWithAlphaComponent:0.8];
        style.areaColorGradient = [theme.midLightColour colorWithAlphaComponent:0.8];
        
        SChartLineSeriesStyle *lineStyle = [self lineSeriesStyleForSeriesAtIndex:1 selected:NO];
        lineStyle.lineWidth = @4;
        lineStyle.areaLineColor = [UIColor colorWithWhite:1 alpha:0.8];
        lineStyle.showFill = YES;
        lineStyle.areaColor = [theme.lightColour colorWithAlphaComponent:0.7];
        lineStyle.areaColorLowGradient = [theme.darkColour colorWithAlphaComponent:0.8];
    }
    return self;
}

@end
