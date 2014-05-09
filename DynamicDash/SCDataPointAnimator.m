//
//  SCDataPointAnimator.m
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCDataPointAnimator.h"

@interface SCDataPointAnimator ()

@property (nonatomic, strong, readwrite) POPAnimatableProperty *animateableProperty;
@property (nonatomic, copy) void (^postWriteCallback)(void);

@end

@implementation SCDataPointAnimator

- (instancetype)initWithPostWriteCallback:(void (^)(void))callback
{
    self = [super init];
    if (self) {
        self.postWriteCallback = callback;
        self.springBounciness = 12.0;
        self.springSpeed = 4.0;
        
        self.animateableProperty = [POPAnimatableProperty propertyWithName:@"com.shinobicontrols.popgoesshinobi.animatingdatasource" initializer:^(POPMutableAnimatableProperty *prop) {
            // read value
            prop.readBlock = ^(SChartDataPoint *dp, CGFloat values[]) {
                values[0] = [dp.yValue floatValue];
            };
            // write value
            prop.writeBlock = ^(SChartDataPoint *dp, const CGFloat values[]) {
                dp.yValue = @(MAX(values[0], 0));
                self.postWriteCallback();
            };
            // dynamics threshold
            prop.threshold = 0.01;
        }];
    }
    return self;
}

- (void)animateDatapoint:(SChartDataPoint *)dp toValue:(id)value
{
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = self.animateableProperty;
    anim.fromValue = dp.yValue;
    anim.toValue = value;
    anim.springBounciness = self.springBounciness;
    anim.springSpeed = self.springSpeed;
    
    [dp pop_addAnimation:anim forKey:@"ValueChangeAnimation"];
}

@end
