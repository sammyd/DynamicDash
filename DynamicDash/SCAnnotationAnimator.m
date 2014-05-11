//
//  SCAnnotationAnimator.m
//  DynamicDash
//
//  Created by Sam Davies on 11/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCAnnotationAnimator.h"
#import <pop/POP.h>

@interface SCAnnotationAnimator ()

@property (nonatomic, strong) POPAnimatableProperty *verticalBandDateProperty;

@end

@implementation SCAnnotationAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.springSpeed = 4.0;
        self.springBounciness = 4.0;
        self.verticalBandDateProperty = [POPAnimatableProperty propertyWithName:@"com.shinobicontrols.annotationanimator" initializer:^(POPMutableAnimatableProperty *prop) {
            // read value
            prop.readBlock = ^(SChartAnnotationZooming *annotation, CGFloat values[]) {
                values[0] = [annotation.xValue timeIntervalSince1970];
                values[1] = [annotation.xValueMax timeIntervalSince1970];
            };
            // write value
            prop.writeBlock = ^(SChartAnnotationZooming *annotation, const CGFloat values[]) {
                annotation.xValue = [NSDate dateWithTimeIntervalSince1970:values[0]];
                annotation.xValueMax = [NSDate dateWithTimeIntervalSince1970:values[1]];
                [annotation.xAxis.chart redrawChart];
            };
            // dynamics threshold
            prop.threshold = 0.01;
        }];
    }
    return self;
}


- (void)animateVerticalBandAnnotation:(SChartAnnotationZooming *)annotation toDateRange:(SChartDateRange *)range
{
    // POP understand how to animate CGPoints, so let's use that
    CGPoint toValue = CGPointMake([range.minimumAsDate timeIntervalSince1970],
                                  [range.maximumAsDate timeIntervalSince1970]);
    
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = self.verticalBandDateProperty;
    anim.toValue = [NSValue valueWithCGPoint:toValue];
    anim.springBounciness = self.springBounciness;
    anim.springSpeed = self.springSpeed;
    [annotation pop_addAnimation:anim forKey:@"AnnotationMoveAnimation"];
}

@end
