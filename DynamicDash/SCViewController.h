//
//  SCViewController.h
//  DynamicDash
//
//  Created by Sam Davies on 05/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiCharts/ShinobiChart.h>

@interface SCViewController : UIViewController

@property (weak, nonatomic) IBOutlet ShinobiChart *employeeChart;
@property (weak, nonatomic) IBOutlet ShinobiChart *categoryChart;

@end
