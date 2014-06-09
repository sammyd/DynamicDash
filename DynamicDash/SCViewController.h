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
#import <ShinobiGrids/ShinobiDataGrid.h>
#import "SCRangeHighlightChart.h"

@interface SCViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dashboardTitle;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabels;

@property (weak, nonatomic) IBOutlet UIView *dateDrillDownContainer;
@property (weak, nonatomic) IBOutlet UILabel *dateDrillDownTitle;
@property (weak, nonatomic) IBOutlet ShinobiChart *employeeChart;
@property (weak, nonatomic) IBOutlet ShinobiChart *categoryChart;
@property (weak, nonatomic) IBOutlet SCRangeHighlightChart *weeklySalesChart;

@property (weak, nonatomic) IBOutlet UIView *summaryContainer;
@property (weak, nonatomic) IBOutlet SGaugeRadial *ordersGauge;
@property (weak, nonatomic) IBOutlet ShinobiChart *shippersChart;
@property (weak, nonatomic) IBOutlet ShinobiDataGrid *ordersDataGrid;

@property (weak, nonatomic) IBOutlet UISegmentedControl *colourSegment;
- (IBAction)handleSegmentChanged:(id)sender;



@end
