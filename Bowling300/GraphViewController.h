//
//  GraphViewController.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLPieChart.h"
#import "BarLineChart.h"
@interface GraphViewController : UIViewController
@property (nonatomic, retain) IBOutlet DLPieChart *pieChartView;
@property (nonatomic, retain) IBOutlet BarLineChart *barChartView;
@end
