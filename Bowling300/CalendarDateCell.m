//
//  CalendarDateCell.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "CalendarDateCell.h"
@interface CalendarDateCell()

@end
@implementation CalendarDateCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setValueWithDate:(NSString *)inDate withClicked:(BOOL)inCK withDay:(NSInteger)inDay{
    self.dateLabel.text = inDate;
    
    if (inDay == 6){
        //토요일인경우
        self.dateLabel.textColor = [UIColor blueColor];
    }else if(inDay== 0){
        //일요일인경우
        self.dateLabel.textColor = [UIColor redColor];
    }else{
        self.dateLabel.textColor = [UIColor whiteColor];
    }
    if(inCK){
        self.backgroundButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    }else{
        self.backgroundButton.backgroundColor = [UIColor clearColor];
    }
}
- (void)setClicked:(BOOL)inCK{
    if(inCK){
        self.backgroundButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    }else{
        self.backgroundButton.backgroundColor = [UIColor clearColor];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
