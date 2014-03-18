//
//  WriteReplyCell.m
//  Bowling300
//
//  Created by 정다운 on 2014. 3. 19..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "WriteReplyCell.h"

@implementation WriteReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setvalueWithTitle:(NSString *)inTitle withWriter:(NSString *)inWriter withDate:(NSString *)inDate{
    self.titleLabel.text = inTitle;
    self.writerLabel.text = inWriter;
    self.dateLabel.text = inDate;
}
@end
