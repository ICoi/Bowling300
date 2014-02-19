//
//  CalendarDateCell.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDateCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ballImg;
- (void)setValueWithDate:(NSString *)inDate withClicked:(BOOL)inCK withDay:(NSInteger)inDay;
- (void)hasData;
- (void)noData;
@end

