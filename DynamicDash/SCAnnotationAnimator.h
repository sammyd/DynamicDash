//
//  SCAnnotationAnimator.h
//  DynamicDash
//
//  Created by Sam Davies on 11/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>

@interface SCAnnotationAnimator : NSObject

@property (nonatomic, assign) CGFloat springBounciness;
@property (nonatomic, assign) CGFloat springSpeed;

- (void)animateVerticalBandAnnotation:(SChartAnnotationZooming *)annotation toDateRange:(SChartDateRange *)range;

@end
