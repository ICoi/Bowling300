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
        self.dateLabel.textColor = [UIColor colorWithRed:0.0 green:((float)194/255) blue:((float)194/255) alpha:0.8];
    }else if(inDay== 0){
        //일요일인경우
        self.dateLabel.textColor = [UIColor colorWithRed:1.0 green:((float)115/255) blue:0.0 alpha:0.8];
    }else{
        self.dateLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
    if(inCK){
        self.backgroundButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    }else{
        self.backgroundButton.backgroundColor = [UIColor clearColor];
    }
    
    self.dateLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
}
- (void)setClicked:(BOOL)inCK{
    if(inCK){
        self.backgroundButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    }else{
        self.backgroundButton.backgroundColor = [UIColor clearColor];
    }
}

- (void)hasData{
    [self.ballImg setHidden:NO];
}
- (void)noData{
    [self.ballImg setHidden:YES];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
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
