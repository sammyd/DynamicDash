//
//  SCDataPointAnimator.h
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>
#import <pop/POP.h>

@interface SCDataPointAnimator : NSObject

- (instancetype)initWithPostWriteCallback:(void(^)(void))callback;

@property (nonatomic, assign) CGFloat springBounciness;
@property (nonatomic, assign) CGFloat springSpeed;

- (void)animateDatapoint:(SChartDataPoint *)dp toValue:(id)value;

@end
