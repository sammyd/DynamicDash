//
//  SCViewController.h
//  DynamicDash
//
//  Created by Sam Davies on 05/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiCharts/ShinobiChart.h>
#import <ShinobiGauges/ShinobiGauges.h>
#import "SCRangeHighlightChart.h"

@interface SCViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dashboardTitle;


@property (weak, nonatomic) IBOutlet UIView *dateDrillDownContainer;
@property (weak, nonatomic) IBOutlet UILabel *dateDrillDownTitle;
@property (weak, nonatomic) IBOutlet ShinobiChart *employeeChart;
@property (weak, nonatomic) IBOutlet ShinobiChart *categoryChart;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yearSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *quarterSegment;
- (IBAction)handleSegmentChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colourSegment;

@property (weak, nonatomic) IBOutlet SGaugeRadial *ordersGauge;
@property (weak, nonatomic) IBOutlet SGaugeRadial *salesGauge;
@property (weak, nonatomic) IBOutlet ShinobiChart *shippersChart;
@property (weak, nonatomic) IBOutlet SCRangeHighlightChart *weeklySalesChart;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabels;

@end
