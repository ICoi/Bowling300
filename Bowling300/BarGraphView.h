//
//  BarGraphViewController.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarGraphView : UIView
- (void)drawBarchartWithAverageScore:(NSInteger)inAverage withHighScore:(NSInteger)inHighScore withLowScore:(NSInteger)inLowScore withGameCnt:(NSInteger)inGameCnt isMonthly:(BOOL)isMonthly;
@end
