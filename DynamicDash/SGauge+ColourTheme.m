//
//  SGauge+ColourTheme.m
//  DynamicDash
//
//  Created by Sam Davies on 11/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SGauge+ColourTheme.h"

@implementation SGauge (ColourTheme)

- (void)applyColourTheme:(id<SCColourTheme>)theme
{
    self.style.bevelWidth = 5;
    self.style.showGlassEffect = NO;
    self.style.bevelPrimaryColor = [UIColor clearColor];
    self.style.bevelSecondaryColor = [UIColor clearColor];
    self.style.innerBackgroundColor = [UIColor clearColor];
    self.style.outerBackgroundColor = [UIColor clearColor];
    self.style.needleBorderWidth = 0;
    self.style.needleColor = theme.midDarkColour;
    self.style.tickLabelColor = theme.darkColour;
    self.style.tickBaselineColor = theme.darkColour;
    self.style.majorTickColor = theme.darkColour;
    self.style.knobColor = theme.darkColour;
    self.style.knobBorderWidth = 0;
    self.style.knobRadius = 10;
    self.style.needleWidth = 12;
    
    self.style.qualitativeRangeInnerPosition = 0.85;
    self.style.qualitativeRangeOuterPosition = 0.95;
}

@end
