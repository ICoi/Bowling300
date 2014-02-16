//
//  BarLineChart.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarLineChart : UIView
- (void)setDataForBarLineChar;
- (void)setDataForBarLineCharWithGroupNum:(NSInteger)inGroupNum;
- (void)setDataForBarLineCharWithYear:(NSInteger)inYear;
@end
