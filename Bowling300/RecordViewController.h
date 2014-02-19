//
//  RecordViewController.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UIViewController
- (void)drawBarchartWithAverageScore:(NSInteger)inAverage withHighScore:(NSInteger)inHighScore withLowScore:(NSInteger)inLowScore withGameCnt:(NSInteger)inGameCnt isMonthly:(BOOL)isMonthly;
- (void)setYear:(NSInteger)inYear withMonth:(NSInteger)inMonth withDate:(NSInteger)inDate;
@end
