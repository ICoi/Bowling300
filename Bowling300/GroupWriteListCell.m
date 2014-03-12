//
//  GroupWriteListCell.m
//  Bowling300
//
//  Created by 정다운 on 2014. 3. 12..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupWriteListCell.h"
#import <UIImageView+AFNetworking.h>
@implementation GroupWriteListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setValueWithTitle:(NSString *)inTitle withName:(NSString *)inName withDate:(NSString *)inDate withImageURL:(NSString *)inImageURL{
    self.titleLabe.text = inTitle;
    self.nameLabel.text = inName;
    self.dateLabel.text = inDate;
    NSURL *url = [NSURL URLWithString:inImageURL];
    [self.backgroundImg setImageWithURL:url];
}

-(void)setValueWithTitle:(NSString *)inTitle withName:(NSString *)inName withDate:(NSString *)inDate{
    self.titleLabe.text = inTitle;
    self.nameLabel.text = inName;
    self.dateLabel.text = inDate;
}

@end
