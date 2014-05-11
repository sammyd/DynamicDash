//
//  SCSIMultiplierGaugeLabelDelegate.m
//  DynamicDash
//
//  Created by Sam Davies on 11/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCSIMultiplierGaugeLabelDelegate.h"

@implementation SCSIMultiplierGaugeLabelDelegate

#pragma mark - SGaugeDelegate methods

- (void)gauge:(SGauge *)gauge alterTickLabel:(UILabel *)tickLabel atValue:(float)value
{
    if(value > 1000) {
        tickLabel.text = [NSString stringWithFormat:@"%0.0fk", value / 1000];
        tickLabel.textAlignment = NSTextAlignmentCenter;
    }
}

@end
