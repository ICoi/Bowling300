//
//  WriteRecordViewController.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteRecordViewController : UIViewController
@property NSInteger nowYear;
@property NSInteger nowMonth;
@property NSInteger nowDate;
- (void)setYear:(NSInteger)inYear withMonth:(NSInteger)inMonth withDate:(NSInteger)inDate;
@end
