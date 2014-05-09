//
//  SGauge+SpringAnimation.m
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SGauge+SpringAnimation.h"
#import <POP/POP.h>

@implementation SGauge (SpringAnimation)

- (void)springAnimateToValue:(CGFloat)value
{
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.toValue = @(value);
    anim.fromValue = @(self.value);
    anim.property = [[self class] animateableValueProperty];
    anim.springBounciness = 12;
    anim.springSpeed = 4;
    [self pop_addAnimation:anim forKey:@"value"];
}


+ (POPAnimatableProperty *)animateableValueProperty
{
    static POPAnimatableProperty *property = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        property = [POPAnimatableProperty propertyWithName:@"com.shinobicontrols.gauges.value"
                                               initializer:^(POPMutableAnimatableProperty *prop) {
           // read value
           prop.readBlock = ^(SGauge *gauge, CGFloat values[]) {
               values[0] = gauge.value;
           };
           // write value
           prop.writeBlock = ^(SGauge *gauge, const CGFloat values[]) {
               gauge.value = values[0];
           };
           // dynamics threshold
           prop.threshold = 0.01;
       }];
    });
    
    return property;
}

@end
