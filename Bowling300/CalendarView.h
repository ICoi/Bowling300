//
//  CalendarViewController.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordViewController.h"
@interface CalendarView : UIView

@property (strong, nonatomic) IBOutlet RecordViewController *recordVC;
- (void)setYear:(NSInteger)inYear setMonth:(NSInteger)inMonth;
- (void)drawMonthly;
- (void)setCalendarSetting;
@end