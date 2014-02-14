//
//  CalendarDayCell.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "CalendarDayCell.h"
@interface CalendarDayCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@end


@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setValueWithDay:(NSInteger)inNum{
    self.dayLabel.text=  [self showDayString:inNum];
    
    if (inNum == 0) {
        // 일요일인경우
        self.dayLabel.textColor = [UIColor colorWithRed:1.0 green:((float)115/255) blue:0.0 alpha:0.8];
    }else if(inNum == 6){
        // 토요일인경우
        self.dayLabel.textColor = [UIColor colorWithRed:0.0 green:((float)194/255) blue:((float)194/255) alpha:0.8];
    }else{
        self.dayLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
    self.dayLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
}


// 해당 숫자에 맞는 요일을 리턴해주는 함수
// 0 : 일요일 1: 월요일 2: 화요일 3: 수요일 4: 목요일 5: 금요일 6: 토요일
- (NSString *)showDayString:(NSInteger)inNum{
    NSString *tmpString = [NSString stringWithFormat:@""];
    switch ((int)inNum) {
        case 0:
            tmpString = [tmpString stringByAppendingString:@"S"];
            break;
        case 1:
            tmpString = [tmpString stringByAppendingString:@"M"];
            break;
        case 2:
            tmpString = [tmpString stringByAppendingString:@"T"];
            break;
        case 3:
            tmpString = [tmpString stringByAppendingString:@"W"];
            break;
        case 4:
            tmpString = [tmpString stringByAppendingString:@"T"];
            break;
        case 5:
            tmpString = [tmpString stringByAppendingString:@"F"];
            break;
        case 6:
            tmpString = [tmpString stringByAppendingString:@"S"];
            break;
        default:
            break;
    }
    return tmpString;
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
